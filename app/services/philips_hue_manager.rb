require 'hue'

class PhilipsHueManager
  attr_reader :bridge

  def start
    Grape::API.logger.info 'Philips Hue Manager starting'
    @bridge = Hue.application rescue nil
  end

  def stop
    Grape::API.logger.info 'Philips Hue Manager stopping'
  end

  def register
    Hue.register_default
    @bridge = Hue.application rescue nil
  end

  def unregister
    Hue.remove_default
    @bridge = nil
  end

  def synchronize
    @bridge.lights.each do |num, light|
      device = Device.find_by_uuid light['uniqueid']
      uuid = light['uniqueid']
      name = light['name']
      address = "#{num}"
      description = "#{light['manufacturername']} #{light['type']} #{light['modelid']} #{light['swversion']}"
      if device
        device.update_attributes! name: name, address: address, description: description
      else
        PhilipsHueLightDevice.create! name: name, uuid: uuid, address: address, description: description
      end
    end
  end

  def light_reachable? num
    Hue::Bulb.new(@bridge, num).state['reachable']
  end

  def light_state num
    Hue::Bulb.new(@bridge, num).state
  end

  def light_update_brightness num, brightness
    bulb = Hue::Bulb.new @bridge, num
    if brightness > 0
      bulb.on
      bulb.brightness = brightness
    else
      bulb.off
    end
  end

  def light_update_color num, hue, saturation
    Hue::Bulb.new(@bridge, num).color = Hue::Colors::HueSaturation.new hue, saturation
  end

  def light_rename num, name
    Hue::Bulb.new(@bridge, num).name = name
  end
end
