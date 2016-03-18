class API::Devices < Base

  helpers do
    params :devices do
      create = ! declared_param?(:id)
      optional :uuid, presence: create, type: String, desc: 'The unique device identifier'
      optional :name, presence: create, type: String, desc: 'The unique device name'
      optional :address, presence: create, type: String, desc: 'The device network address'
      optional :port, type: Integer, desc: 'The optional device port'
      optional :description, type: String, desc: 'An optional device description'
    end

    params :cipcam_devices do
      create = ! declared_param?(:id)
      optional :user, presence: create, type: String, desc: 'The authorization user name'
      optional :password, presence: create, type: String, desc: 'The authorization password'
      optional :refresh_interval, presence: create, type: Integer, desc: 'The duration in seconds between image refreshs'
    end

    params :dimmer_devices do
    end

    params :dimmer_rgb_devices do
    end

    params :easyvr_devices do
      create = ! declared_param?(:id)
      requires :num_buttons, presence: create, type: Integer, desc: 'The total number of buttons'
      requires :buttons_per_row, presence: create, type: Integer, desc: 'The number of buttons per row'
    end

    params :philips_hue_light_devices do
    end

    params :reflow_oven_devices do
    end

    params :remote_control_devices do
      create = ! declared_param?(:id)
      requires :num_buttons, presence: create, type: Integer, desc: 'The total number of buttons'
      requires :buttons_per_row, presence: create, type: Integer, desc: 'The number of buttons per row'
    end

    params :rotary_knob_devices do
    end

    params :sensor_devices do
      create = ! declared_param?(:id)
      requires :sensors, presence: create, type: String, desc: 'Sensors definition'
    end

    params :switch_devices do
      create = ! declared_param?(:id)
      optional :num_switches, presence: create, type: Integer, desc: 'The total number of switches'
      optional :switches_per_row, presence: create, type: Integer, desc: 'The number of switches per row'
    end
  end

  Device.models_paths.each do |device_path|
    resource device_path.to_sym do

      desc 'Get a new device'
      get 'new' do
        authorize! :read, Device
        device = Device.new_from_type device_path
        send "#{device.class.name.underscore}_to_json", device
      end

      desc 'Create a new device'
      params do
        use :devices
        use device_path.to_sym
      end
      post do
        authorize! :create, Device
        device = Device.new_from_type device_path
        device.update_attributes! permitted_params
        device_manager.add_device device
        {
          id: device.id
        }
      end

      desc 'Update a device'
      params do
        requires :id, type: String, desc: 'The id of the device to update'
        use :devices
        use device_path.to_sym
      end
      put ':id' do
        device = Device.find(params[:id]).specific
        authorize! :update, device
        device.update_attributes! permitted_params.compact
        body false
      end
    end
  end

  resource :devices do
    desc 'Get a list of all devices'
    params do
      optional :q, type: String, desc: 'Optional query string'
    end
    get do
      authorize! :read, Device
      Device.search(params[:q]).accessible_by(current_ability).map(&:specific).map do |device|
        managed_device = lookup(:device_manager).device_by_id(device.acting_as)
        {
          id: device.persisted? ? device.acting_as.id : nil,
          specific_id: device.persisted? ? device.id : nil,
          uuid: device.uuid,
          name: device.name,
          type: device.class.name,
          address: device.address,
          port: device.port,
          small_icon: device.class.small_icon,
          large_icon: device.class.large_icon,
          description: device.description,
          connected: managed_device.try(:connected?)
        }
      end
    end

    desc 'Get the number of all devices'
    get 'count' do
      authorize! :read, Device
      {
        count: Device.accessible_by(current_ability).count
      }
    end

    desc 'Get the names of all devices'
    get 'names' do
      Device.search(params[:q]).accessible_by(current_ability).select(:id, :name).each do |device|
        {
          id: device.id,
          name: device.name
        }
      end
    end

    desc 'Get a specific device'
    get ':id' do
      device = Device.find(params[:id]).specific
      authorize! :read, device
      send "#{device.class.name.underscore}_to_json", device
    end

    desc 'Delete a device'
    delete ':id' do
      device = Device.find params[:id]
      authorize! :destroy, device
      device_manager.remove_device device.id
      device.destroy
      body false
    end
  end

  module JSONHelpers
    def device_to_json device
      managed_device = lookup(:device_manager).device_by_id(device.acting_as.id)
      {
        id: device.persisted? ? device.acting_as.id : nil,
        specific_id: device.persisted? ? device.id : nil,
        uuid: device.uuid,
        name: device.name,
        type: device.class.name,
        address: device.address,
        port: device.port,
        small_icon: device.class.small_icon,
        large_icon: device.class.large_icon,
        description: device.description,
        state: managed_device.try(:current_state),
        connected: managed_device.try(:connected?)
      }
    end

    def cipcam_device_to_json device
      {
        user: device.user,
        password: device.password,
        refresh_interval: device.refresh_interval
      }.merge(device_to_json device)
    end

    def dimmer_device_to_json device
      device_to_json device
    end

    def dimmer_rgb_device_to_json device
      device_to_json device
    end

    def easyvr_device_to_json device
      {
        num_buttons: device.num_buttons,
        buttons_per_row: device.buttons_per_row
      }.merge(device_to_json device)
    end

    def philips_hue_light_device_to_json device
      device_to_json device
    end

    def reflow_oven_device_to_json device
      device_to_json device
    end

    def remote_control_device_to_json device
      {
        num_buttons: device.num_buttons,
        buttons_per_row: device.buttons_per_row
      }.merge(device_to_json device)
    end

    def rotary_knob_device_to_json device
      device_to_json device
    end

    def sensor_device_to_json device
      {
        sensors: device.sensors
      }.merge(device_to_json device)
    end

    def switch_device_to_json device
      {
        num_switches: device.num_switches,
        switches_per_row: device.switches_per_row
      }.merge(device_to_json device)
    end
  end

  helpers do
    inject :device_manager
    include JSONHelpers
  end
end
