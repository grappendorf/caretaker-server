Application.configure do |config|
  config.log_level = Logger::Severity::WARN
  config.secret_key_base = '887b06e5ff35500d939adc7f3249bc4f988d37852adc8f79366a540b88cc915d3de6c49efcb2e04322c4c6b6a3f771c6c39ed8e51b2ead0d2ef2aef0e6b60302'
  config.jwt_expiration = 1.hour
  config.network_broadcast_port = 44444
  config.public_ip = '192.168.1.1'
  config.websocket_standalone = false
end
