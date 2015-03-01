# == Schema Information
#
# Table name: dimmer_devices
#
#  id :integer          not null, primary key
#

class DimmerDevice < ActiveRecord::Base

  inherit DeviceBase
  include XbeeDevice

  is_a :device

  def self.attr_accessible
    Device.attr_accessible
  end

  def self.small_icon()
    '16/mixer.png'
  end

  def self.large_icon()
    '32/mixer.png'
  end

  def value
    @value ||= 0
  end

  def value= value
    @value = value
    send_message CaretakerXbeeMessages::PWM_WRITE, 0, CaretakerXbeeMessages::WRITE_ABSOLUTE, @value
  end

  def update
    send_message CaretakerXbeeMessages::PWM_READ, 0
  end

  def message_received message
    super
    if message[0] == CaretakerXbeeMessages::PWM_READ
      @value = message[2]
      notify_change_listeners
    end
  end

  def current_state
    @value
  end

  def put_state params
    self.value = params[:value].to_i
  end

end
