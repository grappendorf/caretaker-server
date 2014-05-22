class WidgetsController < ApplicationController

	load_and_authorize_resource :dashboard
	load_and_authorize_resource :widget, through: :dashboard, except: :create

	def create
		respond_to do |format|
			@widget = params[:type].singularize.camelcase.constantize.new
			copy_subclass_params_to_nested_hash
			@widget.update_attributes widget_params
			@dashboard.widgets << @widget
			if @widget.save
				format.json { render json: {id: @widget.id}, location: dashboard_widget_url(@dashboard, @widget) }
			else
				format.json { render json: {errors: @widget.errors}, status: :bad_request }
			end
		end
	end

	def show
		respond_to do |format|
			format.html
			format.json { render json: @widget.specific }
		end
	end

	def update
		@widget.specific.update_attributes widget_params
		respond_to do |format|
			format.json { head :no_content }
		end
	end

	def destroy
		@widget.destroy
		respond_to do |format|
			format.json { head :no_content }
		end
	end

	private
	def widget_params
		if @widget && params[:type].present?
			params.require(:widget).permit(@widget.class.attr_accessible)
		else
			params.require(:widget).permit Widget.attr_accessible
		end
	end

	private
	def copy_subclass_params_to_nested_hash
		(@widget.class.attr_accessible - Widget.attr_accessible).each do |attr|
			params[:widget][attr] ||= params[attr]
		end
	end

end