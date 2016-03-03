class DeviceActionsController < ApplicationController

  include SortableController

  load_and_authorize_resource

  inject :device_action_manager

  def index
    @device_actions = DeviceAction.search(params[:q]).order("#{sort_column} #{sort_order}")
  end

  def show
  end

  def create
    if @device_action.update_attributes device_action_params
      device_action_manager.update_action @device_action
      render status: :ok, nothing: true
    else
      render status: :bad_request, json: { errors: @device_action.errors }
    end
  end

  def update
    if @device_action.update_attributes device_action_params
      device_action_manager.update_action @device_action
      render status: :ok, nothing: true
    else
      render status: :bad_request, json: { errors: @device_action.errors }
    end
  end

  def destroy
    if @device_action.destroy
      device_action_manager.delete_action @device_action
    end
    render status: :ok, nothing: true
  end

  def execute
    device_action_manager.executeAction @device_action
    render status: :ok, nothing: true
  end

  private
  def device_action_params
    json_params = ActionController::Parameters.new JSON.parse request.body.read
    json_params.permit :id, :name, :description, :script
  end

  private
  def default_sort_column
    :name
  end

end
