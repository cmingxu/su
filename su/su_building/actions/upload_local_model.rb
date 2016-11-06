class UploadLocalModel < Action::Base
  def invoke
    model_name = params.split("||")[0]
    auth_token = params.split("||")[1]
    icon_name = model_name.gsub(File.extname(model_name),".png")

    uri = URI(BuildingUI::HOST + "/api/entities")
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json', 'Auth-Token' => auth_token})
    req.body = {entity: { model_name: model_name,
                          icon_name: icon_name,
                          file_content: Base64.encode64(File.read(File.join($SKP_PATH, model_name))),
                          icon_content: Base64.encode64(File.read(File.join($SKP_PATH, icon_name)))
    }}.to_json
    http.request(req)
  end
end
