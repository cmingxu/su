class Dashboard::StylesController < Dashboard::BaseController
  before_filter :find_style, only: [:edit, :update, :destroy]

  def index
    @styles = Style.order('id desc').page params[:page]
  end

  def new
    @style = Style.new
  end

  def create
    @style = policy_scope(Style).new style_param

      authorize @style
      if @style.save
        redirect_to dashboard_styles_path, notice: "风格上传成功"
      else
        flash[:notice] = @style.errors.full_messages.first
        render :new
    end
  end

  def edit
  end

  def update
    authorize @style
    if @style.update_attributes style_param
      redirect_to dashboard_styles_path, notice: "风格修改成功"
    else
      render :edit
    end
  end

  def destroy
    authorize @style

    if @style.entities.count > 0
      redirect_to dashboard_styles_path, notice: "风格已被使用"
      return
    end

    if @style.destroy
      redirect_to dashboard_styles_path, notice: "模型删除成功"
    else
      redirect_to dashboard_styles_path, notice: "模型删除失败"
    end
  end

  private
  def style_param
    params.require(:style).permit!
  end

  def find_style
    @style  = policy_scope(Style).find params[:id]
  end
end
