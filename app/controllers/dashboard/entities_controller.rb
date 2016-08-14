class Dashboard::EntitiesController < Dashboard::BaseController
  before_filter :find_entity, only: [:edit, :update, :destroy, :toggle_visible]

  def index
    if params[:category_id] 
      @entities = Entity.where(category_id: params[:category_id]).order('id desc').page params[:page]
    else
      @entities = Entity.order('id desc').page params[:page]
    end
    @entity  = current_user.entities.new
  end

  def new
    @entity = current_user.entities.new
  end

  def create
    @entity = policy_scope(Entity).new entity_param
    @entity.is_system = true
    @entity.visible = true

    authorize @entity
    if @entity.save
      redirect_to params[:commit] == "增加后继续" ? new_dashboard_entity_path : dashboard_entities_path, notice: "模型上传成功" 
    else
      flash[:notice] = @entity.errors.full_messages.first
      render :new
    end
  end

  def edit
  end

  def update
    authorize @entity
    if @entity.update_attributes entity_param
      redirect_to dashboard_entities_path, notice: "模型修改成功"
    else
      render :edit
    end
  end

  def toggle_visible
    authorize @entity, :update?
    @entity.update_column :visible, !@entity.visible
    render :js => "window.location.reload();"
  end

  def destroy
    authorize @entity
    if @entity.destroy
      redirect_to dashboard_entities_path, notice: "模型删除成功"
    else
      redirect_to dashboard_entities_path, notice: "模型删除失败"
    end
  end

  private
  def entity_param
    params.require(:entity).permit!
  end

  def find_entity
    @entity  = policy_scope(Entity).find params[:id]
  end
end
