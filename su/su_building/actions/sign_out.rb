class SignOut < Action::Base
  def invoke
    ctx.remove_session
  end
end
