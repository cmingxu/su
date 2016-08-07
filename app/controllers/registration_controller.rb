class RegistrationController < ApplicationController
  layout "session"
  
  def new
    @user = User.new
  end

  def create
  end
end
