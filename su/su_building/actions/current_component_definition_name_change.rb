class CurrentComponentDefinitionNameChange < Action::Base
  def invoke
    ctx.logger.debug "updating name to #{params}"
    model = Sketchup.active_model
    current_entity = model.selection.first
    if current_entity.is_a?(Sketchup::ComponentInstance)
      current_entity.definition.name = params
    end
  end
end
