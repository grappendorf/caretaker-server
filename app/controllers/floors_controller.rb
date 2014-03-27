class FloorsController < CRUDController

	include SortableController

	load_and_authorize_resource :building, except: :index
	load_and_authorize_resource :floor, through: :building, except: :index

	def index
		authorize! :read, Floor
		begin
			@building = Building.accessible_by(current_ability).find(params[:building_id])
			@floors = Floor.accessible_by(current_ability).in_building(@building).search(params[:q]).
					order_by(sort_column => sort_order_as_int).page(params[:page])
		rescue Mongoid::Errors::InvalidFind, Mongoid::Errors::DocumentNotFound
			@floors = nil
		end
		@buildings = Building.accessible_by(current_ability).only(:id, :name).all
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
		@building.floors << @floor
		if @floor.save
			flash[:success] = t('message.successfully_created', model: Floor.model_name.human, name: @floor.name)
			redirect_to building_floors_path(@building)
		else
			add_breadcrumbs
			flash.now[:error] = t('message.error_in_input_data', count: @floor.errors.count)
			render :new
		end
	end

	def edit
		add_breadcrumbs
	end

	def update
		respond_to do |format|
			if @floor.update_attributes floor_params
				format.html do
					flash[:success] = t('message.successfully_updated', model: Floor.model_name.human, name: @floor.name)
					redirect_to building_floors_path(@building)
				end
				format.json { head :no_content }
			else
				format.html do
					flash.now[:error] = t('message.error_in_input_data', count: @floor.errors.count)
					add_breadcrumbs
					render :edit
				end
				format.json { render json: {errors: @floor.errors}, status: :bad_request }
			end
		end
	end

	def destroy
		@floor.destroy
		flash[:success] = t('message.successfully_deleted', model: Floor.model_name.human, name: @floor.name)
		redirect_to building_floors_path(@building, @floor)
	end

	private
	def floor_params
		params.require(:floor).permit :name, :description
	end

	private
	def default_sort_column
		:_name
	end

	private
	def add_breadcrumbs
		if @building
			add_breadcrumb Building.model_name.human(count: 2), :buildings_path
			add_breadcrumb @building.name, edit_building_path(@building)
			add_breadcrumb Floor.model_name.human(count: 2), building_floors_path(@building)
			if @floor
				if @floor.persisted?
					add_breadcrumb @floor.name_was, edit_building_floor_path(@building, @floor)
				else
					add_breadcrumb t('action.new')
				end
			end
		else
			add_breadcrumb Floor.model_name.human(count: 2), floors_path
		end
	end

end
