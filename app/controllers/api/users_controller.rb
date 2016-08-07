class Api::UsersController < Api::BaseController
  respond_to :json

  def create
    @user = User.find_by_email params[:user][:email]
    response_fail("用户已存在") and return if @user

    if params[:user][:password] != params[:user][:password_confirmation]
      response_fail("密码不相同") and return
    end

    if params[:user][:password].blank?
      response_fail("密码不能为空") and return
    end

    @user = User.new(user_param)
    if @user.save
      cookies[:auth_token] = @user.auth_token
      session[:user_id] = @user.id
      Rails.logger.debug response.headers 
      response_success
    else
      response_fail(@user.errors.full_messages.first)
    end
  end

  def login
    @user = User.find_by_email params[:user][:email]
    if @user && @user.valid_password?(params[:user][:password])
      session[:user_id] = @user.id
      cookies[:auth_token] = { :value => @user.auth_token, :expires => 1.hour.from_now } 
      response_success
    else
      response_fail "用户不存在或者密码不正确"
    end
  end

  def sign_out
    cookies.delete(:auth_token)
    response_success "See You"
  end

  def user_param
    params.require(:user).permit!
  end
end
