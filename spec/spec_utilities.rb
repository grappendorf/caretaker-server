def saop
	save_and_open_page
end

def sign_in user, password: 'password'
	visit new_user_session_path
	fill_in 'Email', with: user.email
	fill_in 'Password', with: password
	click_button 'Sign in'
end

def check_or_uncheck locator, checked
	if checked
		check locator
	else
		uncheck locator
	end
end

def have_disabled_link *args
	have_selector 'a[disabled]', *args
end

def click_href href
	find(:xpath, "//a[@href='#{href}']").click
end

RSpec::Matchers.define :show_an_authorization_error do |expected|
	match do |actual|
		actual.should have_selector '.alert-error'
		actual.should have_text 'You are not authorized'
	end

	failure_message_for_should do |_|
		'expected the page to show an authorization error'
	end

	failure_message_for_should_not do |_|
		'expected the page not to show an authorization error'
	end

	description do
		'the page shows an authorization error'
	end
end
