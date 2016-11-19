class EntityIndex < Action::Base
  def invoke
    ctx.logger.debug params
    page, search, callback_domid = params.split("|")[0], params.split("|")[1], params.split("|")[2]
    res = Entity.index page, search
    if res["status"] == "ok"
      ctx.update_resolve(dialog, callback_domid, res["entities"].to_json)
    else
      ctx.update_reject(dialog, callback_domid, res["message"].to_json)
    end
  end
end
