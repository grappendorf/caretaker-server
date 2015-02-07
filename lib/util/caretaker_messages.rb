module CaretakerMessages

	CARETAKER_VERSION ||= 1

	# Message types bits 6..7
	CARETAKER_MESSAGE_REQUEST ||= 0 << 6
	CARETAKER_MESSAGE_RESPONSE ||= 2 << 6
	CARETAKER_MESSAGE_NOTIFY ||= 3 << 6
	CARETAKER_MESSAGE_TYPE_MASK ||= 3 << 6
	CARETAKER_MESSAGE_COMMAND_MASK ||= 0x3f

	# Commands bits 0..5
	CARETAKER_RESET ||= 0
	CARETAKER_ADD_LISTENER ||= 1
	CARETAKER_REMOVE_LISTENER ||= 2
	CARETAKER_PROGRAM_WRITE ||= 3
	CARETAKER_PROGRAM_READ ||= 4
	CARETAKER_SWITCH_WRITE ||= 5
	CARETAKER_SWITCH_READ ||= 6
	CARETAKER_SENSOR_READ ||= 7
	CARETAKER_SERVO_WRITE ||= 8
	CARETAKER_SERVO_READ ||= 9
	CARETAKER_PWM_WRITE ||= 10
	CARETAKER_PWM_READ ||= 11
	CARETAKER_RGB_WRITE ||= 12
	CARETAKER_RGB_READ ||= 13
	CARETAKER_DUMP ||= 14
	CARETAKER_REFLOW_OVEN_ACTION ||= 15
	CARETAKER_REFLOW_OVEN_STATUS ||= 16

	# Value write modes
	CARETAKER_WRITE_DEFAULT ||= 0
	CARETAKER_WRITE_ABSOLUTE ||= 1
	CARETAKER_WRITE_INCREMENT ||= 2
	CARETAKER_WRITE_INCREMENT_DEFAULT ||= 3
	CARETAKER_WRITE_DECREMENT ||= 4
	CARETAKER_WRITE_DECREMENT_DEFAULT ||= 5
	CARETAKER_WRITE_TOGGLE ||= 6

	# Sensor types
	CARETAKER_SENSOR_TEMPERATURE ||= 0
	CARETAKER_SENSOR_BRIGHTNESS ||= 1
	CARETAKER_SENSOR_SERVO ||= 2
	CARETAKER_SENSOR_POWER_CONSUMPTION ||= 3
	CARETAKER_SENSOR_ALL ||= 255

	# Servo types
	CARETAKER_SERVO_AZIMUTH ||= 0
	CARETAKER_SERVO_ALTITUDE ||= 1
	CARETAKER_SERVO_ALL ||= 255

	# Dump values
	CARETAKER_DUMP_VERSION	||= 0
	CARETAKER_DUMP_LISTENER ||= 1

	# Reflow oven actions
	CARETAKER_REFLOW_OVEN_OFF ||= 0
	CARETAKER_REFLOW_OVEN_START ||= 1
	CARETAKER_REFLOW_OVEN_COOL ||= 2

	# Reflow oven modes
	CARETAKER_REFLOW_OVEN_MODE_OFF ||= 0
	CARETAKER_REFLOW_OVEN_MODE_REFLOW ||= 1
	CARETAKER_REFLOW_OVEN_MODE_MANUAL ||= 2
	CARETAKER_REFLOW_OVEN_MODE_COOL ||= 3

	# Reflow oven states
	CARETAKER_REFLOW_OVEN_STATE_IDLE	||= 0
	CARETAKER_REFLOW_OVEN_STATE_ERROR ||= 1
	CARETAKER_REFLOW_OVEN_STATE_SET ||= 2
	CARETAKER_REFLOW_OVEN_STATE_HEAT ||= 3
	CARETAKER_REFLOW_OVEN_STATE_PRECOOL ||= 4
	CARETAKER_REFLOW_OVEN_STATE_PREHEAT ||= 5
	CARETAKER_REFLOW_OVEN_STATE_SOAK ||= 6
	CARETAKER_REFLOW_OVEN_STATE_REFLOW ||= 7
	CARETAKER_REFLOW_OVEN_STATE_REFLOW_COOL ||= 8
	CARETAKER_REFLOW_OVEN_STATE_COOL ||= 9
	CARETAKER_REFLOW_OVEN_STATE_COMPLETE ||= 10

end
