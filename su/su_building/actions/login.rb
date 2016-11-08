class Login < Action::Base
  def invoke
    ctx.current_user = User.from_param params
    ctx.current_user.login!
    ctx.update_js_value(dialog, "current_user", ctx.current_user.to_json)
  end
end
