class Dashboard::BaseController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!

  def index
    redirect_to dashboard_entities_path
  end
end
