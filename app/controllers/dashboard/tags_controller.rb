class Dashboard::TagsController < Dashboard::BaseController
  before_filter :find_tag, only: [:edit, :update, :destroy]

  def index
    @tags = Tag.order('id desc').page params[:page]
    @tag = Tag.new
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = policy_scope(Tag).new tag_param

      authorize @tag
      if @tag.save
        redirect_to dashboard_tags_path, notice: "标签上传成功"
      else
        flash[:notice] = @tag.errors.full_messages.first
        render :new
    end
  end

  def edit
  end

  def update
    authorize @tag
    if @tag.update_attributes category_param
      redirect_to dashboard_tags_path, notice: "标签修改成功"
    else
      render :edit
    end
  end

  def destroy
    authorize @tag

    if @tag.destroy
      redirect_to dashboard_tags_path, notice: "模型删除成功"
    else
      redirect_to dashboard_tags_path, notice: "模型删除失败"
    end
  end

  private
  def tag_param
    params.require(:tag).permit!
  end

  def find_tag
    @tag  = policy_scope(Tag).find params[:id]
  end
end
