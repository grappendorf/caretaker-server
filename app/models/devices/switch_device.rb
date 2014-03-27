class SwitchDevice < Device

	include XbeeDevice

	field :num_switches, type: Integer
	field :switches_per_row, type: Integer

	validates :num_switches, presence: true, numericality: {greater_than: 0}
	validates :switches_per_row, presence: true, numericality: {greater_than: 0}

	def self.attr_accessible
		Device.attr_accessible + [:num_switches, :switches_per_row]
	end

	handle_connection_state_with XBeeConnectionState

	def self.small_icon()
		'16/joystick.png'
	end

	def self.large_icon()
		'32/joystick.png'
	end

	ON = 1
	OFF = 0

	def states
		@states ||= Array.new(num_switches, OFF)
	end

	def toggle switch_num
		states[switch_num] = (states[switch_num] == ON ? OFF : ON)
		send_message COYOHO_SWITCH_WRITE, switch_num, COYOHO_WRITE_TOGGLE
	end

	def get_state switch_num
		states[switch_num]
	end

	def set_state switch_num, state
		states[switch_num] = state
		send_message COYOHO_SWITCH_WRITE, switch_num, COYOHO_WRITE_ABSOLUTE, state
	end

	def switch switch_num, on_or_off
		if on_or_off == ON or on_or_off == OFF
			set_state switch_num, on_or_off
		else
			set_state switch_num, on_or_off ? ON : OFF
		end
	end

	def on? switch_num
		get_state(switch_num) == ON
	end

	def off? switch_num
		get_state(switch_num) == OFF
	end

	def update
		(0...num_switches).each { |i| send_message COYOHO_SWITCH_READ, i }
	end

	def message_received message
		if message[0] == CoYoHoMessages::COYOHO_SWITCH_READ
			switch_num = message[1]
			value = message[2]
			states[switch_num] = value
			notify_change_listeners
		end
	end

	def current_state
		states
	end

	def put_state params
		set_state params[:num].to_i, params[:value].to_i
	end

end
