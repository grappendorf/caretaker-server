class API::DeviceScripts < Base

  resource :device_scripts do

    desc 'Get a list of all device scripts'
    params do
      optional :q, type: String, desc: 'Optional query string'
    end
    get do
      authorize! :read, DeviceScript
      DeviceScript.search(params[:q]).accessible_by(current_ability).map do |device_script|
        {
          id: device_script.id,
          name: device_script.name,
          enabled: device_script.enabled,
          description: device_script.description
        }
      end
    end

    desc 'Get the number of all device scripts'
    get 'count' do
      authorize! :read, DeviceScript
      {
        count: DeviceScript.accessible_by(current_ability).count
      }
    end

    desc 'Get a new device script'
    get 'new' do
      authorize! :read, DeviceScript
      device_script_to_json DeviceScript.new
    end

    desc 'Get a specific device script'
    get ':id' do
      device_script = DeviceScript.find params[:id]
      authorize! :read, device_script
      device_script_to_json device_script
    end

    desc 'Disable a device scripts'
    put ':id/disable' do
      device_script = DeviceScript.find params[:id]
      authorize! :update, device_script
      device_script.update_attribute :enabled, false
      device_script_manager.update_script device_script
      body false
    end

    desc 'Enable a device scripts'
    put ':id/enable' do
      device_script = DeviceScript.find params[:id]
      authorize! :update, device_script
      device_script.update_attribute :enabled, true
      device_script_manager.update_script device_script
      body false
    end

    desc 'Create a new device script'
    params do
      requires :name, type: String
      optional :script, type: String
      optional :enabled, type: Boolean
      optional :description, type: String
    end
    post do
      authorize! :create, DeviceScript
      device_script = DeviceScript.create! permitted_params
      device_script_manager.update_script device_script
      {
        id: device_script.id
      }
    end

    desc 'Update a device script'
    params do
      optional :name, type: String
      optional :script, type: String
      optional :enabled, type: Boolean
      optional :description, type: String
    end
    put ':id' do
      device_script = DeviceScript.find params[:id]
      authorize! :update, device_script
      device_script.update_attributes! permitted_params
      device_script_manager.update_script device_script
      body false
    end

    desc 'Delete a device script'
    delete ':id' do
      device_script = DeviceScript.find(params[:id])
      authorize! :destroy, device_script
      device_script.destroy
      device_script_manager.remove_script device_script
      body false
    end
  end

  helpers do
    inject :device_script_manager

    def device_script_to_json device_script
      {
        id: device_script.persisted? ? device_script.id : nil,
        name: device_script.name,
        enabled: device_script.enabled,
        description: device_script.description,
        script: device_script.script
      }
    end
  end
end
