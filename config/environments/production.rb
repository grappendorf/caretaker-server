Application.configure do |config|
  config.log_level = Logger::Severity::WARN
  config.secret_key_base = ENV['SECRET_KEY_BASE']
  config.jwt_expiration = 24.hours
  config.network_broadcast_port = 55555
  config.public_ip = ENV['PUBLIC_IP']
  config.websocket_standalone = false
end
