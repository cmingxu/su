class ApplicationController < ActionController::Base
  # reset captcha code after each request for security

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery
  before_action :dump_user_agent

  helper_method :current_user, :user_signed_in?

  def dump_user_agent
    Rails.logger.error request.headers["User-Agent"]
  end

  def authenticate_user!
    if login_from_session
      return true
    else
      redirect_to session[:return_to] || root_path
    end
  end

  def current_user
    @current_user || login_from_session
  end

  def login_from_session
    @current_user ||= User.find_by_id session[:user_id]
  end

  def user_signed_in?
    current_user.present?
  end
end
