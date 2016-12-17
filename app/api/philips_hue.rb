class API::PhilipsHue < Base

  resource :philips_hue do

    desc 'Retrieve hue bridge info'
    get 'bridge' do
      bridge = philips_hue.bridge
      if bridge
        {
          connected: true,
          application_id: bridge.id,
          bridge_uri: bridge.ip,
          lights: bridge.lights.map do |light| {
              num: light.id,
              uniqueid: light.id,
              name: light.name,
              type: light.type,
              state: {
                reachable: light.reachable?
              }
            }
          end
        }
      else
        {
          connected: false
        }
      end
    end

    desc 'Register a hue bridge'
    post 'register' do
      philips_hue.register
      body false
    end

    desc 'Unregister a hue bridge'
    post 'unregister' do
      philips_hue.unregister
      body false
    end

    desc 'Synchronize hue bridge data with local database'
    post 'synchronize' do
      philips_hue.synchronize
      body false
    end

    desc 'Update a light configuration'
    params do
      requires :name, type: String, desc: 'The new light name'
    end
    put 'lights/:id' do
      philips_hue.light_rename params[:id].to_i, params['name']
      body false
    end
  end

  helpers do
    inject :philips_hue
  end
end
