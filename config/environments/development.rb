Application.configure do |config|
  config.log_level = Logger::Severity::DEBUG
  config.secret_key_base = 'c23122b7c7f2ec43ee6a13105fc1ab87ca3e1167863ae5300f12db96067928787a81d583adaa40862182359540a935d84193f62088f29942d62c9479b61b7827'
  config.jwt_expiration = 1.week
  config.network_broadcast_port = 44444
  config.public_ip = '192.168.1.1'
  config.websocket_standalone = false
end
