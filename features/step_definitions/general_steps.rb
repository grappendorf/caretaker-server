Given /I am authenticated as (?:a|an) (user|manager|administrator|admin)/ do |role|
  @current_user = case role
                    when 'user'
                      Fabricate :user
                    when 'manager'
                      Fabricate :manager
                    when 'admin', 'administrator'
                      Fabricate :admin
                  end
  self.instance_variable_set :@CURRENT_USER_ID, @current_user.id
  JsonSpec.memorize 'CURRENT_USER_ID', @current_user.id
  self.instance_variable_set :@CURRENT_USER_NAME, @current_user.name
  JsonSpec.memorize 'CURRENT_USER_NAME', @current_user.name
  allow_any_instance_of(AuthHelpers).to receive(:current_user).and_return @current_user
end
