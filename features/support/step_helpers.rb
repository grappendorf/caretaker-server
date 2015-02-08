def sign_in user, password
  visit root_path
  fill_in 'Email', with: user
  fill_in 'Password', with: password
  click_button 'Sign in'
end

def sign_in_as role
  unless signed_in_as? role
    user_info = {
        user: ['user@example.com', 'password'],
        manager: ['manager@example.com', 'password'],
        admin: ['admin@example.com', 'password']
    }[role]
    sign_in user_info[0], user_info[1]
    @current_user = User.find_by email: user_info[0]
  end
end

def signed_in_as? role
  @current_user && @current_user.has_role?(role)
end
