dialog = UI::WebDialog.new("构建中国", true, "", 100, 100,400,600, true)
dialog.set_file "/Users/cmingxu/Library/Application Support/SketchUp 2015/SketchUp/Plugins/su_building/index.html"

dialog.min_height = dialog.max_height = 400
dialog.min_width = dialog.max_width = 600

dialog.show
