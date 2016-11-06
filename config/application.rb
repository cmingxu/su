require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Su
  class Application < Rails::Application
     config.assets.paths << Rails.root.join(
        'vendor',
        'assets',
        'bower_components',
        'bootstrap',
        'dist',
        'fonts'
    )


     config.middleware.insert_before 0, Rack::Cors do
       allow do
         origins '*'
         resource '*', :headers => :any, :methods => [:get, :post, :options]
       end
     end

     config.angular_templates.module_name    = 'templates'
     config.angular_templates.ignore_prefix  = %w(templates/)
     config.angular_templates.inside_paths   = ['app/assets']
     config.angular_templates.extension      = 'html'
     config.assets.precompile += %w(.svg .eot .woff .ttf .woff2)
     # Settings in config/environments/* take precedence over those specified here.
     # Application configuration should go into files in config/initializers
     # -- all .rb files in that directory are automatically loaded.
  end
end
