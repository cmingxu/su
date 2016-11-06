class ReplaceByName < Action::Base
  def invoke
      ctx.logger.debug "replace active_model by model #{params}"
      model = Sketchup.active_model

      ctx.logger.debug model.selection.first.typename

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
        ctx.logger.debug "selection is not a valid component instance"
      end
  end
end
