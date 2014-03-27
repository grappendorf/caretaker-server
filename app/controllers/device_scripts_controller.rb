class DeviceScriptsController < CRUDController

  include SortableController

  load_and_authorize_resource

	add_breadcrumb DeviceScript.model_name.human(count: 2), :device_scripts_path

  inject :device_script_manager

	def index
		@device_scripts = DeviceScript.search(params[:q]).order_by(sort_column => sort_order_as_int).page(params[:page])
	end

	def new
		add_breadcrumb t('action.new')
		@device_script = DeviceScript.new
	end

	def create
		@device_script = DeviceScript.new device_script_params
		if @device_script.save
			device_script_manager.update_script @device_script
			flash[:success] = t('message.successfully_created', model: DeviceScript.model_name.human, name: @device_script.name)
			redirect_to device_scripts_path
		else
			flash.now[:error] = t('message.error_in_input_data', count: @device_script.errors.count)
			render :new
		end
	end

	def show
		@readonly = true
	end

	def edit
		@device_script = DeviceScript.find params[:id]
		add_breadcrumb @device_script.name, device_script_path(@device_script)
	end

	def update
		@device_script = DeviceScript.find params[:id]
		if @device_script.update_attributes device_script_params
			device_script_manager.update_script @device_script
			respond_to do |format|
				format.html { redirect_to device_scripts_path, flash: {
						success: t('message.successfully_updated', model: DeviceScript.model_name.human, name: @device_script.name)} }
				format.json { head :no_content }
			end
		else
			respond_to do |format|
				format.html { render :edit }
				format.json { render json: @device_script.errors.full_messages.first, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@device_script = DeviceScript.find params[:id]
		@device_script.destroy
		flash[:success] = t('message.successfully_deleted', model: DeviceScript.model_name.human, name: @device_script.name)
		redirect_to device_scripts_path
	end

	def enable
		@device_script = DeviceScript.find params[:id]
		@device_script.update_attribute :enabled, true
		respond_to do |format|
			format.html { redirect_to device_scripts_path, success: "#{@device_script.name} is now enabled" }
			format.json { head :no_content }
		end
	end

	def disable
		@device_script = DeviceScript.find params[:id]
		@device_script.update_attribute :enabled, false
		respond_to do |format|
			format.html { redirect_to device_scripts_path, success: "#{@device_script.name} is now disabled" }
			format.json { head :no_content }
		end
	end

	private
	def device_script_params
    params.require(:device_script).permit(DeviceScript.attr_accessible)
  end

  private
  def default_sort_column
    :_name
  end

end
