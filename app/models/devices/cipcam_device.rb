# == Schema Information
#
# Table name: cipcam_camera_devices
#
#  id               :integer          not null, primary key
#  user             :string
#  password         :string
#  refresh_interval :string
#

class CipcamDevice < ActiveRecord::Base

  include DummyConnectionState
  inherit DeviceBase

  acts_as :device

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

  def execute_async &block
    Thread.new do
      block.call
    end
  end

  def send_command command
    uri = URI "http://#{address}/decoder_control.cgi?command=#{command}"
    req = Net::HTTP::Get.new uri.request_uri
    if user.present? && password.present?
      req.basic_auth user, password
    end
    Net::HTTP.start(uri.host, uri.port) { |http| http.request req }
  end

  def message_received _message, _params
    super
  end

  def current_state
  end

  def put_state params
    case params['action']
      when 'left'
        execute_async do
          send_command '4'
          sleep 1
          send_command '5'
        end
      when 'right'
        execute_async do
          send_command '6'
          sleep 1
          send_command '7'
        end
      when 'up'
        execute_async do
          send_command '0'
          sleep 1
          send_command '1'
        end
      when 'down'
        execute_async do
          send_command '2'
          sleep 1
          send_command '3'
        end
      when 'center'
        execute_async do
          send_command '25'
        end
      else
        raise InvalidArgumentError
    end
  end

end
