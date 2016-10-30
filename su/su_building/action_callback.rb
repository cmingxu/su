Sketchup::require 'json'
Sketchup::require 'base64'
Sketchup::require 'open-uri'
Sketchup::require 'net/http'

module ActionCallback
  def humanize_file_size(size)
    if size > 2 ** 30
      sprintf "%.1fG" % (size.to_f / 2 ** 30)
    elsif size > 2 ** 20
      sprintf "%.1fM" % (size.to_f / 2 ** 20)
    elsif size > 2 ** 10
      sprintf "%.1fK" % (size.to_f / 2 ** 10)
    else
      sprintf "%d" % size
    end
  end

  def base64_icon(icon_path)
    return "" if icon_path == ""
    $logger.debug File.read(icon_path).length
    file = File.open(icon_path, "rb")
    $logger.debug file.read.length
    file.rewind
    base64string = Base64.encode64(file.read).gsub("\n", "")
    file.close
    "data:image/png;base64,#{base64string}"
  end

  def local_models
    Dir.glob($SKP_PATH + File::Separator + "*.skp").map do |f|
      icon_path = File.join($SKP_PATH, File.basename(f).split(".")[0] + ".png")
      $logger.debug icon_path
      $logger.debug File.exists?(icon_path)
      {
        :name => File.basename(f),
        :skp_file_size => humanize_file_size(File.stat(f).size),
        :created_at_normal => File.stat(f).ctime.strftime("%m月%d日"),
        :icon => base64_icon(File.exists?(icon_path) ? icon_path : ""),
        :path => f
      }
    end
  end

  def update_js_value(dialog, id, new_val)
    js_command = "var dom = document.getElementById('data_transfer_channel'); var scope = angular.element(dom).scope(); scope.$apply(function() { scope.#{id} = JSON.parse('#{new_val}');});"
    $logger.debug js_command
    dialog.execute_script(js_command)
  end

  def register_callbacks(dialog)
    dialog.add_action_callback('logger') do |action, params|
      $logger.debug params
    end

    dialog.add_action_callback('list_local_skps') do |action, params|
      files = Dir.glob($SKP_PATH + File::Separator + "*").map do |f|
        File.basename(f)
      end
      update_js_value(dialog, "skp_names", files.join(","))
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
      model = Sketchup.active_model
      selection = model.selection.first
      current_entity = {}
      case selection
      when NilClass
      when Sketchup::Edge
        current_entity = {:name => "Edge", :thumbnail_src => 'thumbnail.png', :type => "edge", :dynamic_attributes => {}}
      when Sketchup::ComponentInstance
        component_definition  = selection.definition
        dynamic_attributes = selection.attribute_dictionary("dynamic_attributes")
        component_definition_name = dynamic_attributes["_name"] if dynamic_attributes

        hash = {}
        dynamic_attributes.each_pair do |k, v|
          hash[k] = v
        end

        tmp_thumbnail_file_path = File.join($SKP_PATH, 'tmp_thumbnail.png')
        thumbnail_file_path = File.join($SKP_PATH, 'thumbnail.png')
        component_definition.refresh_thumbnail
        component_definition.save_thumbnail(tmp_thumbnail_file_path)

        FileUtils.cp tmp_thumbnail_file_path, thumbnail_file_path
        FileUtils.rm_rf tmp_thumbnail_file_path
        $logger.debug thumbnail_file_path
        file = File.open(thumbnail_file_path, "rb")
        file.rewind()
        $logger.debug file.read.length
        file.rewind()
        file.fsync
        file.rewind()
        $logger.debug file.read.length
        file.rewind()
        file.fsync
        base64string = Base64.encode64(file.read).gsub("\n", "")
        $logger.debug base64string
        file.close


        thumbnail_src = "data:image/png;base64,#{base64string}"
        current_entity = {:name => component_definition_name || component_definition.name,
                          :thumbnail_src => thumbnail_src,
                          :type => "component_definition",
                          :dynamic_attributes => hash }
      when Sketchup::Group
      when Sketchup::Face
      end

      # initiate current_model
      update_js_value(dialog, "current_entity", current_entity.to_json)

      # initiate local skps files
      update_js_value(dialog, "local_models", local_models.to_json)
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


  module_function :update_js_value, :register_callbacks, :local_models, :base64_icon, :humanize_file_size
end


