require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Cywin
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.enforce_available_locales = false
    config.i18n.default_locale = 'zh-CN'.to_sym
    config.action_controller.action_on_unpermitted_parameters = :log

    config.action_mailer.preview_path = "#{Rails.root}/spec/mailers/previews"
    
    # generators
    config.generators.assets = false
    config.generators.helper = false
    config.active_record.observers = :project_observer, :star_observer, :fun_observer, :member_observer, :investment_observer, :person_require_observer, :person_requires_user_observer, :talk_observer

    config.generators do |g|
      g.test_framework :rspec,
        view_specs: false
    end
  end
end
