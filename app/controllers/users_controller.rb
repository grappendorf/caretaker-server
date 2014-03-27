class UsersController < CRUDController

	layout_by_action [:show, :edit] => 'application'

	include SortableController

	load_resource except: [:index, :update]
	authorize_resource

	def index
		@users = User.search(params[:q]).accessible_by(current_ability).
				order_by(sort_column => sort_order_as_int).page(params[:page])
		add_breadcrumb User.model_name.human(count: 2), :users_path
	end

	def new
		add_breadcrumb User.model_name.human(count: 2), :users_path
		add_breadcrumb t('action.new')
	end

	def create
		if @user.save
			flash[:success] = t('message.successfully_created', model: User.model_name.human, name: @user.name)
			redirect_to users_path
		else
			flash.now[:error] = t('message.error_in_input_data', count: @user.errors.count)
			render :new
		end
	end

	def show
	end

	def edit
		@myself = params[:myself].try :to_sym
		@return_to = @myself ? request.referrer : users_path
		unless @myself
			add_breadcrumb User.model_name.human(count: 2), :users_path
			add_breadcrumb @user.name, user_path(@user)
		end
	end

	def update
		if current_user.has_role? :admin
			params[:user].delete(:password) if params[:user][:password].blank?
			params[:user].delete(:password_confirmation) if params[:user][:password_confirmation].blank?
		end
		@user = User.find params[:id]
		@myself = params[:myself].try :to_sym
		if @user.update_attributes user_params
			respond_to do |format|
				format.html do
					case @myself
						when :profile
							flash[:success] = t('message.successfully_saved_profile')
							redirect_to params[:return_to]
						when :password
							unless @user.password.blank?
								flash[:success] = t('message.successfully_changed_password')
							else
								flash[:notice] = t('message.password_remains_unchanged')
							end
							redirect_to params[:return_to]
						else
							flash[:success] = t('message.successfully_updated', model: User.model_name.human, name: @user.email)
							redirect_to users_path
					end
				end
				format.json { head :no_content }
			end
		else
			respond_to do |format|
				format.html { render :edit }
				format.json { render json: {errors: @user.errors}, status: :bad_request }
			end
		end
	end

	def destroy
		@user.destroy
		redirect_to users_path
	end

	private
	def user_params
		params.require(:user).permit :name, :email, :password, :password_confirmation, role_ids: []
	end

	private
	def default_sort_column
		:name
	end

end
