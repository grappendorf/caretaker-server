class DashboardsController < CRUDController

	layout_by_action [:default, :show] => 'application'

	include SortableController

	load_and_authorize_resource collection: [:names]

	skip_load_and_authorize_resource only: :default

	add_breadcrumb Dashboard.model_name.human(count: 2), :dashboards_path, except: [:show, :default]

	def index
		@dashboards = @dashboards.search(params[:q]).order_by(sort_column => sort_order_as_int).page(params[:page])
		respond_to do |format|
			format.html
			format.json { render json: @dashboards, except: [:widgets] }
		end
	end

	def names
		@dashboards = @dashboards.search_names(params[:q]).order_by(name: 1)
		respond_to { |format| format.json { render json: @dashboards, only: [:id, :name, :default] } }
	end

	def show
		respond_to do |format|
			format.html
			format.json { render json: @dashboard }
		end
	end

	def default
		if current_user && current_user.dashboards.default
			redirect_to dashboard_path(current_user.dashboards.default)
		elsif current_user
			render :no_dashboard_to_show
		else
			redirect_to new_user_session_path unless current_user
		end
	end

	def new
		add_breadcrumb t('action.new')
	end

	def create
		respond_to do |format|
			@dashboard.user = current_user.id
			if @dashboard.save
				format.html do
					flash[:success] = t('message.successfully_created', model: Dashboard.model_name.human, name: @dashboard.name)
					redirect_to dashboards_path
				end
				format.json { render json: {id: @dashboard.id}, location: @dashboard }
			else
				format.html do
					flash.now[:error] = t('message.error_in_input_data', count: @dashboard.errors.count)
					render :new
				end
				format.json { head :no_content }
			end
		end
	end

	def edit
		add_breadcrumb "#{@dashboard.name} (#{@dashboard.user.name})", dashboard_path(@dashboard)
	end

	def update
		respond_to do |format|
			if @dashboard.update_attributes dashboard_params
				format.html do
					redirect_to dashboards_path, flash: {success: t('message.successfully_updated',
					                                                model: Dashboard.model_name.human, name: @dashboard.name)}
				end
				format.json { head :no_content }
			else
				format.html { render :edit }
				format.json { head :no_content }
			end
		end
	end

	def destroy
		respond_to do |format|
			@dashboard.destroy
			format.html do
				flash[:success] = t('message.successfully_deleted', model: Dashboard.model_name.human, name: @dashboard.name)
				redirect_to dashboards_path
			end
			format.json { head :no_content }
		end
	end

	private
	def dashboard_params
		params.require(:dashboard).permit(Dashboard.attr_accessible)
	end

	private
	def default_sort_column
		:_name
	end

end
