class Dashboard::SettingController < Dashboard::BaseController
  def index
    @categories = Category.page params[:page] || 1
  end
end
