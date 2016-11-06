require 'sketchup'
require 'fileutils'
require 'logger'



$PLATFORM = (RUBY_PLATFORM =~ /darwin/ ? "MACOS" : "WINDOWS")

$ROOT_PATH = File.expand_path(File.join(File.dirname(__FILE__), "su_building"))
$LOAD_PATH.push($ROOT_PATH)

$ACTIONS = %w(
current_component_definition_name_change
download_from_remote
download_from_system
initialization
list_attribute_dictionaries
logger
lost_local_skps
remove_local_component_definition
replace_by_name
save_current_component_definition
update_attribute
upload_local_model
)

# load required rb files

## Logger

#$TMP_FILE_PATH = File.join(Dir.pwd,  "su_building", "tmp")
$TMP_FILE_PATH = File.join($ROOT_PATH, "tmp")
FileUtils.mkdir_p($TMP_FILE_PATH) if !File.exists?($TMP_FILE_PATH)
FileUtils.chmod(0777, $TMP_FILE_PATH)

$SKP_PATH = File.expand_path(File.join($ROOT_PATH, "skps"))
FileUtils.mkdir_p($SKP_PATH) if !File.exists?($SKP_PATH)
FileUtils.chmod(0777, $SKP_PATH)

# setup logger for logging purpose
$logger = Logger.new File.join($TMP_FILE_PATH,  "logger.log")
$logger.debug "Initializing APP"

require 'sketchup.rb'
require 'extensions.rb'
extension_name = "构建中国"
ui_file = File.exists?(File.join($ROOT_PATH, "ui.rb")) ? "su_building/ui.rb" : "su_building/ui.rbs"
$SU_ENV = ui_file.end_with?("rb") ? "development" : "production"

fs_extension = SketchupExtension.new(
  extension_name, ui_file)
fs_extension.version = "0.0.1"
fs_extension.creator = "Goujian China"
fs_extension.copyright = "2014, 构建中国"
# Register the extension with Sketchup.
Sketchup.register_extension fs_extension, true


UI.menu("Plugins").add_item("GJZG") do
  BuildingUI.new.show
end

