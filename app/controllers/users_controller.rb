class UsersController < ApplicationController

	include SortableController

	load_resource except: [:index, :update]
	authorize_resource

	def index
		@users = User.search(params[:q]).accessible_by(current_ability).
				order("#{sort_column} #{sort_order}").page(params[:page])
	end

	def create
		if @user.save
			render status: :ok, nothing: true
		else
			render status: :bad_request, json: {errors: @user.errors}
		end
	end

	def show
	end

	def update
		if current_user.has_role?(:admin)
			params.delete(:password) if params[:password].blank?
			params.delete(:password_confirmation) if params[:password_confirmation].blank?
		end
		@user = User.find params[:id]
		if @user.update_attributes user_params
			render status: :ok, nothing: true
		else
			render status: :bad_request, json: {errors: @user.errors}
		end
	end

	def destroy
		@user.destroy
		render status: :ok, nothing: true
	end

	private
	def user_params
		json_params = ActionController::Parameters.new JSON.parse request.body.read
		json_params.permit :id, :name, :email, :password, :password_confirmation, role_ids: []
	end

	private
	def default_sort_column
		:name
	end

end
