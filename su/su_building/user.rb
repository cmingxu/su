Sketchup::require File.join(File.dirname(__FILE__), 'helper')

class User
  include Helper

  attr_accessor :mobile, :password, :auth_token, :http_message

  LOGIN_PATH = "/api/users/login"

  def login!
    resp = post URI.parse("http://" + $SU_HOST + LOGIN_PATH), self.to_rails_request_json
    $logger.debug resp.body
    json_body = JSON.parse(resp.body)

    if resp.code == '200'
      if  json_body["status"] == "ok"
        self.auth_token = json_body["auth_token"]
        self.http_message = "login success"
      else
        self.http_message = json_body["message"] || "login failed"
      end
    else
      self.http_message = "http request error"
    end
  end

  def register
  end

  def logged_in?
    !self.auth_token.nil?
  end

  def to_rails_request_json
    {user: {mobile: mobile, password: password, auth_token: auth_token}}.to_json
  end

  def to_json
    {mobile: mobile, password: password, auth_token: auth_token, http_message: http_message}.to_json
  end

  def self.from_json json
    hash = JSON.parse(json)
    user = new
    user.mobile = hash["mobile"]
    user.password = hash["password"]
    user.auth_token = hash["auth_token"]
    user
  end

  def self.from_params params
    user = new
    user.mobile = params.split("|")[0]
    user.password = params.split("|")[1]
    user
  end
end
