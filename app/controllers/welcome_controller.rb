class WelcomeController < ApplicationController
  def index
    @folders = Folder.all
    @entities = Entity.all
  end
end
