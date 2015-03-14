# == Schema Information
#
# Table name: ip_camera_devices
#
#  id               :integer          not null, primary key
#  host             :string(255)
#  port             :integer
#  user             :string(255)
#  password         :string(255)
#  refresh_interval :string(255)
#

class IpCameraDevice < ActiveRecord::Base

  include DummyConnectionState
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

  def up
    async do
      send_command '0'
      sleep 1
      send_command '1'
    end
  end

  def down
    async do
      send_command '2'
      sleep 1
      send_command '3'
    end
  end

  def left
    async do
      send_command '4'
      sleep 1
      send_command '5'
    end
  end

  def right
    async do
      send_command '6'
      sleep 1
      send_command '7'
    end
  end

  def center
    send_command '25'
  end

  def send_command command
    uri ||= URI "http://#{host}:#{port}/decoder_control.cgi?command=#{command}"
    req = Net::HTTP::Get.new uri.request_uri
    req.basic_auth user, password
    Net::HTTP.start(uri.host, uri.port) { |http| http.request req }
  end

  def send_message *_
  end

  def message_received _message
    super
  end

  def current_state
  end

end
