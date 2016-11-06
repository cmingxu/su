class ReplaceByName < Action::Base
  def invoke
      ctx.logger.debug "replace active_model by model #{params}"
      model = Sketchup.active_model

      ctx.logger.debug model.selection.first.typename

      path = Sketchup.find_support_file params, File.join("plugins", "su_building", "skps")
      componentdefinition = model.definitions.load path
      entities_to_be_removed = []
      model.selection.each  do |sel|
        if sel.is_a?(Sketchup::ComponentInstance)
          trans = sel.transformation

          entities_to_be_removed.push sel
          ctx.logger.debug sel.class
          instance = model.active_entities.add_instance componentdefinition, trans
          componentdefinition.attribute_dictionaries["dynamic_attributes"].each do |k, v|
            instance.set_attribute("dynamic_attributes", k, v)
          end
        end
      end

      model.active_entities.erase_entities entities_to_be_removed

      #if model.selection.first.is_a?(Sketchup::ComponentInstance)
      #path = Sketchup.find_support_file params, File.join("plugins", "su_building", "skps")
      #componentdefinition = model.definitions.load path
      #trans = model.selection.first.transformation
      #model.selection.first.erase!
      #instance = model.active_entities.add_instance componentdefinition, trans
      #componentdefinition.attribute_dictionaries["dynamic_attributes"].each do |k, v|
      #instance.set_attribute("dynamic_attributes", k, v)
      #end
      #else
      #ctx.logger.debug "selection is not a valid component instance"
      #end
  end
end
