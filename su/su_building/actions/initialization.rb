class Initialization < Action::Base
  def invoke
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
      context.logger.debug thumbnail_file_path
      file = File.open(thumbnail_file_path, "rb")
      file.rewind()
      context.logger.debug file.read.length
      file.rewind()
      file.fsync
      file.rewind()
      context.logger.debug file.read.length
      file.rewind()
      file.fsync
      base64string = Base64.encode64(file.read).gsub("\n", "")
      context.logger.debug base64string
      file.close


      thumbnail_src = "data:image/png;base64,#{base64string}"
      current_entity = {:name => component_definition_name || component_definition.name,
                        :thumbnail_src => thumbnail_src,
                        :type => "component_definition",
                        :dynamic_attributes => hash }
    when Sketchup::Group
    when Sketchup::Face
    end

    context.load_session
    context.call_js_function(dialog, "data_transfer_channel", "auto_sign_in", context.current_user.to_json)

    # initiate current_model
    context.update_js_value(dialog, "current_entity", current_entity.to_json)

    # initiate local skps files
    context.update_js_value(dialog, "local_models", context.local_models.to_json)
  end
end
