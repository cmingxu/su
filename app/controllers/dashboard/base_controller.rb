class Dashboard::BaseController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!

  def index
    @folders = current_user.folders
    @latest_users = User.order('id DESC').page 1
  end
end
