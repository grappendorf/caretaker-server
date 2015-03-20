class BuildingsController < ApplicationController

  include SortableController

  load_and_authorize_resource

  def index
    @buildings = @buildings.search(params[:q]).order("#{sort_column} #{sort_order}").page(params[:page])
  end

  def names
    @buildings = Building.accessible_by(current_ability).select(:id, :name)
  end


  def show
  end

  def name
  end

  def create
    if @building.update_attributes building_params
      render status: :ok, nothing: true
    else
      render status: :bad_request, json: { errors: @building.errors }
    end
  end

  def update
    if @building.update_attributes building_params
      render status: :ok, nothing: true
    else
      render status: :bad_request, json: { errors: @building.errors }
    end
  end

  def destroy
    @building.destroy
    render status: :ok, nothing: true
  end

  private
  def building_params
    json_params = ActionController::Parameters.new JSON.parse request.body.read
    json_params.permit :id, :name, :description
  end

  private
  def default_sort_column
    :name
  end

end
