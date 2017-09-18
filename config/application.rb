require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NewSeasons
  class Application < Rails::Application

    config.autoload_paths << Rails.root.join('lib')
    config.receipt_email = ENV["receipt_email"] || "receipts@newseasonsmarket.com"
    config.receipt_email_2 = ENV["receipt_email"] || "noreply@index.com"

    config.generators do |g|
      g.test_framework :rspec,
      fixtures: true,
      view_specs: false,
      helper_specs: false,
      routing_specs: false,
      controller_specs: true,
      request_specs: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    config.timezone = 'Pacific Time (US & Canada)'
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    Raven.configure do |config|
      config.dsn = 'https://46b5aa2a581d40b191d6c0d8bb4fbfd2:664685a874f84214817581d2a53e6878@sentry.io/211343'
    end
  end
end
