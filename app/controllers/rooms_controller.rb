class RoomsController < ApplicationController

  include SortableController

  load_and_authorize_resource :floor, except: :index
  load_and_authorize_resource :room, through: :floor, except: :index

  before_action -> { @building = @floor.building }, except: :index

  def index
    authorize! :read, Room
    begin
      @floor = Floor.accessible_by(current_ability).find params[:floor_id]
      @building = Building.accessible_by(current_ability).find params[:building_id] if params[:building_id]
      @building = @floor.building unless @building
      if @floor.building == @building
        @rooms = Room.accessible_by(current_ability).on_floor(@floor).search(params[:q]).
            order("#{sort_column} #{sort_order}").page(params[:page])
      else
        @rooms = nil
        @floor = nil
      end
    rescue ActiveRecord::RecordNotFound
      @rooms = nil
      begin
        @building = Building.accessible_by(current_ability).find params[:building_id]
      rescue ActiveRecord::RecordNotFound
      end
    end
  end

  def show
  end

  def create
    if @room.update_attributes room_params
      render status: :ok, nothing: true
    else
      render status: :bad_request, json: { errors: @room.errors }
    end
  end

  def update
    if @room.update_attributes room_params
      render status: :ok, nothing: true
    else
      render status: :bad_request, json: { errors: @room.errors }
    end
  end

  def destroy
    @room.destroy
    render status: :ok, nothing: true
  end

  def room_params
    json_params = ActionController::Parameters.new JSON.parse request.body.read
    json_params.permit :id, :number, :description
  end

  private
  def default_sort_column
    :number
  end

end
