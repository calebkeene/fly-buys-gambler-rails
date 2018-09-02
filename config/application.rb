require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FlyBuysGamblerRails
  class Application < Rails::Application
    config.load_defaults 5.2
    config.api_only = false

    #config.session_store :cookie_store, key: "_fly_buys_gambler_session_#{Rails.env}"
    config.middleware.use ActionDispatch::Cookies # Required for all session management
    #config.middleware.use ActionDispatch::Session::CookieStore, config.session_options

    #config.middleware.use ActionDispatch::Cookies # will need this for 'logging in' users
    #config.middleware.use ActionDispatch::Session::CookieStore, key: '_member_session', expire_after: 20.minutes
    #config.middleware.insert_after ActionDispatch::Cookies, ActionDispatch::Session::CookieStore
    #config.middleware.insert_after ActiveRecord::QueryCache, ActionDispatch::Cookies
  end
end
