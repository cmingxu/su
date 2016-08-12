class WelcomeController < ApplicationController
  layout "website"

  def index
    @entities = Entity.all
  end
end
