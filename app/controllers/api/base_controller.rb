class Api::BaseController < ApplicationController
  protect_from_forgery with: :null_session
  helper_method :current_user

  def authenticate!
    response_fail "要先登录哦" if current_user.blank?
  end

  def current_user
    @user ||= User.find_by_id session[:user_id]
  end

  def index
  end

  def response_success(message = "")
    render json: {status: "ok", message: message }
  end

  def response_fail(message = "")
    render json: {status: "fail", message: message}
  end
end

