class RoomsController < CRUDController

	include SortableController

	load_and_authorize_resource :floor, except: :index
	load_and_authorize_resource :room, through: :floor, except: :index

	before_action -> {@building = @floor.building}, except: :index

	def index
		authorize! :read, Room
		begin
			@floor = Floor.accessible_by(current_ability).find params[:floor_id]
			@building = Building.accessible_by(current_ability).find params[:building_id] if params[:building_id]
			@building = @floor.building unless @building
			if @floor.building == @building
				@rooms = Room.accessible_by(current_ability).on_floor(@floor).search(params[:q]).
						order_by(sort_column => sort_order_as_int).page(params[:page])
			else
				@rooms = nil
				@floor = nil
			end
		rescue Mongoid::Errors::InvalidFind, Mongoid::Errors::DocumentNotFound
			@rooms = nil
			begin
				@building = Building.accessible_by(current_ability).find params[:building_id]
			rescue Mongoid::Errors::InvalidFind, Mongoid::Errors::DocumentNotFound
			end
		end
		@buildings = Building.only(:id, :name).all
		@floors = Floor.in_building(@building).only(:id, :name).all
		add_breadcrumbs
	end

	def show
		@readonly = true
		add_breadcrumbs
	end

	def new
		add_breadcrumbs
	end

	def create
		@floor.rooms << @room
		if @room.save
			flash[:success] = t('message.successfully_created', model: Room.model_name.human, name: @room.number)
			redirect_to building_floor_rooms_path(@floor.building, @floor)
		else
			flash.now[:error] = t('message.error_in_input_data', count: @room.errors.count)
			render :new
		end
	end

	def edit
		add_breadcrumbs
	end

	def update
		respond_to do |format|
			if @room.update_attributes room_params
				format.html do
					flash[:success] = t('message.successfully_updated', model: Room.model_name.human, name: @room.number)
					redirect_to building_floor_rooms_path(@floor.building, @floor)
				end
				format.json { head :no_content }
			else
				format.html do
					flash.now[:error] = t('message.error_in_input_data', count: @room.errors.count)
					render :edit
				end
				format.json { render json: {errors: @room.errors}, status: :bad_request }
			end
		end
	end

	def destroy
		@room.destroy
		flash[:success] = t('message.successfully_deleted', model: Room.model_name.human, name: @room.number)
		redirect_to building_floor_rooms_path(@floor.building, @floor)
	end

	def room_params
		params.require(:room).permit :number, :description
	end

	private
	def default_sort_column
		:number
	end

	private
	def add_breadcrumbs
		if @building
			add_breadcrumb Building.model_name.human(count: 2), :buildings_path
			add_breadcrumb @building.name, edit_building_path(@building)
			add_breadcrumb Floor.model_name.human(count: 2), building_floors_path(@building)
			if @floor
				add_breadcrumb @floor.name, edit_building_floor_path(@building, @floor)
				add_breadcrumb Room.model_name.human(count: 2), building_floor_rooms_path(@building, @floor)
				if @room
					if @room.persisted?
						add_breadcrumb @room.number_was, edit_building_floor_room_path(@building, @floor, @room)
					else
						add_breadcrumb t('action.new')
					end
				end
			else
			end
		else
			add_breadcrumb Room.model_name.human(count: 2), rooms_path
		end
	end
end
