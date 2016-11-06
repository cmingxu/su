module Helper
  def humanize_file_size(size)
    if size > 2 ** 30
      sprintf "%.1fG" % (size.to_f / 2 ** 30)
    elsif size > 2 ** 20
      sprintf "%.1fM" % (size.to_f / 2 ** 20)
    elsif size > 2 ** 10
      sprintf "%.1fK" % (size.to_f / 2 ** 10)
    else
      sprintf "%d" % size
    end
  end

  def base64_icon(icon_path)
    return "" if icon_path == ""
    $logger.debug File.read(icon_path).length
    file = File.open(icon_path, "rb")
    $logger.debug file.read.length
    file.rewind
    base64string = Base64.encode64(file.read).gsub("\n", "")
    file.close
    "data:image/png;base64,#{base64string}"
  end

  def local_models
    Dir.glob($SKP_PATH + File::Separator + "*.skp").map do |f|
      icon_path = File.join($SKP_PATH, File.basename(f).split(".")[0] + ".png")
      $logger.debug icon_path
      $logger.debug File.exists?(icon_path)
      {
        :name => File.basename(f),
        :skp_file_size => humanize_file_size(File.stat(f).size),
        :created_at_normal => File.stat(f).ctime.strftime("%m月%d日"),
        :icon => base64_icon(File.exists?(icon_path) ? icon_path : ""),
        :path => f
      }
    end
  end
end
