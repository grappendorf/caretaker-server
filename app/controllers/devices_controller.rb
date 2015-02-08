class DevicesController < ApplicationController

	include SortableController

	inject :xbee_device_manager

	load_and_authorize_resource

	before_action :set_specific_device, only: [:show, :edit, :update]

	def index
		@devices = @devices.search(params[:q]).order("#{sort_column} #{sort_order}").page(params[:page])
	end

	def names
		@devices = Device.accessible_by(current_ability).search_names(params[:q]).order('name asc')
	end

	def new
		@device = params[:type].singularize.camelcase.constantize.new
	end

	def create
		@device = params[:type].singularize.camelcase.constantize.new
		@device.update_attributes device_params(@device)
		if @device.save
			xbee_device_manager.add_device @device
			render status: :ok, nothing: true
		else
			render status: :bad_request, json: {errors: @device.errors}
		end
	end

	def show
	end

	def update
		if @device.update_attributes device_params(@device)
			xbee_device_manager.update_device @device
			render status: :ok, nothing: true
		else
			render status: :bad_request, json: {errors: @device.errors}
		end
	end

	def destroy
		model_name = @device.specific.class.model_name.human
		device_name = @device.name
		xbee_device_manager.remove_device @device.id
		@device.destroy
		flash[:success] = t('message.successfully_deleted', model: model_name, name: device_name)
		redirect_to devices_path
	end

	private
	def device_params device
		json_params = ActionController::Parameters.new JSON.parse request.body.read
		json_params.permit(device.class.attr_accessible)
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
