require 'xbee-ruby'

class XbeeMaster

	inject :xbee

	def initialize
		@message_listeners = []
		@xbee_mutex = Mutex.new
	end

	def start
		xbee.open
		@listener_thread = Thread.new do
			loop do
				begin
					response = xbee.read_response
					case response
						when XBeeRuby::RxResponse
							@message_listeners.each do |l|
								l.call response.address64, response.address16, response.data
							end
						when XBeeRuby::ModemStatusResponse
							Rails.logger.info "Modem status: #{response.modem_status}"
					end
				rescue => x
					Rails.logger.error x
				end
			end
		end
	end

	def stop
		@listener_thread.kill if @listener_thread
		xbee.close if @xbee
	end

	def send_message address64, address16, *data
		options = {}
		options[:address16] = address16 if address16
		request = XBeeRuby::TxRequest.new address64, data, options
		@xbee_mutex.synchronize do
			xbee.write_request request if xbee.connected?
		end
	end

	def when_message_received &block
		@message_listeners << block
	end

end