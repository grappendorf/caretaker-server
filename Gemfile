source 'https://rubygems.org'

# Core
gem 'rails', '4.0.2'
gem 'rails-i18n', '4.0.1'
gem 'thin', '1.6.1'
gem 'micon', '0.1.28'
gem 'rufus-scheduler', '2.0.24'
gem 'thread_storm', '0.7.1'
gem 'statemachine', '2.2.0'
gem 'renum', '1.4.0'
gem 'rails_config', '0.3.3'
gem 'active_model_serializers', '0.8.1'

# websocket-rails must be loaded before mongoid (em-hiredis?) or else a double resume
# (can't yield from root fiber) is raised in redis/connection/synchrony.rb
gem 'websocket', '1.0.4'
gem 'websocket-rails', '0.6.2'

# Database
gem 'mongoid', '4.0.0.alpha2'
gem 'faker', '1.2.0'

# Authentication/Authorization
# cancan must be loaded after mongoid or else there is no accessible_by function
# defined in the models
gem 'devise', '3.2.2'
gem 'devise-i18n', '0.10.2'
gem 'rolify', '3.4.0'
gem 'cancan', '1.6.10'

# UI
gem 'i18n-js', '2.1.2'
gem 'underscore-rails', '1.5.2'
gem 'jquery-rails', '3.1.0'
gem 'jquery-ui-rails', '4.2.0'
gem 'angularjs-rails', '1.2.13'
gem 'angular_rails_csrf', '1.0.1'
gem 'angularjs-rails-resource', '1.0.2'
gem 'angular-ui-bootstrap-rails', '0.10.0'
gem 'x-editable-rails', '1.5.2'
gem 'formtastic', '2.3.0.rc2'
gem 'formtastic-bootstrap', '3.0.0'
gem 'breadcrumbs_on_rails', '2.3.0'
gem 'font-awesome-rails', '4.0.3.1'
gem 'codemirror-rails', '3.21'
gem 'bootstrap-switch-rails-telcat', github: 'grappendorf/bootstrap-switch-rails-telcat'
gem 'validates_email_format_of', '1.5.3'
gem 'kaminari', '0.15.1'
gem 'bootstrap-kaminari-views', '0.0.3'
gem 'jquery-turbolinks', '2.0.2'
gem 'turbolinks', '2.2.1'
gem 'therubyracer', '0.12.1'
gem 'less-rails-bootstrap', '3.1.1.1'
gem 'sass-rails', '4.0.1'
gem 'coffee-rails', '4.0.1'
gem 'uglifier', '2.4.0'
gem 'layout_by_action', '0.0.2'
gem 'nprogress-rails', '0.1.2.3'
gem 'sprockets', '2.11.0'
gem 'highcharts-rails', '3.0.10'

# Serial/XBee
gem 'serialport', '1.3.0'
gem 'xbee-ruby', '0.0.3'

group :test, :development do
	gem 'timecop', '0.7.1'
	gem 'rspec-rails', '2.14.1'
end

group :test do
	gem 'cucumber-rails', '1.4.0', require: false
	gem 'spork', '0.9.2'
	gem 'database_cleaner', '1.2.0'
	gem 'factory_girl_rails', '4.4.0'
	gem 'launchy', '2.4.2'
	gem 'simplecov', '0.8.2'
	gem 'simplecov-rcov', '0.2.3'
	gem 'websocket-driver', '0.3.2'
	gem 'poltergeist', '1.5.0'
	gem 'selenium-webdriver', '2.40.0'
	gem 'chromedriver2-helper', '0.0.8'
	gem 'rubyzip', '1.0.0'
	gem 'zip-zip', '0.2'
end

group :development do
	gem 'better_errors', '1.1.0'
	gem 'binding_of_caller', '0.7.2'
	gem 'meta_request', '0.2.8'
	gem 'rack-webconsole-telcat', github: 'grappendorf/rack-webconsole-telcat'
	gem 'pry', '0.9.12.6'
	gem 'awesome_print', '1.2.0'
	gem 'license_finder', '0.9.5.1'
	gem 'newrelic_rpm', '3.7.2.195'
	gem 'capistrano', '3.1.0'
	gem 'capistrano-rails', '1.1.1'
	gem 'capistrano-rvm', '0.1.1'
	gem 'sprockets_better_errors', '0.0.4'
	gem 'coffee-rails-source-maps', '1.4.0'
	gem 'jazz_hands', '0.5.2'
end
