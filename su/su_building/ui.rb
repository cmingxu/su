Sketchup::require File.join(File.dirname(__FILE__), 'action_callback')

class BuildingUI
  HEIGHT = 600
  WIDTH = 800
  LEFT = 100
  TOP = 100

  #HOST = "http://182.92.78.92"
  #HOST = "http://localhost:3000"
  HOST = "http://114.55.130.152"

  attr_accessor :my_dialog
  attr_accessor :action_callbacks

  def initialize
    @my_dialog = UI::WebDialog.new("构建中国", true, "", WIDTH, HEIGHT, LEFT, TOP, true)
    @action_callbacks = []
    @my_dialog.set_url  "#{HOST}/plugin"
    @my_dialog.allow_actions_from_host HOST

    @my_dialog.min_height = @my_dialog.max_height = HEIGHT
    @my_dialog.min_width = @my_dialog.max_width = WIDTH
    ActionCallback.register_callbacks(@my_dialog)
  end


  def show
    @my_dialog.show
  end

end
