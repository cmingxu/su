class Login < Action::Base
  def invoke
    ctx.current_user = User.from_params params
    ctx.current_user.login!
    ctx.update_js_value(dialog, "current_user", ctx.current_user.to_json)
    if ctx.current_user.logged_in?
      ctx.update_resolve(dialog, "data_transfer_channel_login", ctx.current_user.to_json)
    else
      ctx.update_reject(dialog, "data_transfer_channel_login", ctx.current_user.to_json)
    end
  end
end
