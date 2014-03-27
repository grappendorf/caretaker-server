module SSE

	class Stream
		def initialize io
			@io = io
		end

		def write event
			@io.write "event: #{event.name}\n"
			@io.write "data: #{JSON.dump(event.data) if event.data}\n\n"
		end

		def close
			@io.close
		end
	end

	class Event
		attr_reader :name, :data

		def initialize name, data = nil
			@name = name
			@data = data
		end
	end

end
