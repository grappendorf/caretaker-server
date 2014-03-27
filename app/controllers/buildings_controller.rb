class BuildingsController < CRUDController

	include SortableController

	load_and_authorize_resource

	def index
		@buildings = @buildings.search(params[:q]).order_by(sort_column => sort_order_as_int).page(params[:page])
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
		if @building.save
			flash[:success] = t('message.successfully_created', model: Building.model_name.human, name: @building.name)
			redirect_to buildings_path
		else
			flash.now[:error] = t('message.error_in_input_data', count: @building.errors.count)
			add_breadcrumbs
			render :new
		end
	end

	def edit
		add_breadcrumbs
	end

	def update
		respond_to do |format|
			if @building.update_attributes building_params
				format.html do
					flash[:success] = t('message.successfully_updated', model: Building.model_name.human, name: @building.name)
					redirect_to buildings_path
				end
				format.json { head :no_content }
			else
				format.html do
					flash.now[:error] = t('message.error_in_input_data', count: @building.errors.count)
					add_breadcrumbs
					render :edit
				end
				format.json { render json: {errors: @building.errors}, status: :bad_request }
			end
		end
	end

	def destroy
		@building.destroy
		flash[:success] = t('message.successfully_deleted', model: Building.model_name.human, name: @building.name)
		redirect_to buildings_path
	end

	private
	def building_params
		params.require(:building).permit :name, :description
	end

	private
	def default_sort_column
		:name
	end

	private
	def add_breadcrumbs
		add_breadcrumb Building.model_name.human(count: 2), :buildings_path
		if @building
			if @building.persisted?
				add_breadcrumb @building.name_was, edit_building_path(@building)
			else
				add_breadcrumb t('action.new')
			end
		end
	end

end
