# == Schema Information
#
# Table name: philips_hue_light_devices
#
#  id               :integer          not null, primary key
#

class PhilipsHueLightDevice < ActiveRecord::Base

  inherit DeviceBase
  include DummyConnectionState

  acts_as :device

  inject :philips_hue

  def self.attr_accessible
    Device.attr_accessible
  end

  def self.small_icon()
    '16/lightbulb_on.png'
  end

  def self.large_icon()
    '32/lightbulb_on.png'
  end

  def connected?
    philips_hue.light_reachable? address.to_i
  end

  def current_state
    state = philips_hue.light_state address.to_i
    { brightness: state['bri'], color: { hue: state['hue'], saturation: state['sat'] } }
  end

  def put_state params
    if params.has_key? 'brightness'
      set_brightness params['brightness']
    end
    if params.has_key? 'color'
      set_color params['color']['hue'], params['color']['saturation']
    end
  end

  def set_brightness brightness
    philips_hue.light_update_brightness address.to_i, brightness
    notify_change_listeners
  end

  def set_color hue, saturation
    philips_hue.light_update_color address.to_i, hue, saturation
    notify_change_listeners
  end

end
