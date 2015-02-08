class DeviceScriptsController < ApplicationController

  include SortableController

  load_and_authorize_resource

  inject :device_script_manager

  def index
    @device_scripts = DeviceScript.search(params[:q]).order("#{sort_column} #{sort_order}").page(params[:page])
  end

  def create
    @device_script = DeviceScript.new device_script_params
    if @device_script.save
      device_script_manager.update_script @device_script
      render status: :ok, nothing: true
    else
      render status: :bad_request, json: { errors: @device_script.errors }
    end
  end

  def show
  end

  def update
    if @device_script.update_attributes device_script_params
      device_script_manager.update_script @device_script
      render status: :ok, nothing: true
    else
      render status: :bad_request, json: { errors: @device_script.errors }
    end
  end

  def destroy
    @device_script = DeviceScript.find params[:id]
    @device_script.destroy
    render status: :ok, nothing: true
  end

  def enable
    @device_script = DeviceScript.find params[:id]
    @device_script.update_attribute :enabled, true
    render status: :ok, nothing: true
  end

  def disable
    @device_script = DeviceScript.find params[:id]
    @device_script.update_attribute :enabled, false
    render status: :ok, nothing: true
  end

  private
  def device_script_params
    json_params = ActionController::Parameters.new JSON.parse request.body.read
    json_params.permit :id, :name, :description, :script, :enabled
  end

  private
  def default_sort_column
    :name
  end

end
