class ReplaceByName < Action::Base
  def invoke
      ctx.logger.debug "replace active_model by model #{params}"
      model = Sketchup.active_model

      ctx.logger.debug model.selection.first.typename

      path = Sketchup.find_support_file params, File.join("plugins", "su_building", "skps")
      componentdefinition = model.definitions.load path
      Sketchup.active_model.start_operation("replace")
      entities_to_be_removed = []
      model.selection.each  do |sel|
        if sel.is_a?(Sketchup::ComponentInstance)
          trans = sel.transformation

          entities_to_be_removed.push sel
          instance = model.active_entities.add_instance componentdefinition, trans
          componentdefinition.attribute_dictionaries["dynamic_attributes"].each do |k, v|
            instance.set_attribute("dynamic_attributes", k, v)
          end
        end
      end

      model.active_entities.erase_entities entities_to_be_removed
      Sketchup.active_model.commit_operation
  end
end
