# == Schema Information
#
# Table name: switch_devices
#
#  id               :integer          not null, primary key
#  num_switches     :integer
#  switches_per_row :integer
#

class SwitchDevice < ActiveRecord::Base

  inherit DeviceBase
  include WlanDevice

  is_a :device

  validates :num_switches, presence: true, numericality: { greater_than: 0 }
  validates :switches_per_row, presence: true, numericality: { greater_than: 0 }

  def self.attr_accessible
    Device.attr_accessible + [:num_switches, :switches_per_row]
  end

  def self.small_icon()
    '16/switch_device.png'
  end

  def self.large_icon()
    '32/switch_device.png'
  end

  def update_attributes_from_registration params
    update_attributes num_switches: params[0], switches_per_row: Math.sqrt(params[0].to_i).ceil
  end

  ON = 1
  OFF = 0

  def states
    @states ||= Array.new(num_switches, OFF)
  end

  def toggle switch_num
    states[switch_num] = (states[switch_num] == ON ? OFF : ON)
    send_message CaretakerMessages::SWITCH_WRITE, switch_num, CaretakerMessages::WRITE_TOGGLE
  end

  def get_state switch_num
    states[switch_num]
  end

  def set_state switch_num, state
    send_message CaretakerMessages::SWITCH_WRITE, switch_num, CaretakerMessages::WRITE_ABSOLUTE, state
  end

  def switch switch_num, on_or_off
    if on_or_off == ON or on_or_off == OFF
      set_state switch_num, on_or_off
    else
      set_state switch_num, on_or_off ? ON : OFF
    end
  end

  def on? switch_num
    get_state(switch_num) == ON
  end

  def off? switch_num
    get_state(switch_num) == OFF
  end

  def update
    (0...num_switches).each { |i| send_message CaretakerMessages::SWITCH_READ, i }
  end

  def message_received message, params
    super
    if message == CaretakerMessages::SWITCH_STATE
      switch_num = params[0].to_i
      value = params[1].to_i
      states[switch_num] = value
      notify_change_listeners
    end
  end

  def current_state
    states
  end

  def put_state params
    set_state params[:num].to_i, params[:value].to_i
  end

end
