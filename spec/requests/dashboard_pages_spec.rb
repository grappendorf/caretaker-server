require 'spec_helper'

describe 'Dashboard Pages' do

	subject { page }

	let(:user) { Fabricate :admin }

	before { sign_in user }

	describe 'Link to the dashboards list' do
		before { visit root_path }
		it { should have_link 'Dashboards', href: dashboards_path }
	end

	describe 'Index' do

		describe 'page' do

			before do
				3.times { Fabricate :dashboard }
				visit dashboards_path
			end

			it { should have_title 'Dashboards' }
			it { should have_link 'New', href: new_dashboard_path }
			it { should have_selector 'th', text: 'Name' }
			it { should have_selector 'th', text: 'User' }
			it { should have_selector 'th', text: 'Default' }
			it 'should display all dashboards with action links' do
				Dashboard.all.each do |dashboard|
					should have_selector 'td', text: dashboard.name
					should have_selector 'td', text: dashboard.user.name
					should have_link 'Edit', href: edit_dashboard_path(dashboard)
					should have_link 'Delete', href: dashboard_path(dashboard)
				end
			end

		end

	end

end