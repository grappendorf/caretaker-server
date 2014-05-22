class DevicesController < CRUDController

	include SortableController

	inject :device_manager

	load_and_authorize_resource

	before_action :set_specific_device, only: [:show, :edit, :update]

	def index
		add_breadcrumb Device.model_name.human(count: 2), :devices_path
		@devices = @devices.search(params[:q]).order("#{sort_column} #{sort_order}").page(params[:page])
		respond_to do |format|
			format.html
			format.json { render json: @devices, only: [:id, :name] } if params[:x]
			format.json { render json: @devices } unless params[:x]
		end
	end

	def names
		@devices = Device.accessible_by(current_ability).search_names(params[:q]).order('name asc')
		respond_to { |format| format.json { render json: @devices, only: [:id, :name] } }
	end

	def new
		@device = params[:type].singularize.camelcase.constantize.new
		add_breadcrumb @device.class.model_name.human(count: 2), :devices_path
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
		add_breadcrumb Device.model_name.human(count: 2), :devices_path
		respond_to do |format|
			format.html { @readonly = true }
			format.json { render json: @device }
		end
	end

	def edit
		add_breadcrumb @device.class.model_name.human(count: 2), :devices_path
		add_breadcrumb @device.name, device_path(@device)
	end

	def update
		respond_to do |format|
			if @device.update_attributes device_params(@device)
				device_manager.update_device @device
				format.html { redirect_to devices_path, flash: {
						success: t('message.successfully_updated', model: @device.class.model_name.human, name: @device.name)} }
				format.json { head :no_content }
			else
				format.html { render :edit }
				format.json { render json: @device.errors.full_messages.first, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		model_name = @device.specific.class.model_name.human
		device_name = @device.name
		device_manager.remove_device @device.id
		@device.destroy
		flash[:success] = t('message.successfully_deleted', model: model_name, name: device_name)
		redirect_to devices_path
	end

	private
	def device_params device
		params.require(device.class.model_name.singular).permit(device.class.attr_accessible)
	end

	private
	def default_sort_column
		:name
	end

	private
	def set_specific_device
		@device = @device.specific
	end

end
