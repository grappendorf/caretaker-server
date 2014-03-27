if defined? Rack::Webconsole
	Rack::Webconsole.exclude = [%r{^/live/}]
end
