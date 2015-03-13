module CaretakerMessages

  # General messages
  INVALID             = 0
  REGISTER_REQUEST    = 1
  REGISTER_RESPONSE   = 2
  PING                = 3
  SWITCH_WRITE        = 4
  SWITCH_READ         = 5
  SWITCH_STATE        = 6
  RGB_WRITE           = 7
  RGB_READ            = 8
  RGB_STATE           = 9
  PWM_WRITE           = 10
  PWM_READ            = 11
  PWM_STATE           = 12
  SENSOR_READ         = 13
  SENSOR_STATE        = 14
  SERVO_WRITE         = 15
  SERVO_READ          = 16
  SERVO_STATE         = 17
  REFLOW_OVEN_CMD     = 18
  REFLOW_OVEN_READ    = 19
  REFLOW_OVEN_STATE   = 20

  # Value write modes
  WRITE_DEFAULT           = 0
  WRITE_ABSOLUTE          = 1
  WRITE_INCREMENT         = 2
  WRITE_INCREMENT_DEFAULT = 3
  WRITE_DECREMENT         = 4
  WRITE_DECREMENT_DEFAULT = 5
  WRITE_TOGGLE            = 6

  # Sensor types
  SENSOR_ALL                = 0
  SENSOR_TEMPERATURE        = 1
  SENSOR_BRIGHTNESS         = 2
  SENSOR_SERVO              = 3
  SENSOR_POWER_CONSUMPTION  = 4

  # Servo types
  SERVO_ALL       = 0
  SERVO_AZIMUTH   = 1
  SERVO_ALTITUDE  = 2

  # Reflow oven actions
  REFLOW_OVEN_CMD_OFF   = 0
  REFLOW_OVEN_CMD_START = 1
  REFLOW_OVEN_CMD_COOL  = 2

  # Reflow oven modes
  REFLOW_OVEN_MODE_OFF    = 0
  REFLOW_OVEN_MODE_REFLOW = 1
  REFLOW_OVEN_MODE_MANUAL = 2
  REFLOW_OVEN_MODE_COOL   = 3

  # Reflow oven states
  REFLOW_OVEN_STATE_IDLE        = 0
  REFLOW_OVEN_STATE_ERROR       = 1
  REFLOW_OVEN_STATE_SET         = 2
  REFLOW_OVEN_STATE_HEAT        = 3
  REFLOW_OVEN_STATE_PRECOOL     = 4
  REFLOW_OVEN_STATE_PREHEAT     = 5
  REFLOW_OVEN_STATE_SOAK        = 6
  REFLOW_OVEN_STATE_REFLOW      = 7
  REFLOW_OVEN_STATE_REFLOW_COOL = 8
  REFLOW_OVEN_STATE_COOL        = 9
  REFLOW_OVEN_STATE_COMPLETE    = 10

end
