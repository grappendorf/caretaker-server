# == Schema Information
#
# Table name: dimmer_rgb_devices
#
#  id :integer          not null, primary key
#

class DimmerRgbDevice < ActiveRecord::Base

  inherit DeviceBase
  include WlanDevice

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

  def update_attributes_from_registration params
  end

  def rgb
    @rgb ||= [0, 0, 0]
  end

  def red
    rgb[0]
  end

  def green
    rgb[1]
  end

  def blue
    rgb[2]
  end

  def red= red
    self.rgb = [red, rgb[1], rgb[2]]
  end

  def green= green
    self.rgb = [rgb[0], green, rgb[2]]
  end

  def blue= blue
    self.rgb = [rgb[0], rgb[1], blue]
  end

  def set_rgb red, green, blue
    send_message CaretakerMessages::RGB_WRITE, CaretakerMessages::WRITE_ABSOLUTE, red, green, blue
  end

  def update
    send_message CaretakerMessages::RGB_READ
  end

  def message_received message, params
    super
    if message == CaretakerMessages::RGB_STATE
      @rgb = [params[0], params[1], params[2]]
      notify_change_listeners
    end
  end

  def current_state
    rgb
  end

  def put_state params
    set_rgb (params[:red] || red).to_i, (params[:green] || green).to_i, (params[:blue] || blue).to_i
  end

end
