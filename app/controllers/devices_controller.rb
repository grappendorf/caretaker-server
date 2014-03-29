class DevicesController < CRUDController

	include SortableController

	inject :device_manager

	load_and_authorize_resource

	add_breadcrumb Device.model_name.human(count: 2), :devices_path

	def index
		@devices = Device.search(params[:q]).order_by(sort_column => sort_order_as_int).page(params[:page])
		respond_to do |format|
			format.html
			format.json { render json: @devices, only: [:id, :name] } if params[:x]
			format.json { render json: @devices } unless params[:x]
		end
	end

	def names
		@devices = Device.search_names(params[:q]).order_by(name: 1)
		respond_to { |format| format.json { render json: @devices, only: [:id, :name] } }
	end

	def new
		@device = params[:type].singularize.camelcase.constantize.new
		add_breadcrumb t('action.new')
	end

	def create
		type = params[:type]
		@device = type.camelcase.constantize.new
		@device.update_attributes device_params(@device)
		if @device.save
			device_manager.add_device @device
			flash[:success] = t('message.successfully_created', model: Device.model_name.human, name: @device.name)
			redirect_to devices_path
		else
			flash.now[:error] = t('message.error_in_input_data', count: @device.errors.count)
			render :new
		end
	end

	def show
		respond_to do |format|
			format.html { @readonly = true }
			format.json { render json: @device }
		end
	end

	def edit
		@device = Device.find(params[:id])
		add_breadcrumb @device.name, device_path(@device)
	end

	def update
		respond_to do |format|
			@device = Device.find(params[:id])
			if @device.update_attributes device_params(@device)
				device_manager.update_device @device
				format.html { redirect_to devices_path, flash: {
						success: t('message.successfully_updated', model: Device.model_name.human, name: @device.name)} }
				format.json { head :no_content }
			else
				format.html { render :edit }
				format.json { render json: @device.errors.full_messages.first, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@device = Device.find(params[:id])
		device_manager.remove_device @device.id
		@device.destroy
		flash[:success] = t('message.successfully_deleted', model: Device.model_name.human, name: @device.name)
		redirect_to devices_path
	end

	private
	def device_params device
		params.require(device.model_name.singular).permit(device.class.attr_accessible)
	end

	private
	def default_sort_column
		:name
	end

end
