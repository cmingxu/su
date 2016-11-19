class DownloadFromSystem < Action::Base
  def invoke
    skp_file_path = params.split('|')[0]
    f = File.open(File.join($SKP_PATH, "s_#{File.basename(skp_file_path)}"), "w")
    f << open(skp_file_path).read
    f.close

    icon_file_path = params.split('|')[1]
    f = File.open(File.join($SKP_PATH, "s_#{File.basename(icon_file_path)}"), "w")
    f << open(icon_file_path).read
    f.fsync
    f.close

    ctx.update_js_value(dialog, "local_models", ctx.local_models.to_json)
  end
end
