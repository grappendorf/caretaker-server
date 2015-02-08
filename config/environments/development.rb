CaretakerServer::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Show full error reports and disable caching
  config.consider_all_requests_local = true

  # Disable caching
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  config.assets.initialize_on_precompile = true

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = false

  # Do not eager load code on boot
  config.eager_load = false

  unless defined? Rails::Console
    SemanticLogger.add_appender(STDOUT)
  end
  config.log_level = :debug

  config.middleware.delete Rack::Lock

  # Sprocket better errors
  config.assets.raise_production_errors = false
end
