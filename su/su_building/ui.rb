Sketchup::require File.join(File.dirname(__FILE__), 'core')
Sketchup::require File.join(File.dirname(__FILE__), 'actions', 'base')

$ACTIONS.each do |action|
  Sketchup::require File.join(File.dirname(__FILE__), 'actions', action)
end

Sketchup::require File.join(File.dirname(__FILE__), 'action_callback')
Sketchup::require File.join(File.dirname(__FILE__), 'context')
Sketchup::require File.join(File.dirname(__FILE__), 'user')

class BuildingUI
  HEIGHT = 600
  WIDTH = 800
  LEFT = 100
  TOP = 100

  attr_accessor :ctx

  def initialize
    @ctx = Context.new
    @ctx.logger = $logger
    @ctx.dialog = setup_dialog

    @ctx.add_action_callback
  end

  def setup_dialog
    dialog = UI::WebDialog.new("构建中国", true, "", WIDTH, HEIGHT, LEFT, TOP, true)
    dialog.allow_actions_from_host $SU_HOST

    dialog.set_file File.join("#{$ROOT_PATH}","web", "index.html")


    dialog.min_height = dialog.max_height = HEIGHT
    dialog.min_width = dialog.max_width = WIDTH

    dialog
  end

  def show
    ctx.logger.debug "show_modal"
    ctx.dialog.show_modal
  end
end

