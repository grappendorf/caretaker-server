require 'spec_helper'

describe 'Home page' do

	subject { page }

	before { visit root_path }

	it { should have_title 'CoYoHo - Control Your Home' }
	it { should have_link 'Home', href: root_path }
	it { should have_link 'Sign in', href: new_user_session_path }
	it { should have_link 'www.grappendorf.net', href: 'http://www.grappendorf.net' }

end
