require 'spec_helper'

describe 'Authentication Pages' do

	subject { page }

	describe 'When not signed in' do

		describe 'on the root page' do
			before { visit root_path }
			it { should have_link 'Home', root_path }
		end

	end

	describe 'Signin page' do
		before { visit new_user_session_path }
		it { should have_title 'Sign in' }
		it { should have_selector 'h2', text: /Sign in/i }
		it { should have_field 'Email' }
		it { should have_field 'Password' }
	end

	describe 'signin' do

		before { visit new_user_session_path }

		describe 'with invalid information' do

			before { click_button 'Sign in' }

			it { should have_title 'Sign in' }
			it { should have_selector 'h2', text: /Sign in/i }
			it { should have_selector 'div.alert', text: 'Invalid' }

		end

		describe 'with valid information' do

			let(:user) { Fabricate :admin }

			before do
				fill_in 'Email', with: user.email
				fill_in 'Password', with: 'password'
				click_button 'Sign in'
			end

			describe 'functions for signed in users are displayed' do
				it { should have_link 'Sign out', href: destroy_user_session_path }
				it { should_not have_link 'Sign in', href: new_user_session_path }
				it { should have_link 'Dashboards', href: default_dashboards_path }
				it { should have_link 'System', href: '#' }
				it { should have_link 'Manage', href: '#' }
				it { should have_link user.name, href: '#' }
				it { should have_link 'Profile', href: edit_user_path(user, myself: :profile) }
				it { should have_link 'Change password', href: edit_user_path(user, myself: :password) }
			end

			describe 'the user is redirected to the default dashboard page' do
				it { should have_title 'Dashboard' }
			end

		end

	end

	describe 'signout' do

		let(:user) { Fabricate :user }

		before do
			sign_in user
			click_link 'Sign out'
		end

		it { should_not have_link 'Sign out', href: destroy_user_session_path }
		it { should have_link 'Sign in', href: new_user_session_path }
		it { should_not have_link 'Profile', href: user_path(user) }
		it { should have_selector 'div.alert', text: 'Signed out successfully' }

	end

	describe 'authorization' do

		describe 'for non-signed-in users' do

			let(:user) { Fabricate :user }

			describe 'when attempting to visit a protected page' do

				before { visit edit_user_path user }

				describe 'after signing in' do

					before { sign_in user }

					describe 'the user should be redirect to the desired page' do
						its(:current_path) { should == edit_user_path(user) }
					end

					describe 'when signing out and in again the user should be redirected to the default dashboard page' do
						before do
							click_link 'Sign out'
							sign_in user
						end
						its(:current_path) { should == dashboard_path(user.dashboards.default) }
					end

				end

			end

			describe 'protected actions redirect to the signin page' do

				describe 'Dashboard controller' do
					let(:dashboard) { Fabricate :dashboard }
					specify('new') { get new_dashboard_path; response.should redirect_to new_user_session_path }
					specify('create') { post dashboards_path; response.should redirect_to new_user_session_path }
					specify('show') { get dashboard_path(dashboard); response.should redirect_to new_user_session_path }
					specify('edit') { get edit_dashboard_path(dashboard); response.should redirect_to new_user_session_path }
					specify('update') { put dashboard_path(dashboard); response.should redirect_to new_user_session_path }
					specify('delete') { delete dashboard_path(dashboard); response.should redirect_to new_user_session_path }
					specify('default') { get default_dashboards_path; response.should redirect_to new_user_session_path }
				end

				describe 'Users controller' do
					specify('index') { get users_path; response.should redirect_to new_user_session_path }
					specify('new') { get new_user_path; response.should redirect_to new_user_session_path }
					specify('create') { post users_path; response.should redirect_to new_user_session_path }
					specify('show') { get user_path(user); response.should redirect_to new_user_session_path }
					specify('edit') { get edit_user_path(user); response.should redirect_to new_user_session_path }
					specify('update') { put user_path(user); response.should redirect_to new_user_session_path }
					specify('delete') { delete user_path(user); response.should redirect_to new_user_session_path }
				end

				describe 'Devices controller' do
					let(:device) { Fabricate :switch_device }
					specify('index') { get devices_path; response.should redirect_to new_user_session_path }
					specify('new') { get new_device_path(type: :switch_devices); response.should redirect_to new_user_session_path }
					specify('create') { post devices_path; response.should redirect_to new_user_session_path }
					specify('show') { get device_path(device); response.should redirect_to new_user_session_path }
					specify('edit') { get edit_device_path(device); response.should redirect_to new_user_session_path }
					specify('update') { put device_path(device); response.should redirect_to new_user_session_path }
					specify('delete') { delete device_path(device); response.should redirect_to new_user_session_path }
				end

				describe 'Device Scripts controller' do
					let(:device_script) { Fabricate :device_script }
					specify('index') { get device_scripts_path; response.should redirect_to new_user_session_path }
					specify('new') { get new_device_script_path; response.should redirect_to new_user_session_path }
					specify('create') { post device_scripts_path; response.should redirect_to new_user_session_path }
					specify('show') { get device_script_path(device_script); response.should redirect_to new_user_session_path }
					specify('edit') { get edit_device_script_path(device_script); response.should redirect_to new_user_session_path }
					specify('update') { put device_script_path(device_script); response.should redirect_to new_user_session_path }
					specify('delete') { delete device_script_path(device_script); response.should redirect_to new_user_session_path }
				end

				describe 'Buildings controller' do
					let(:building) { Fabricate :building }
					specify('index') { get buildings_path; response.should redirect_to new_user_session_path }
					specify('new') { get new_building_path; response.should redirect_to new_user_session_path }
					specify('create') { post buildings_path; response.should redirect_to new_user_session_path }
					specify('show') { get building_path(building); response.should redirect_to new_user_session_path }
					specify('edit') { get edit_building_path(building); response.should redirect_to new_user_session_path }
					specify('update') { put building_path(building); response.should redirect_to new_user_session_path }
					specify('delete') { delete building_path(building); response.should redirect_to new_user_session_path }
				end

				describe 'Floors controller' do
					let(:floor) { Fabricate :floor }
					specify('index') { get floors_path; response.should redirect_to new_user_session_path }
					specify('new') { get new_building_floor_path(floor.building); response.should redirect_to new_user_session_path }
					specify('create') { post building_floors_path(floor.building); response.should redirect_to new_user_session_path }
					specify('show') { get building_floor_path(floor.building, floor); response.should redirect_to new_user_session_path }
					specify('edit') { get edit_building_floor_path(floor.building, floor); response.should redirect_to new_user_session_path }
					specify('update') { put building_floor_path(floor.building, floor); response.should redirect_to new_user_session_path }
					specify('delete') { delete building_floor_path(floor.building, floor); response.should redirect_to new_user_session_path }
				end

				describe 'Rooms controller' do
					let(:room) { Fabricate :room }
					specify('index') { get rooms_path; response.should redirect_to new_user_session_path }
					specify('new') { get new_building_floor_room_path(room.floor.building, room.floor); response.should redirect_to new_user_session_path }
					specify('create') { post building_floor_rooms_path(room.floor.building, room.floor); response.should redirect_to new_user_session_path }
					specify('show') { get building_floor_room_path(room.floor.building, room.floor, room); response.should redirect_to new_user_session_path }
					specify('edit') { get edit_building_floor_room_path(room.floor.building, room.floor, room); response.should redirect_to new_user_session_path }
					specify('update') { put building_floor_room_path(room.floor.building, room.floor, room); response.should redirect_to new_user_session_path }
					specify('delete') { delete building_floor_room_path(room.floor.building, room.floor, room); response.should redirect_to new_user_session_path }
				end

			end

		end

		describe 'for the wrong user' do

			let(:user) { Fabricate :user }
			let (:wrong_user) { Fabricate :other_user }

			before { sign_in user }

			describe 'protected actions redirect to the signin page' do

				describe 'Users controller' do
					specify('edit') { get edit_user_path(wrong_user); response.should redirect_to new_user_session_path }
					specify('update') { put user_path(wrong_user); response.should redirect_to new_user_session_path }
				end

			end

		end

	end

end