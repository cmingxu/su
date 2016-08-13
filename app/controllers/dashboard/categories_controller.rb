class Dashboard::CategoriesController < Dashboard::BaseController
  before_filter :find_category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.order('id desc').page params[:page]
  end

  def new
    @category = Category.new
  end

  def create
    @category = policy_scope(Category).new category_param

      authorize @category
      if @category.save
        redirect_to dashboard_categories_path, notice: "分类上传成功"
      else
        flash[:notice] = @category.errors.full_messages.first
        render :new
    end
  end

  def edit
  end

  def update
    authorize @category
    if @category.update_attributes category_param
      redirect_to dashboard_categories_path, notice: "分类修改成功"
    else
      render :edit
    end
  end

  def destroy
    authorize @category

    if @category.entities.count > 0
      redirect_to dashboard_categories_path, notice: "分类已被使用"
      return
    end

    if @category.destroy
      redirect_to dashboard_categories_path, notice: "模型删除成功"
    else
      redirect_to dashboard_categories_path, notice: "模型删除失败"
    end
  end

  private
  def category_param
    params.require(:category).permit!
  end

  def find_category
    @category  = policy_scope(Category).find params[:id]
  end
end
