# == Schema Information
#
# Table name: dimmer_rgb_devices
#
#  id :integer          not null, primary key
#

class DimmerRgbDevice < ActiveRecord::Base

  inherit DeviceBase
  include XbeeDevice

  is_a :device

  def self.attr_accessible
    Device.attr_accessible
  end

  def self.small_icon()
    '16/dimmer_rgb_device.png'
  end

  def self.large_icon()
    '32/dimmer_rgb_device.png'
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

  def rgb= rgb
    if @rgb != rgb
      send_message CaretakerXbeeMessages::RGB_WRITE, 0, CaretakerXbeeMessages::WRITE_ABSOLUTE, rgb[0], rgb[1], rgb[2]
    end
    @rgb = rgb
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

  def update
    send_message CaretakerXbeeMessages::RGB_READ, 0
  end

  def message_received message
    super
    if message[0] == CaretakerXbeeMessages::RGB_READ
      @rgb = [message[2], message[3], message[4]]
      notify_change_listeners
    end
  end

  def current_state
    rgb
  end

  def put_state params
    self.red = (params[:red] || red).to_i
    self.green = (params[:green] || green).to_i
    self.blue = (params[:blue] || blue).to_i
  end

end
