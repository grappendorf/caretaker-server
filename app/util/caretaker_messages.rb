module CaretakerMessages

  # General messages
  INVALID           = 0
  REGISTER_REQUEST  = 1
  REGISTER_RESPONSE = 2
  PING              = 3
  SWITCH_WRITE      = 4
  SWITCH_READ       = 5
  SWITCH_STATE      = 6
  RGB_WRITE         = 7
  RGB_READ          = 8
  RGB_STATE         = 9
  PWM_WRITE         = 10
  PWM_READ          = 11
  PWM_STATE         = 12

  # Value write modes
  WRITE_DEFAULT           = 0
  WRITE_ABSOLUTE          = 1
  WRITE_INCREMENT         = 2
  WRITE_INCREMENT_DEFAULT = 3
  WRITE_DECREMENT         = 4
  WRITE_DECREMENT_DEFAULT = 5
  WRITE_TOGGLE            = 6

end
