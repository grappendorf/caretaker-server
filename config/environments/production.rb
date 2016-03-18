Application.configure do |config|
  config.log_level = Logger::Severity::WARN
  config.secret_key_base = ENV['SECRET_KEY_BASE']
  config.jwt_expiration = ENV['JWT_EXPIRATION'] || 24.hours
  config.public_ip = ENV['PUBLIC_IP']
  config.broadcast_port = ENV['BROADCAST_PORT'] || 55555
  config.server_port = ENV['SERVER_PORT'] || 2000
  config.device_port = ENV['DEVICE_PORT'] || 2000
end
