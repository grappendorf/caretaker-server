require File.expand_path '../environment', __FILE__
require 'rack/cors'

I18n.load_path << 'config/locales/de.yml'
I18n.load_path << 'config/locales/en.yml'
I18n.available_locales = %w(en de)
require 'i18n/backend/fallbacks'
I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)

Grape::API.logger = Logger.new STDOUT
Grape::API.logger.level = Application.config.log_level || Logger::Severity::INFO

module API
end

require 'util/dependency_injection'
require 'util/caretaker_messages'
require 'models/device_base'
require 'models/device_base'
require 'models/device'
require 'models/widget_base'
require 'models/widget'

%w(models/devices models/widgets models).each do |dir|
  Dir["#{File.dirname(__FILE__)}/../app/#{dir}/*.rb"].each { |f| require f }
end

ServiceManager.start

require 'api/base'
%w(api).each do |dir|
  Dir["#{File.dirname(__FILE__)}/../app/#{dir}/*.rb"].each { |f| require f }
end

class API::Root < Grape::API
  mount API::Websocket
  mount API::Status
  mount API::Sessions
  mount API::Users
  mount API::Buildings
  mount API::Floors
  mount API::Rooms
  mount API::DeviceActions
  mount API::DeviceScripts
  mount API::PhilipsHue
  mount API::Dashboards
  mount API::Widgets
  mount API::Devices
  mount API::CipcamDevices
end

Application.root = Rack::Builder.new do
  use HttpAcceptLanguage::Middleware
  use Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: [:get, :post, :put, :delete, :options]
    end
  end

  map '/' do
    run API::Root
  end
end

Faye::WebSocket.load_adapter('thin')

module Rack
  class Lint
    def call(env = nil)
      @app.call(env)
    end
  end
end
