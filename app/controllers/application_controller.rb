class ApplicationController < ActionController::Base

	protect_from_forgery

	before_filter :fix_strong_parameters_for_cancan, only: :create

	add_flash_types :succes, :info, :warning, :danger, :error

	helper_method :xeditable?

	rescue_from CanCan::AccessDenied do |exception|
		if current_user.nil?
			session[:after_sign_in_redirect_to] = request.url
			redirect_to new_user_session_path, error: t('message.error_not_logged_in')
		elsif request.env['HTTP_REFERER'].present?
			redirect_to :back, error: t('message.error_not_authorized')
		else
			flash[:error] = t('message.error_not_authorized')
			render 'errors/403', status: 403
		end
	end

	def after_sign_in_path_for resource
		redirect_back = session[:after_sign_in_redirect_to]
		session.delete :after_sign_in_redirect_to
		unless redirect_back.nil? || redirect_back == new_user_session_url
			redirect_back
		else
			root_path
		end
	end

	private
	def after_sign_out_path_for resource_or_scope
		new_user_session_path
	end

	private
	def fix_strong_parameters_for_cancan
		resource = controller_name.singularize.to_sym
		method = "#{resource}_params"
		params[resource] &&= send(method) if respond_to?(method, true)
	end

	private
	def xeditable? object = nil
		can?(:edit, object) ? true : false
	end

end
