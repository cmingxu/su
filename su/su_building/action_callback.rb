Sketchup::require 'json'
Sketchup::require 'base64'
Sketchup::require 'open-uri'
Sketchup::require 'net/http'

module ActionCallback

  def register_callbacks(dialog)

    dialog.add_action_callback('list_local_skps') do |action, params|
    end

    dialog.add_action_callback('save_current_component_definition') do |action, params|
      model = Sketchup.active_model
      current_entity = model.selection.first
      dynamic_attributes = current_entity.attribute_dictionary("dynamic_attributes")
      component_definition_name = dynamic_attributes["_name"] if dynamic_attributes
      if current_entity.is_a?(Sketchup::ComponentInstance) && current_entity.definition.name
        current_entity.definition.save_as File.join($SKP_PATH, "#{component_definition_name}.skp")
        thumbnail_file_path = File.join($SKP_PATH, "#{component_definition_name}.png")
        current_entity.definition.refresh_thumbnail
        current_entity.definition.save_thumbnail(thumbnail_file_path)

        update_js_value(dialog, "local_models", local_models.to_json)
      end
    end

    dialog.add_action_callback('current_component_definition_name_change') do |action, params|
      $logger.debug "updating name to #{params}"
      model = Sketchup.active_model
      current_entity = model.selection.first
      if current_entity.is_a?(Sketchup::ComponentInstance)
        current_entity.definition.name = params
      end
    end

    dialog.add_action_callback('replace_by_name') do |action, params|
      $logger.debug "replace active_model by model #{params}"
      model = Sketchup.active_model

      $logger.debug model.selection.first.typename

      if model.selection.first.is_a?(Sketchup::ComponentInstance)
        path = Sketchup.find_support_file params, File.join("plugins", "su_building", "skps")
        componentdefinition = model.definitions.load path
        trans = model.selection.first.transformation
        model.selection.first.erase!
        instance = model.active_entities.add_instance componentdefinition, trans
        componentdefinition.attribute_dictionaries["dynamic_attributes"].each do |k, v|
          instance.set_attribute("dynamic_attributes", k, v)
        end
      else
        $logger.debug "selection is not a valid component instance"
      end
    end

    dialog.add_action_callback('update_attribute') do |action, params|
      $logger.debug params
      model = Sketchup.active_model
      selection = model.selection.first
      dynamic_attributes = selection.attribute_dictionary("dynamic_attributes")
      hash = {}
      dynamic_attributes.each_pair do |k, v|
        hash[k] = v
      end
      $logger.debug hash
      $logger.debug selection.class

      $logger.debug "dynamic_attributes #{params.split(":")[0]} #{params.split(":")[1]}"
      selection.set_attribute("dynamic_attributes", params.split(":")[0], params.split(":")[1])
      if selection.definition
        selection.definition.set_attribute("dynamic_attributes", params.split(":")[0], params.split(":")[1])
      end
      $dc_observers.get_latest_class.redraw_with_undo(selection)
    end

    dialog.add_action_callback('remove_local_component_definition') do |action, params|
      $logger.debug "remove model #{params}"
      $logger.debug "remove #{File.join($SKP_PATH, params)}"
      $logger.debug "remove #{File.join($SKP_PATH, params.sub('.skp', '.png'))}"
      FileUtils.rm_rf File.join($SKP_PATH, params)
      FileUtils.rm_rf File.join($SKP_PATH, params.sub(".skp", ".png"))

      update_js_value(dialog, "local_models", local_models.to_json)
    end

    dialog.add_action_callback('upload_local_model') do |action, params|
      begin
        $logger.debug "upload model #{params}"
        $logger.debug "model name #{params.split("||")[0]}"
        $logger.debug "cookies name #{params.split("||")[1]}"

        model_name = params.split("||")[0]
        auth_token = params.split("||")[1]
        icon_name = model_name.gsub(File.extname(model_name),".png")

        uri = URI(BuildingUI::HOST + "/api/entities")
        http = Net::HTTP.new(uri.host, uri.port)
        req = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json', 'Auth-Token' => auth_token})
        req.body = {entity: { model_name: model_name,
                              icon_name: icon_name,
                              file_content: Base64.encode64(File.read(File.join($SKP_PATH, model_name))),
                              icon_content: Base64.encode64(File.read(File.join($SKP_PATH, icon_name)))
        }}.to_json
        http.request(req)
      rescue Exception => e
        $logger.error e
      end
    end

    dialog.add_action_callback('initialization') do |action, params|
    end

    dialog.add_action_callback('list_attribute_dictionaries') do |action, params|
      model = Sketchup.active_model
      current_entity = model.selection.first
      if current_entity
        current_entity.attribute_dictionaries.each do |dict|
          $logger.debug "1111111111 #{dict.name}"
          dict.each_pair do |k, v|
            $logger.debug "#{k} => #{v}"
          end
        end
      end

      current_entity.definition.entities.each do |sub_compo_def|
        sub_compo_def.attribute_dictionaries.each do |dict|
          $logger.debug "xxxxx1111111111 #{dict.name}"
          dict.each_pair do |k, v|
            $logger.debug "xxxxxxx   #{k} => #{v}"
          end
        end
      end
    end

    dialog.add_action_callback('insert_component_definition') do |action, params|
      #point = Geom::Point3d.new 10,20,30
      #transform = Geom::Transformation.new point
      #model = Sketchup.active_model
      #entities = model.active_entities
      #path = Sketchup.find_support_file "Bed.skp",
      #"Components/Components Sampler/"
      #definitions = model.definitions
      #componentdefinition = definitions.load path
      #instance = entities.add_instance componentdefinition, transform
      #point = componentdefinition.insertion_point
    end

    dialog.add_action_callback('download_from_system') do |action, params|
      skp_file_path = params.split('|')[0]
      f = File.open(File.join($SKP_PATH, "s_#{File.basename(skp_file_path)}"), "w")
      f << open(BuildingUI::HOST + skp_file_path).read
      f.fsync
      f.close

      icon_file_path = params.split('|')[1]

      f = File.open(File.join($SKP_PATH, "s_#{File.basename(icon_file_path)}"), "w")
      f.fsync
      f << open(BuildingUI::HOST + icon_file_path).read
      f.close

      update_js_value(dialog, "local_models", local_models.to_json)
    end

    dialog.add_action_callback('download_from_remote') do |action, params|
      skp_file_path = params.split('|')[0]
      f = File.open(File.join($SKP_PATH, "s_#{File.basename(skp_file_path)}"), "w")
      f << open(BuildingUI::HOST + skp_file_path).read
      f.close

      icon_file_path = params.split('|')[1]
      f = File.open(File.join($SKP_PATH, "s_#{File.basename(icon_file_path)}"), "w")
      f << open(BuildingUI::HOST + icon_file_path).read
      f.fsync
      f.close

      update_js_value(dialog, "local_models", local_models.to_json)
    end
  end


  #module_function :update_js_value, :register_callbacks, :local_models, :base64_icon, :humanize_file_size
end


