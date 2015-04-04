class PhilipsHueController < ApplicationController

  inject :philips_hue

  def bridge
    bridge = philips_hue.bridge
    if bridge
      render status: :ok, json: {
              connected: true,
              application_id: bridge.application_id,
              bridge_uri: bridge.bridge_uri,
              lights: bridge.lights.map{|num,data| data.merge({num: num.to_i})}
          }
    else
      render status: :ok, json: { connected: false }
    end
  end

  def register
    philips_hue.register
    render status: :ok, json: {}
  end

  def unregister
    philips_hue.unregister
    render status: :ok, json: {}
  end

  def synchronize
    philips_hue.synchronize
    render status: :ok, json: {}
  end

  def lights_update
    light_params = JSON.parse request.body.read
    philips_hue.light_rename params[:id].to_i, light_params['name']
    render status: :ok, json: {}
  end

end
