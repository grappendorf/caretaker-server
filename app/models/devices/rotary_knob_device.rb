# == Schema Information
#
# Table name: rotary_knob_devices
#
#  id :integer          not null, primary key
#

require 'models/device_base'
require 'models/wlan_device'

class RotaryKnobDevice < ActiveRecord::Base
  inherit DeviceBase
  include WlanDevice
  acts_as :device

  def self.small_icon()
    '16/knob.png'
  end

  def self.large_icon()
    '32/knob.png'
  end

  def value
    @value ||= 0
  end

  def set_value value
    send_message CaretakerMessages::ROTARY_WRITE, CaretakerMessages::WRITE_ABSOLUTE, value
  end

  def current_state
    value
  end

  def message_received message, params
    super
    if message == CaretakerMessages::ROTARY_STATE
      @value = params[0].to_i
      notify_change_listeners
    end
  end

  def put_state params
    set_value params.to_i
  end

  def update
    send_message CaretakerMessages::ROTARY_READ
  end
end
