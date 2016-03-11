class API::DeviceActions < Base

  resource :device_actions do

    desc 'Get a list of all device actions'
    params do
      optional :q, type: String, desc: 'Optional query string'
    end
    get do
      authorize! :read, DeviceAction
      DeviceAction.search(params[:q]).accessible_by(current_ability).map do |device_action|
        {
          id: device_action.id,
          name: device_action.name,
          description: device_action.description
        }
      end
    end

    desc 'Get the number of all device actions'
    get 'count' do
      authorize! :read, DeviceAction
      {
        count: DeviceAction.accessible_by(current_ability).count
      }
    end

    desc 'Get a new device action'
    get 'new' do
      authorize! :read, DeviceAction
      device_action_to_json DeviceAction.new
    end

    desc 'Get a specific device action'
    get ':id' do
      device_action = DeviceAction.find params[:id]
      authorize! :read, device_action
      device_action_to_json device_action
    end

    desc 'Execute a device scripts'
    put ':id/execute' do
      device_action = DeviceAction.find params[:id]
      authorize! :execute, device_action
      device_action_manager.execute_action device_action
      body false
    end

    desc 'Create a new device action'
    params do
      requires :name, type: String
      optional :script, type: String
      optional :description, type: String
    end
    post do
      authorize! :create, DeviceAction
      device_action = DeviceAction.create! permitted_params
      device_action_manager.update_action device_action
      {
        id: device_action.id
      }
    end

    desc 'Update a device action'
    params do
      optional :name, type: String
      optional :script, type: String
      optional :description, type: String
    end
    put ':id' do
      device_action = DeviceAction.find params[:id]
      authorize! :update, device_action
      device_action.update_attributes! permitted_params
      device_action_manager.update_action device_action
      body false
    end

    desc 'Delete a device action'
    delete ':id' do
      device_action = DeviceAction.find(params[:id])
      authorize! :destroy, device_action
      device_action.destroy
      device_action_manager.remove_action device_action
      body false
    end
  end

  helpers do
    inject :device_action_manager

    def device_action_to_json device_action
      {
        id: device_action.persisted? ? device_action.id : nil,
        name: device_action.name,
        description: device_action.description,
        script: device_action.script
      }
    end
  end
end
