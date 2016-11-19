class EntityMine < Action::Base
  def invoke
    ctx.logger.debug params

    if !ctx.current_user || !ctx.current_user.logged_in?
      ctx.update_reject(dialog, callback_domid, "没登录")
      return
    end

    page, search, callback_domid = params.split("|")[0], params.split("|")[1], params.split("|")[2]
    res = Entity.mine ctx.current_user, page, search
    if res["status"] == "ok"
      ctx.update_resolve(dialog, callback_domid, res["entities"].to_json)
    else
      ctx.update_reject(dialog, callback_domid, res["message"].to_json)
    end
  end
end
