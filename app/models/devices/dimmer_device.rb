class DimmerDevice < Device

	include XbeeDevice

  def self.attr_accessible
    Device.attr_accessible
  end

  handle_connection_state_with XBeeConnectionState

	def self.small_icon() '16/joystick.png' end

	def self.large_icon() '32/joystick.png' end

	def value
		@value ||= 0
	end

	def value= value
		@value = value
		send_message COYOHO_PWM_WRITE, 0, COYOHO_WRITE_ABSOLUTE, @value
	end

	def update
		send_message COYOHO_PWM_READ, 0
	end

	def message_received message
		if message[0] == CoYoHoMessages::COYOHO_PWM_READ
			@value = message[2]
			notify_change_listeners
		end
	end

	def current_state
		@value
	end

	def put_state params
		self.value = params[:value].to_i
	end

end
