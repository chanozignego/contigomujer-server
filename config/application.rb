require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ContigomujerServer
  class Application < Rails::Application
    config.i18n.default_locale = 'es-AR'
    config.i18n.available_locales = ['en', 'es-AR']
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{yml}')]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{yml}')]

    config.autoload_paths += Dir[Rails.root.join('app', 'controllers', '{**}', '*.{rb}')]
    config.autoload_paths += Dir[Rails.root.join('app', 'fields', '{**}', '*.{rb}')]
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += %W(#{config.root}/workers)
    config.autoload_paths += %W(#{config.root}/classes)

    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '*',
          :headers => :any,
          :expose  => ['access-token', 'expiry', 'token-type', 'uid', 'client'],
          :methods => [:get, :post, :options, :delete, :put]
      end
    end

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    config.active_record.raise_in_transactional_callbacks = true
  end
end
