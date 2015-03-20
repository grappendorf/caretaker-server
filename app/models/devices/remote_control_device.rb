# == Schema Information
#
# Table name: remote_control_devices
#
#  id              :integer          not null, primary key
#  num_buttons     :integer
#  buttons_per_row :integer
#

class RemoteControlDevice < ActiveRecord::Base

  inherit DeviceBase
  include WlanDevice

  acts_as :device

  validates :num_buttons, presence: true, numericality: { greater_than: 0 }
  validates :buttons_per_row, presence: true, numericality: { greater_than: 0 }

  def self.attr_accessible
    Device.attr_accessible + [:num_buttons, :buttons_per_row]
  end

  def self.small_icon()
    '16/gamepad.png'
  end

  def self.large_icon()
    '32/gamepad.png'
  end

  PRESSED = 1
  RELEASED = 0

  def button_listeners
    @button_listeners ||= []
  end

  def states
    @states ||= Array.new(num_buttons, RELEASED)
  end

  alias button_states states

  def pressed? button_num
    states[button_num] == PRESSED
  end

  def message_received message, params
    super
    if message == CaretakerMessages::BUTTON_STATE
      switch_num = params[0].to_i
      value = params[1].to_i
      states[switch_num] = value
      notify_change_listeners
    end
  end

  def add_button_listener listener
    assert listener.is_a RemoteControlListener
    button_listeners.push listener
  end

  def remove_button_listener listener
    assert listener.is_a RemoteControlListener
    button_listeners.delete listener
  end

  def current_state
    states
  end

  def put_state params
    states[params[:num].to_i] = params[:value].to_i
    notify_change_listeners
  end

end
