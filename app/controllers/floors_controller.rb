class FloorsController < ApplicationController

  include SortableController

  load_and_authorize_resource :building, except: :index
  load_and_authorize_resource :floor, through: :building, except: :index

  def index
    authorize! :read, Floor
    begin
      @building = Building.accessible_by(current_ability).find(params[:building_id])
      @floors = Floor.accessible_by(current_ability).in_building(@building).search(params[:q]).
          order("#{sort_column} #{sort_order}").page(params[:page])
    rescue ActiveRecord::RecordNotFound
      @floors = nil
    end
  end

  def names
    @floors = Floor.in_building(params[:building_id]).accessible_by(current_ability).select(:id, :name)
  end

  def show
  end

  def name
  end

  def create
    if @floor.update_attributes floor_params
      render status: :ok, nothing: true
    else
      render status: :bad_request, json: { errors: @floor.errors }
    end
  end

  def update
    if @floor.update_attributes floor_params
      render status: :ok, nothing: true
    else
      render status: :bad_request, json: { errors: @floor.errors }
    end
  end

  def destroy
    @floor.destroy
    render status: :ok, nothing: true
  end

  private
  def floor_params
    json_params = ActionController::Parameters.new JSON.parse request.body.read
    json_params.permit :id, :name, :description
  end

  private
  def default_sort_column
    :name
  end

end
