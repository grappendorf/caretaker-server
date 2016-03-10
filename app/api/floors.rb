class API::Floors < Base

  namespace 'buildings/:building_id' do

    resource :floors do

      desc 'Get a list of all floors'
      params do
        optional :q, type: String, desc: 'Optional query string'
      end
      get do
        building = Building.find params[:building_id]
        authorize! :read, building
        Floor.search(params[:q]).in_building(building).accessible_by(current_ability).map do |floor|
          {
            id: floor.id,
            name: floor.name,
            description: floor.description
          }
        end
      end

      desc 'Get the number of all floors'
      get 'count' do
        building = Building.find params[:building_id]
        authorize! :read, building
        {
          count: Floor.in_building(building).accessible_by(current_ability).count
        }
      end

      desc 'Get the names of all floors'
      get 'names' do
        building = Building.find params[:building_id]
        authorize! :read, building
        Floor.in_building(building).accessible_by(current_ability).select(:id, :name).each do |floor|
          {
            id: floor.id,
            name: floor.name
          }
        end
      end

      desc 'Get a new floor'
      get 'new' do
        authorize! :read, Floor
        floor_to_json Floor.new
      end

      desc 'Get a specific floor'
      get ':id' do
        authorize! :read, Building.find(params[:building_id])
        floor = Floor.find params[:id]
        authorize! :read, floor
        floor_to_json floor
      end

      desc 'Get the name of a specific floor'
      get ':id/name' do
        authorize! :read, Building.find(params[:id])
        floor = Floor.find params[:id]
        authorize! :read, floor
        {
          id: floor.id,
          name: floor.name
        }
      end

      desc 'Create a new floor'
      params do
        requires :name, type: String
        optional :description, type: String
      end
      post do
        building = Building.find(params[:building_id])
        authorize! :update, building
        authorize! :create, Floor
        floor = building.floors.create! permitted_params
        {
          id: floor.id
        }
      end

      desc 'Update a floor'
      params do
        requires :name, type: String
        optional :description, type: String
      end
      put ':id' do
        authorize! :update, Building.find(params[:building_id])
        floor = Floor.find params[:id]
        authorize! :update, floor
        floor.update_attributes! permitted_params
        body false
      end

      desc 'Delete a floor'
      delete ':id' do
        authorize! :update, Building.find(params[:building_id])
        floor = Floor.find params[:id]
        authorize! :destroy, floor
        floor.destroy
        body false
      end
    end

    helpers do
      def floor_to_json floor
        {
          id: floor.persisted? ? floor.id : nil,
          name: floor.name,
          description: floor.description
        }
      end
    end
  end
end
