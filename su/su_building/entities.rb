Sketchup::require File.join(File.dirname(__FILE__), 'helper')

class Entity
  extend Helper

  INDEX_PATH = "/api/entities"
  MINE_PATH = "/api/entities/mine"
  REMOVE_PATH = "/api/entities/remove"

  class << self
    def index page = 0, query = nil
      params = {"page" => page, "query" => query}
      resp = get URI.parse("http://" + $SU_HOST + INDEX_PATH + "?" + params.to_query)
      $logger.debug resp

      begin
        json_body = JSON.parse(resp)
      rescue
        json_body = {"status" => "fail"}
      end

      $logger.debug json_body
      if json_body["status"] == "ok"
        json_body
      else
        {"status" => "fail"}
      end
    end

    def mine user, page =0, query = nil
      params = {"page" => page, "query" => query}
      resp = get URI.parse("http://" + $SU_HOST + MINE_PATH + "?" + params.to_query), {"Auth-Token" => user.auth_token}
      $logger.debug resp

      begin
        json_body = JSON.parse(resp)
      rescue
        json_body = {"status" => "fail"}
      end

      $logger.debug json_body
      if json_body["status"] == "ok"
        json_body
      else
        {"status" => "fail"}
      end
    end

    def remove_entity user, uuid
      resp = post URI.parse("http://" + $SU_HOST + REMOVE_PATH + "?uuid=" + uuid), {:uuid => uuid}.to_json, {"Auth-Token" => user.auth_token}
      $logger.debug("http://" + $SU_HOST + REMOVE_PATH + "?uuid=" + uuid)
      $logger.debug resp.body
      json_body = JSON.parse(resp.body)

      if resp.code == '200'
        if  json_body["status"] == "ok"
          json_body
        else
          {"status" => "fail", "message" => "fail"}
        end
      else
        {"status" => "fail", "message" => "fail"}
      end
    end
  end

end
