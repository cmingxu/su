class Dashboard::MaterialsController < Dashboard::BaseController
  before_filter :find_material, only: [:edit, :update, :destroy]
  before_filter  do
    @vendor = Vendor.find_by(id: params[:vendor_id]) || Vendor.first
  end

  def index
    @materials = policy_scope(Material).page params[:page]
  end

  def new
    @material = @vendor.materials.new
  end

  def edit
  end

  def create
    @material = @vendor.materials.new material_param
    authorize @material
    if @material.save
      redirect_to dashboard_vendor_materials_path(@vendor), notice: "材料上传成功"
    else
      flash[:alert] = "新增材料失败, #{@material.errors.full_messages.first}"
      render :new
    end
  end

  def update
    authorize @material
    if @material.update_attributes material_param
      redirect_to dashboard_vendor_materials_path(@vendor), notice: "材料修改成功"
    else
      flash[:alert] = "新增材料失败, #{@material.errors.full_messages.first}"
      render :edit
    end
  end

  def destroy
    authorize @material
    if @material.destroy
      redirect_to dashboard_vendor_materials_path(@vendor), notice: "材料删除成功"
    else
      redirect_to dashboard_vendor_materials_path(@vendor), notice: "材料删除失败"
    end
  end

  private
  def material_param
    params.require(:material).permit!
  end

  def find_material
    @material = policy_scope(Material).find params[:id]
  end
end
