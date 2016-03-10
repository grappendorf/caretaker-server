class API::Rooms < Base

  namespace 'buildings/:building_id/floors/:floor_id' do

    resource :rooms do

      desc 'Get a list of all rooms'
      params do
        optional :q, type: String, desc: 'Optional query string'
      end
      get do
        building = Building.find params[:building_id]
        authorize! :read, building
        floor = Floor.find params[:floor_id]
        authorize! :read, floor
        Room.search(params[:q]).on_floor(floor).accessible_by(current_ability).map do |room|
          {
            id: room.id,
            number: room.number,
            description: room.description
          }
        end
      end

      desc 'Get the number of all rooms'
      get 'count' do
        authorize! :read, Building.find(params[:building_id])
        floor = Floor.find params[:floor_id]
        authorize! :read, floor
        {
          count: Room.on_floor(floor).accessible_by(current_ability).count
        }
      end

      desc 'Get the numbers of all rooms'
      get 'numbers' do
        authorize! :read, Building.find(params[:building_id])
        floor = Floor.find params[:floor_id]
        authorize! :read, floor
        Room.on_floor(floor).accessible_by(current_ability).select(:id, :number).each do |room|
          {
            id: room.id,
            number: room.number
          }
        end
      end

      desc 'Get a new room'
      get 'new' do
        authorize! :read, Room
        room_to_json Room.new
      end

      desc 'Get a specific room'
      get ':id' do
        authorize! :read, Building.find(params[:building_id])
        authorize! :read, Floor.find(params[:floor_id])
        room = Room.find params[:id]
        authorize! :read, room
        room_to_json room
      end

      desc 'Get the number of a specific room'
      get ':id/number' do
        authorize! :read, Building.find(params[:id])
        authorize! :read, Floor.find(params[:id])
        room = Room.find params[:id]
        authorize! :read, room
        {
          id: room.id,
          number: room.number
        }
      end

      desc 'Create a new room'
      params do
        requires :number, type: String
        optional :description, type: String
      end
      post do
        authorize! :update, Building.find(params[:building_id])
        floor = Floor.find(params[:floor_id])
        authorize! :update, floor
        authorize! :create, Room
        room = floor.rooms.create! permitted_params
        {
          id: room.id
        }
      end

      desc 'Update a room'
      params do
        optional :number, type: String
        optional :description, type: String
      end
      put ':id' do
        authorize! :update, Building.find(params[:building_id])
        authorize! :update, Floor.find(params[:floor_id])
        room = Room.find params[:id]
        authorize! :update, room
        room.update_attributes! permitted_params
        body false
      end

      desc 'Delete a room'
      delete ':id' do
        authorize! :update, Building.find(params[:building_id])
        authorize! :update, Floor.find(params[:floor_id])
        room = Room.find params[:id]
        authorize! :destroy, room
        room.destroy
        body false
      end
    end

    helpers do
      def room_to_json room
        {
          id: room.persisted? ? room.id : nil,
          number: room.number,
          description: room.description
        }
      end
    end
  end
end
