class WidgetsController < ApplicationController

  load_and_authorize_resource :dashboard
  load_and_authorize_resource :widget, through: :dashboard, except: :create

  before_action :set_specific_widget, only: [:show, :update]

  def create
    @widget = params[:type].singularize.camelcase.constantize.new
    # copy_subclass_params_to_nested_hash
    @widget.update_attributes widget_params
    @dashboard.widgets << @widget
    if @widget.save
      render json: { id: @widget.id }
    else
      render status: :bad_request, json: { errors: @widget.errors }
    end
  end

  def show
  end

  def update
    @widget.update_attributes widget_params
    render status: :ok, nothing: true
  end

  def destroy
    @widget.destroy
    render status: :ok, nothing: true
  end

  private
  def widget_params
    json_params = ActionController::Parameters.new JSON.parse request.body.read
    if @widget && params[:type].present?
      json_params.permit(@widget.class.attr_accessible)
    else
      json_params.permit Widget.attr_accessible
    end
  end

  private
  def copy_subclass_params_to_nested_hash
    p params
    (@widget.class.attr_accessible - Widget.attr_accessible).each do |attr|
      params[:widget][attr] ||= params[attr]
    end
  end

  private
  def set_specific_widget
    @widget = @widget.specific
  end

end