class Dashboard::VendorsController < Dashboard::BaseController
  before_filter :find_vendor, only: [:edit, :update, :destroy]

  def index
    @vendors = policy_scope(Vendor).page params[:page]
  end

  def new
    @vendor = policy_scope(Vendor).new
  end

  def edit
  end

  def create
    @vendor = policy_scope(Vendor).new vendor_param
    authorize @vendor
    if @vendor.save
      flash[:noice] = "新增材料商成功"
      redirect_to dashboard_vendors_path
    else
      flash[:alert] = "新增材料商失败, #{@vendor.errors.full_messages.first}"
      render :new
    end
  end

  def update
    authorize @vendor
    if @vendor.update_attributes vendor_param
      flash[:noice] = "修改材料商成功"
      redirect_to dashboard_vendors_path
    else
      flash[:alert] = "修改材料商失败, #{@vendor.errors.full_messages.join}"
      render :edit
    end
  end

  def destroy
    authorize @vendor
    redirect_to dashboard_vendors_path, alert: "此材料商下维护多款材料， 不能删除" and return if !@vendor.destructive?
    if @vendor.destroy
      redirect_to dashboard_vendors_path, notice: "材料商删除成功"
    else
      redirect_to dashboard_vendors_path, alert: "材料商删除失败"
    end
  end

  private
  def find_vendor
    @vendor = policy_scope(Vendor).find params[:id]
  end

  def vendor_param
    params.require(:vendor).permit!
  end
end
