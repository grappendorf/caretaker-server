require 'spec_helper'

describe 'Breadcrumb' do

	subject { page }

	let(:admin) { FactoryGirl.create :admin }
	let(:user) { FactoryGirl.create :user }

	describe 'on a top level page' do
		before { visit new_user_session_path }
		it { should_not have_selector 'ul.breadcrumb' }
	end

	describe 'on the user list page' do
		before do
			sign_in admin
			visit users_path
		end
		it { should have_selector 'ul.pretty-breadcrumb li', text: 'Users' }
	end

	describe 'on a user edit page' do
		before do
			sign_in admin
			visit edit_user_path user
		end
		it { should have_selector 'ul.pretty-breadcrumb li', text: 'Users' }
		it { should have_selector 'ul.pretty-breadcrumb li', text: user.name }
	end

end
