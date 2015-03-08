# == Schema Information
#
# Table name: easyvr_devices
#
#  id              :integer          not null, primary key
#  num_buttons     :integer
#  buttons_per_row :integer
#

class EasyvrDevice < ActiveRecord::Base

  inherit DeviceBase

  is_a :device

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

  def pressed? button_num
    states[button_num] == PRESSED
  end

  def message_received message
    super
    if message[0] == CaretakerMessages::SWITCH_READ
      button_num = message[1]
      value = message[2]
      states[button_num] = value
      notify_change_listeners
      button_listeners.each do |listener|
        if value == PRESSED
          listener.button_pressed button_num
        else
          listener.button_released button_num
        end
      end
    end
  end

  def add_easyvr_listener listener
    assert listener.is_a EasyvrListener
    button_listeners.push listener
  end

  def remove_easyvr_listener listener
    assert listener.is_a EasyvrListener
    button_listeners.delete listener
  end

  def current_state
    states
  end

end
