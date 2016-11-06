class RemoveLocalComponentDefinition < Action::Base
  def invoke
    FileUtils.rm_rf File.join($SKP_PATH, params)
    FileUtils.rm_rf File.join($SKP_PATH, params.sub(".skp", ".png"))

    ctx.update_js_value(dialog, "local_models", ctx.local_models.to_json)
  end
end
