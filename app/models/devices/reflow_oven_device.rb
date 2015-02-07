# == Schema Information
#
# Table name: reflow_oven_devices
#
#  id :integer          not null, primary key
#

class ReflowOvenDevice < ActiveRecord::Base

	inherit DeviceBase
	include XbeeDevice

	is_a :device

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
		# send_message CARETAKER_SENSOR_READ, 0
		send_message CARETAKER_REFLOW_OVEN_STATUS
	end

	def message_received message
		case message[0]
			when CaretakerMessages::CARETAKER_SENSOR_TEMPERATURE
				@temperature = {timestamp: Time.now, value: (message[2] << 8) + message[3]}
				notify_change_listeners
			when CaretakerMessages::CARETAKER_REFLOW_OVEN_STATUS
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
				send_message CARETAKER_REFLOW_OVEN_ACTION, CARETAKER_REFLOW_OVEN_START
			when 'off'
				send_message CARETAKER_REFLOW_OVEN_ACTION, CARETAKER_REFLOW_OVEN_OFF
			when 'cool'
				send_message CARETAKER_REFLOW_OVEN_ACTION, CARETAKER_REFLOW_OVEN_COOL
		end
	end

end
