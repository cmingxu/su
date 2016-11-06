class SaveCurrentComponentDefinition < Action::Base
  def invoke
    model = Sketchup.active_model
    current_entity = model.selection.first
    dynamic_attributes = current_entity.attribute_dictionary("dynamic_attributes")
    component_definition_name = dynamic_attributes["_name"] if dynamic_attributes

    if current_entity.is_a?(Sketchup::ComponentInstance) && current_entity.definition.name
      current_entity.definition.save_as File.join($SKP_PATH, "#{component_definition_name}.skp")
      thumbnail_file_path = File.join($SKP_PATH, "#{component_definition_name}.png")
      current_entity.definition.refresh_thumbnail
      current_entity.definition.save_thumbnail(thumbnail_file_path)

      ctx.update_js_value(dialog, "local_models", ctx.local_models.to_json)
    end
  end
end
