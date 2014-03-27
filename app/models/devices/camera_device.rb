class CameraDevice < Device

	include XbeeDevice

	field :host, type: String
	field :port, type: Integer
	field :user, type: String
	field :password, type: String
	field :refresh_interval, type: String

	validates :host, presence: true
	validates :port, numericality: { greater_than: 0 }
	validates :refresh_interval, numericality: { greater_than: 0 }

	def self.attr_accessible
		Device.attr_accessible + [:host, :port, :user, :password, :refresh_interval]
	end

	handle_connection_state_with XBeeConnectionState

	def self.small_icon() '16/camera.png' end

	def self.large_icon() '32/camera.png' end

	def left
		send_message COYOHO_SERVO_WRITE, COYOHO_SERVO_AZIMUTH, COYOHO_WRITE_INCREMENT_DEFAULT
	end

	def right
		send_message COYOHO_SERVO_WRITE, COYOHO_SERVO_AZIMUTH, COYOHO_WRITE_DECREMENT_DEFAULT
	end

	def up
		send_message COYOHO_SERVO_WRITE, COYOHO_SERVO_ALTITUDE, COYOHO_WRITE_DECREMENT_DEFAULT
	end

	def down
		send_message COYOHO_SERVO_WRITE, COYOHO_SERVO_ALTITUDE, COYOHO_WRITE_INCREMENT_DEFAULT
	end

	def center
		send_message COYOHO_SERVO_WRITE, COYOHO_SERVO_ALL, COYOHO_WRITE_DEFAULT
	end

	def message_received _
	end

	def current_state
	end

end
