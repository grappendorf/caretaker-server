ENV['RACK_ENV'] = 'test'

require 'simplecov' if ENV['COVERAGE']

require File.expand_path('../../../config/application', __FILE__)

require 'json_spec/cucumber'
require 'cucumber/api_steps'
require 'cucumber/rspec/doubles'

module RackTestHelper
  def app
    Application.root
  end

  def last_json
    last_response.body
  end
end

World RackTestHelper

Before do
  DatabaseCleaner.start
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
end

After do
  DatabaseCleaner.clean
  Fabrication::Sequencer.reset
end

JsonSpec.configure do
  exclude_keys 'created_at', 'updated_at'
end
