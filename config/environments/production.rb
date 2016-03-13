Application.configure do |config|
  config.log_level = Logger::Severity::WARN
  config.secret_key_base = ENV['SECRET_KEY_BASE']
  config.jwt_expiration = 24.hours
  config.public_ip = ENV['PUBLIC_IP']
  config.broadcast_port = 55555
  config.server_port = 2000
  config.device_port = 2000
end
