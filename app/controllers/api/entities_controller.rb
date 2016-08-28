class Api::EntitiesController < Api::BaseController
  respond_to :json
  before_action :login_from_auth_token!, only: [:create]
  before_action :authenticate!, only: [:mine, :destroy]

  def index
    @entities = Entity.visible.site_level.page params[:page]
  end

  def mine
    @entities = current_user.entities
    render action: 'index'
  end

  def create
    @entity = @user.entities.new
    @entity.name = params[:entity][:model_name]

    model = File.new(Rails.root.join("public", params[:entity][:model_name]), "wb")
    model.write Base64.decode64(params[:entity][:file_content])
    @entity.skp_file = model
    model.close
    FileUtils.rm_rf(model.path)

    icon = File.new(Rails.root.join("public", params[:entity][:icon_name]), "wb")
    icon.write Base64.decode64(params[:entity][:icon_content])
    @entity.icon = icon
    icon.close
    FileUtils.rm_rf(icon.path)

    @entity.save
    head :ok
  end

  def destroy
    current_user.entities.where(uuid: params[:id]).first.destroy
    @entities = current_user.entities.reload
    render action: 'index'
  end

  def login_from_auth_token!
    @user = User.find_by_auth_token(request.headers['Auth-Token'])
  end
end
