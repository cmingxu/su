class RegistrationController < ApplicationController
  layout "session"

  def new
    @user = User.new
  end

  def create
    @user = User.new user_param
    if @user.save
      session[:user_id] = @user.id
      redirect_to dashboard_path
    else
      redirect_to new_registration_path, notice: @user.errors.full_messages.first
    end
  end

  protected
  def user_param
    params.require(:user).permit!
  end
end
