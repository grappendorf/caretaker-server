class DashboardsController < ApplicationController

  include SortableController

  load_and_authorize_resource collection: [:names]

  skip_load_and_authorize_resource only: :default

  def index
    @dashboards = @dashboards.search(params[:q]).order("#{sort_column} #{sort_order}").page(params[:page])
  end

  def names
    @dashboards = @dashboards.search_names(params[:q]).order('name asc')
  end

  def show
  end

  def default
    if current_user && current_user.dashboards.default
      @dashboard = current_user.dashboards.default
    else
      render status: :not_found, nothing: true
    end
  end

  def create
    @dashboard = Dashboard.new dashboard_params
    @dashboard.user ||= current_user
    if @dashboard.save
      render status: :ok, json: { id: @dashboard.id }
    else
      render status: :bad_request, json: { errors: @dashboard.errors }
    end
  end

  def update
    if @dashboard.update_attributes dashboard_params
      render status: :ok, nothing: true
    else
      render status: :bad_request, json: { errors: @dashboard.errors }
    end
  end

  def destroy
    @dashboard.destroy
    render status: :ok, nothing: true
  end

  private
  def dashboard_params
    json_params = ActionController::Parameters.new JSON.parse request.body.read
    json_params.permit :id, :name, :default
  end

  private
  def default_sort_column
    :name
  end

end
