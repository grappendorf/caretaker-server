# == Schema Information
#
# Table name: camera_devices
#
#  id               :integer          not null, primary key
#  host             :string
#  port             :integer
#  user             :string
#  password         :string
#  refresh_interval :string
#

class CameraDevice < ActiveRecord::Base

  inherit DeviceBase

  acts_as :device

  validates :host, presence: true
  validates :port, numericality: { greater_than: 0 }
  validates :refresh_interval, numericality: { greater_than: 0 }

  def self.attr_accessible
    Device.attr_accessible + [:host, :port, :user, :password, :refresh_interval]
  end

  def self.small_icon()
    '16/camera.png'
  end

  def self.large_icon()
    '32/camera.png'
  end

  def left
    send_message CaretakerMessages::SERVO_WRITE, CaretakerMessages::SERVO_AZIMUTH, CaretakerMessages::WRITE_INCREMENT_DEFAULT
  end

  def right
    send_message CaretakerMessages::SERVO_WRITE, CaretakerMessages::SERVO_AZIMUTH, CaretakerMessages::WRITE_DECREMENT_DEFAULT
  end

  def up
    send_message CaretakerMessages::SERVO_WRITE, CaretakerMessages::SERVO_ALTITUDE, CaretakerMessages::WRITE_DECREMENT_DEFAULT
  end

  def down
    send_message CaretakerMessages::SERVO_WRITE, CaretakerMessages::SERVO_ALTITUDE, CaretakerMessages::WRITE_INCREMENT_DEFAULT
  end

  def center
    send_message CaretakerMessages::SERVO_WRITE, CaretakerMessages::SERVO_ALL, CaretakerMessages::WRITE_DEFAULT
  end

  def message_received _message
    super
  end

  def current_state
  end

end
