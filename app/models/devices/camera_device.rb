# == Schema Information
#
# Table name: camera_devices
#
#  id               :integer          not null, primary key
#  host             :string(255)
#  port             :integer
#  user             :string(255)
#  password         :string(255)
#  refresh_interval :string(255)
#

class CameraDevice < ActiveRecord::Base

	inherit DeviceBase
	include XbeeDevice

	is_a :device

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
		send_message CARETAKER_SERVO_WRITE, CARETAKER_SERVO_AZIMUTH, CARETAKER_WRITE_INCREMENT_DEFAULT
	end

	def right
		send_message CARETAKER_SERVO_WRITE, CARETAKER_SERVO_AZIMUTH, CARETAKER_WRITE_DECREMENT_DEFAULT
	end

	def up
		send_message CARETAKER_SERVO_WRITE, CARETAKER_SERVO_ALTITUDE, CARETAKER_WRITE_DECREMENT_DEFAULT
	end

	def down
		send_message CARETAKER_SERVO_WRITE, CARETAKER_SERVO_ALTITUDE, CARETAKER_WRITE_INCREMENT_DEFAULT
	end

	def center
		send_message CARETAKER_SERVO_WRITE, CARETAKER_SERVO_ALL, CARETAKER_WRITE_DEFAULT
	end

	def message_received _
	end

	def current_state
	end

end
