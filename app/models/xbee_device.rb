require 'xbee_connection_state'

module XbeeDevice

	include CoYoHoMessages

	inject :xbee_master

	def address16= address16
		@address16 = address16
	end

	def address_to_a
		address.scan(/../).map(&:hex)
	end

	def send_message *data
		xbee_master.send_message XBeeRuby::Address64.new(*address_to_a), @address16, *data
	end

	def reset
		super
		send_message COYOHO_RESET
	end

end
