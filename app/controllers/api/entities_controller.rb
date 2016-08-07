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
    @entity.name = params[:entity][:name]
    file = File.new(Rails.root.join("public", params[:entity][:name]), "wb")
    file.write Base64.decode64(params[:entity][:file_content])

    @entity.skp_file = file
    @entity.save
    file.close
    FileUtils.rm_rf(file.path)

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
