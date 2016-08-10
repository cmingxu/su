class WelcomeController < ApplicationController
  layout "website"

  def index
    @folders = Folder.all
    @entities = Entity.all
  end
end
