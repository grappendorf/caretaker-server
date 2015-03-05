if defined? Rack::Webconsole
  Rack::Webconsole.exclude = [%r{^/websocket/}]
end
