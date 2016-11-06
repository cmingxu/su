class ListLocalSkps < Action::Base
  def invoke
    files = Dir.glob($SKP_PATH + File::Separator + "*").map do |f|
      File.basename(f)
    end
    ctx.update_js_value(dialog, "skp_names", files.join(","))
  end
end
