class SessionsController < Devise::SessionsController

	def create
		respond_to do |format|
			format.html { super }
			format.json do
				warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
				render status: 200, json: {success: true, message: 'Logged in',
				                           user: {
						                           id: current_user.id,
						                           email: current_user.email,
						                           name: current_user.name,
						                           roles: current_user.roles.map(&:name)}}
			end
		end
	end

	def destroy
		respond_to do |format|
			format.html { super }
			format.json do
				# warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
				sign_out
				render status: 200, json: {success: true, message: 'Logged out'}
			end
		end
	end

	def failure
		render status: 401, json: {success: false, message: 'Login credentials failed'}
	end

end