require 'hue'

class PhilipsHueManager
  attr_reader :bridge

  def start
    Grape::API.logger.info 'Philips Hue Manager starting'
    @bridge = hue_client.bridge rescue nil
  end

  def stop
    Grape::API.logger.info 'Philips Hue Manager stopping'
  end

  def register
    @bridge = hue_client.bridge rescue nil
  end

  def unregister
  end

  def synchronize
    hue_client.lights.each do |num, light|
      device = Device.find_by_uuid light['uniqueid']
      uuid = light.id
      name = light.name
      address = light.id
      description = "#{light.type} #{light.model} #{light.software_version}"
      if device
        device.update_attributes! name: name, address: address, description: description
      else
        PhilipsHueLightDevice.create! name: name, uuid: uuid, address: address, description: description
      end
    end
  end

  def light_reachable? id
    light = hue_client.light id
    light.refresh
    light.reachable?
  end

  def light_state id
    light = hue_client.light id
    light.refresh
    OpenStruct.new hue: light.hue, saturation: light.saturation, brightness: light.brightness
  end

  def light_update_brightness id, brightness
    light = hue_client.light id
    if brightness > 0
      light.set_state({ 'on' => true, 'brightness' => brightness })
    else
      light.set_state({ 'on' => false })
    end
  end

  def light_update_color num, hue, saturation
    hue_client.light(id).set_state({'hue' => hue, 'saturation' => saturation})
  end

  def light_rename num, name
    hue_client.light(id).name = name
  end

  private

  def hue_client
    @hue_client ||= Hue::Client.new
  end
end
