require 'net/http'

module Helper
  def post uri, body, header = nil
    $logger.debug "post to #{uri.host}:#{uri.port}/#{uri.path}"
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    req.body = body
    http.request(req)
  end

  def get uri
    Net::HTTP.get uri
  end

  def remove_data  path
    FileUtils.rm_rf File.join($TMP_FILE_PATH, path)
  end

  def save_data data, path
    FileUtils.rm_rf File.join($TMP_FILE_PATH, path)
    File.write(File.join($TMP_FILE_PATH, path), data)
  end

  def retrive_data path
    begin
      File.read(File.join($TMP_FILE_PATH, path))
    rescue
      "{}"
    end
  end

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
    file = File.open(icon_path, "rb")
    file.rewind
    base64string = Base64.encode64(file.read).gsub("\n", "")
    file.close
    "data:image/png;base64,#{base64string}"
  end

  def local_models
    Dir.glob($SKP_PATH + File::Separator + "*.skp").map do |f|
      icon_path = File.join($SKP_PATH, File.basename(f).split(".")[0] + ".png")
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
