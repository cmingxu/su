namespace :plugin do
  task :package do
    plugin_path = Rails.root.join('su')
    tmp_path    = Rails.root.join('tmp')

    sh "rm -rf #{tmp_path}"
    sh "mkdir #{tmp_path}"

    sh "rm -f #{plugin_path}/su.rbz"
    sh "rm -f #{tmp_path}/su/su.rbz"
    `find #{plugin_path.to_s} -name "*.rb"`.split().each do |f|
      `./bin/Scrambler #{f}`
    end

    sh "mkdir -p #{tmp_path}/su/su_building/actions"
    `find #{plugin_path.to_s} -name "*.rbs"`.split().each do |f|
       sh "mv #{f} #{tmp_path}/su/#{Pathname.new(f).relative_path_from(plugin_path)}"
    end

    sh "cp -r #{plugin_path.join('web')} #{tmp_path}/su/su_building"

    sh "cd #{tmp_path}/su && zip -r su.rbz * && cd -"
    sh "mv #{tmp_path}/su/su.rbz #{plugin_path}/"
    #sh "cp #{plugin_path}/su.rbz /Users/cmingxu/Documents/baidu_yun/百度云同步盘/shared"
  end

  task :direct_copy do
    su_plugin_path = "/Users/cmingxu/Library/Application\ Support/SketchUp\ 2015/SketchUp/Plugins"
    FileUtils.rm_rf su_plugin_path + "/su_building.rb"
    FileUtils.rm_rf su_plugin_path + "/su_building"
    FileUtils.rm_rf su_plugin_path + "/web"

    FileUtils.copy Rails.root.join("su", "su_building.rb"), su_plugin_path + "/"
    FileUtils.cp_r Rails.root.join("su", "su_building"), su_plugin_path + "/"
    FileUtils.cp_r Rails.root.join("su", "web"), su_plugin_path + "/su_building"
  end

  task :copy_assets do
    FileUtils.rm_rf Rails.root.join("public", "assets")
    ENV["RAILS_ENV"] = "development"
    Rake::Task["assets:precompile"].invoke

    FileUtils.rm_rf Rails.root.join("su", "web")
    FileUtils.mkdir_p Rails.root.join("su", "web", "assets", "plugin")


    Dir.glob(Rails.root.join("public", "assets", "plugin-*.js")) do |js|
      FileUtils.copy js, Rails.root.join("su", "web", "assets", "plugin.js")
    end

    Dir.glob(Rails.root.join("public", "assets", "plugin-*.css")) do |css|
      FileUtils.copy css, Rails.root.join("su", "web", "assets", "plugin.css")
    end

    Dir.glob(Rails.root.join("public", "assets", "plugin", "*.html")) do |template|
      FileUtils.copy template, Rails.root.join("su", "web", "assets", "plugin", File.basename(template).sub(/-.*\./, "."))
    end

    File.open(Rails.root.join("su", "web", "index.html"), "wb") do |file|
      file.write Net::HTTP.get(URI.parse("http://localhost:3000/plugin")).gsub("/assets/", "./assets/")
      file.flush
    end
  end
end
