# Workaround: (pry) output error: #<NameError: uninitialized constant Moped::BSON>
Moped::BSON = BSON

class ActiveSupport::BufferedLogger
	def formatter=(formatter)
		@log.formatter = formatter
	end
end

class PrettyLogFormatter
	SEVERITY_TO_TAG_MAP = {'DEBUG' => 'DEBUG', 'INFO' => 'INFO', 'WARN' => 'WARN', 'ERROR' => 'ERROR', 'FATAL' => 'FATAL', 'UNKNOWN' => 'UNKNOWN'}
	SEVERITY_TO_COLOR_MAP = {'DEBUG' => '0;37', 'INFO' => '32', 'WARN' => '33', 'ERROR' => '31', 'FATAL' => '31', 'UNKNOWN' => '37'}
	USE_HUMOROUS_SEVERITIES = true

	def call(severity, time, progname, msg)
		if USE_HUMOROUS_SEVERITIES
			formatted_severity = sprintf("%-3s", "#{SEVERITY_TO_TAG_MAP[severity]}")
		else
			formatted_severity = sprintf("%-5s", "#{severity}")
		end

		formatted_time = time.strftime("%Y-%m-%d %H:%M:%S.") << time.usec.to_s[0..2].rjust(3)
		color = SEVERITY_TO_COLOR_MAP[severity]

		"\033[34m#{formatted_time}\033[0m [\033[#{color}m#{formatted_severity}\033[0m] #{msg.strip}\n"
	end
end

CoyohoServer::Application.configure do
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

	config.logger = Logger.new("#{Rails.configuration.root}/log/development.log")
	config.logger.level = Logger::DEBUG
	config.logger.formatter = PrettyLogFormatter.new

	config.middleware.delete Rack::Lock

	# Sprocket better errors
	config.assets.raise_production_errors = false
end
