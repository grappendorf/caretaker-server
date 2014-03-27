require 'xbee_connection_state'

module XbeeDevice

	include CoYoHoMessages

	inject :xbee_master

	def address_to_a
		address.scan(/../).map(&:hex)
	end

	def send_message *data
		xbee_master.send_message address_to_a, *data
	end

	def reset
		super
		send_message COYOHO_RESET
	end

end
