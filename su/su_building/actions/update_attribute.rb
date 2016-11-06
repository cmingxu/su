class UpdateAttribute < Action::Base
  def invoke
      ctx.logger.debug params
      model = Sketchup.active_model
      selection = model.selection.first
      dynamic_attributes = selection.attribute_dictionary("dynamic_attributes")
      hash = {}
      dynamic_attributes.each_pair do |k, v|
        hash[k] = v
      end

      ctx.logger.debug "dynamic_attributes #{params.split(":")[0]} #{params.split(":")[1]}"
      selection.set_attribute("dynamic_attributes", params.split(":")[0], params.split(":")[1])
      if selection.definition
        selection.definition.set_attribute("dynamic_attributes", params.split(":")[0], params.split(":")[1])
      end

      $dc_observers.get_latest_class.redraw_with_undo(selection)
  end
end
