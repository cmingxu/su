class SessionController < ApplicationController
  layout "session"
  
  def new
    if user_signed_in?
      redirect_to dashboard_path
    end
  end

  def create
    if @user = User.find_by_email(params[:email])
      if @user.password_valid?(params[:password])
        session[:user_id] = @user.id
        redirect_to dashboard_path
      else
        flash[:alert] = "密码不正确"
        render :new
      end
    else
      flash[:alert] = "没能找到#{params[:email]}的账号"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
