class API::Buildings < Base

  resource :buildings do

    desc 'Get a list of all buildings'
    params do
      optional :q, type: String, desc: 'Optional query string'
    end
    get do
      authorize! :read, Building
      Building.search(params[:q]).accessible_by(current_ability).map do |building|
        {
          id: building.id,
          name: building.name,
          description: building.description
        }
      end
    end

    desc 'Get the number of all buildings'
    get 'count' do
      authorize! :read, Building
      {
        count: Building.accessible_by(current_ability).count
      }
    end

    desc 'Get the names of all buildings'
    get 'names' do
      Building.search(params[:q]).accessible_by(current_ability).select(:id, :name).each do |building|
        {
          id: building.id,
          name: building.name
        }
      end
    end

    desc 'Get a new building'
    get 'new' do
      authorize! :read, Building
      building_to_json Building.new
    end

    desc 'Get a specific building'
    get ':id' do
      building = Building.find params[:id]
      authorize! :read, building
      building_to_json building
    end

    desc 'Get the name of a specific building'
    get ':id/name' do
      building = Building.find params[:id]
      authorize! :read, building
      {
        id: building.id,
        name: building.name
      }
    end

    desc 'Create a new building'
    params do
      requires :name, type: String
      optional :description, type: String
    end
    post do
      authorize! :create, Building
      building = Building.create! permitted_params
      {
        id: building.id
      }
    end

    desc 'Update a building'
    params do
      requires :name, type: String
      optional :description, type: String
    end
    put ':id' do
      building = Building.find params[:id]
      authorize! :update, building
      building.update_attributes! permitted_params
      body false
    end

    desc 'Delete a building'
    delete ':id' do
      building = Building.find params[:id]
      authorize! :destroy, building
      building.destroy
      body false
    end
  end

  helpers do
    def building_to_json building
      {
        id: building.persisted? ? building.id : nil,
        name: building.name,
        description: building.description
      }
    end
  end
end
