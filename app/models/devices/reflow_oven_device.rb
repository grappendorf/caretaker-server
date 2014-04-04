class ReflowOvenDevice < Device

	include XbeeDevice

	def self.attr_accessible
		Device.attr_accessible
	end

	handle_connection_state_with XBeeConnectionState

	def self.small_icon()
		'16/oven.png'
	end

	def self.large_icon()
		'32/oven.png'
	end

	def update
		# send_message COYOHO_SENSOR_READ, 0
		send_message COYOHO_REFLOW_OVEN_STATUS
	end

	def message_received message
		case message[0]
			when CoYoHoMessages::COYOHO_SENSOR_TEMPERATURE
				@temperature = {timestamp: Time.now, value: (message[2] << 8) + message[3]}
				notify_change_listeners
			when CoYoHoMessages::COYOHO_REFLOW_OVEN_STATUS
				@mode = message[1]
				@state = message[2]
				@heater = message[3] != 0
				@fan = message[4] != 0
				notify_change_listeners
		end
	end

	def current_state
		{temperature: @temperature, mode: @mode, state: @state, heater: @heater, fan: @fan}
	end

	def put_state params
		case params['action']
			when 'start'
				send_message COYOHO_REFLOW_OVEN_ACTION, COYOHO_REFLOW_OVEN_START
			when 'off'
				send_message COYOHO_REFLOW_OVEN_ACTION, COYOHO_REFLOW_OVEN_OFF
			when 'cool'
				send_message COYOHO_REFLOW_OVEN_ACTION, COYOHO_REFLOW_OVEN_COOL
		end
	end

end
