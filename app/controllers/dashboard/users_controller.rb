class Dashboard::UsersController < Dashboard::BaseController
  before_action :find_user, only: [:edit, :update, :destroy, :toggle_visible]

  respond_to :html

  def index
    if params[:admin]
      @users = User.admin.page params[:page]
    else
      @users = User.normal_user.page params[:page]
    end
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new user_params
    authorize @user
    if @user.save && @user.make_admin!
      flash[:notice] = "用户创建成功"
    else
      flash[:alert] = "用户创建失败，#{@user.errors.full_messages.first}"
    end

    redirect_to dashboard_users_path(admin: true)
  end

  def toggle_visible
    authorize @user, :update?
    @user.update_column :visible, !@user.visible
    render :js => "window.location.reload();"
  end


  def update
    authorize @user
    if @user.update_attributes user_params
      flash[:notice] = "用户修改成功"
    else
      flash[:alert] = "用户修改失败，#{@user.errors.full_messages.first}"
    end
    respond_with @user
  end

  private
  def find_user
    @user = User.find params[:id]
  end

  def user_params
    params.require(:user).permit!
  end
end
