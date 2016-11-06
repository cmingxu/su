Sketchup::require File.join(File.dirname(__FILE__), 'core')
Sketchup::require File.join(File.dirname(__FILE__), 'actions', 'base')

$ACTIONS.each do |action|
  Sketchup::require File.join(File.dirname(__FILE__), 'actions', action)
end

Sketchup::require File.join(File.dirname(__FILE__), 'action_callback')
Sketchup::require File.join(File.dirname(__FILE__), 'context')

class BuildingUI
  HEIGHT = 600
  WIDTH = 800
  LEFT = 100
  TOP = 100

  #HOST = "http://182.92.78.92"
  LOCAL_HOST = "localhost:3000"
  REMOTE_HOST = "114.55.130.152"
  #HOST = "http://baidu.com"
  #
  attr_accessor :ctx

  def initialize
    @ctx = Context.new
    @ctx.logger = $logger
    @ctx.dialog = setup_dialog

    @ctx.add_action_callback
  end

  def host
    $SU_ENV == "development"  ? LOCAL_HOST : REMOTE_HOST
  end

  def setup_dialog
    dialog = UI::WebDialog.new("构建中国", true, "", WIDTH, HEIGHT, LEFT, TOP, true)
    dialog.allow_actions_from_host self.host
    $logger.debug self.host

    $logger.debug "#{$ROOT_PATH}/web/index.html"
    dialog.set_file "#{$ROOT_PATH}/web/index.html"


    dialog.min_height = dialog.max_height = HEIGHT
    dialog.min_width = dialog.max_width = WIDTH

    dialog
  end

  def show
    ctx.logger.debug "#{$ROOT_PATH}/web/index.html"
    ctx.logger.debug "show_modal"
    ctx.dialog.show_modal
  end
end

