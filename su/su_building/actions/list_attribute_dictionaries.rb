class ListAttributeDictionaries < Action::Base
  def invoke
    model = Sketchup.active_model
    current_entity = model.selection.first
    if current_entity
      current_entity.attribute_dictionaries.each do |dict|
        dict.each_pair do |k, v|
          ctx.logger.debug "#{k} => #{v}"
        end
      end
    end

    current_entity.definition.entities.each do |sub_compo_def|
      sub_compo_def.attribute_dictionaries.each do |dict|
        dict.each_pair do |k, v|
          ctx.logger.debug "xxxxxxx   #{k} => #{v}"
        end
      end
    end
  end
end
