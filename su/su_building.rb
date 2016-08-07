require 'sketchup'
require 'fileutils'
require 'logger'

# global varible set app in debuging mode or not
#SKETCHUP_CONSOLE.show
#






$PLATFORM = (RUBY_PLATFORM =~ /darwin/ ? "MACOS" : "WINDOWS")
# directory we working on
$ROOT_PATH = File.expand_path(File.join(File.dirname(__FILE__), "su_building"))

# add ruby file path into loading pathes
$LOAD_PATH.push($ROOT_PATH)

$SKP_PATH = File.expand_path(File.join($ROOT_PATH , "skps"))
$INSTALL_PATH = File.expand_path(File.join($ROOT_PATH , "..", ".."))
FileUtils.mkdir_p($SKP_PATH) if !File.exists?($SKP_PATH)
FileUtils.chmod(0777, $SKP_PATH)

# load required rb files

## Logger
$TMP_FILE_PATH = File.join($ROOT_PATH,  "tmp")
FileUtils.mkdir_p($TMP_FILE_PATH) if !File.exists?($TMP_FILE_PATH)
FileUtils.chmod(0777, $TMP_FILE_PATH)
# setup logger for logging purpose
$logger = Logger.new File.join($TMP_FILE_PATH,  "logger.log")
$logger.debug "Initializing APP"

$logger.debug $LOAD_PATH

require 'sketchup.rb'
require 'extensions.rb'
extension_name = "构建中国"
ui_file = File.exists?(File.join($ROOT_PATH, "ui.rb")) ? "su_building/ui.rb" : "su_building/ui.rbs"

fs_extension = SketchupExtension.new(
  extension_name, ui_file)
fs_extension.version = "0.0.1"
fs_extension.creator = "Goujian China"
fs_extension.copyright = "2014, 构建中国"
# Register the extension with Sketchup.
Sketchup.register_extension fs_extension, true


UI.menu("Plugins").add_item("构建中国") do
  BuildingUI.new.show
end

