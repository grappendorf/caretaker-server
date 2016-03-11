$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../app"

env = (ENV['RACK_ENV'] || 'development')

require 'bundler'
Bundler.require(:default, env.to_sym) if defined?(Bundler)
require 'active_support/configurable'
require 'active_support/string_inquirer'
require 'active_support/core_ext/hash/compact'

module Application
  include ActiveSupport::Configurable
  class << self
    attr_accessor :root
  end
end

Application.configure do |config|
  config.env = ActiveSupport::StringInquirer.new(env).to_sym
end

specific_environment = "#{File.dirname(__FILE__)}/environments/#{env}.rb"
require specific_environment if File.exists? specific_environment

Dir["#{File.dirname(__FILE__)}/initializers/*.rb"].each {|f| require f}
