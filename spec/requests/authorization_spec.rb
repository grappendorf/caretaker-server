require 'spec_helper'

describe 'Authorization', type: :request do

	describe 'for non-signed-in users' do

		let(:user) { Fabricate :user }

		describe 'protected actions should return :unauthorized' do

			describe 'Dashboard controller' do
				let(:dashboard) { Fabricate :dashboard }
				specify('create') { post dashboards_path; expect(response).to have_http_status(:unauthorized) }
				specify('show') { get dashboard_path(dashboard); expect(response).to have_http_status(:unauthorized) }
				specify('update') { put dashboard_path(dashboard); expect(response).to have_http_status(:unauthorized) }
				specify('delete') { delete dashboard_path(dashboard); expect(response).to have_http_status(:unauthorized) }
				specify('default') { get default_dashboards_path; expect(response).to have_http_status(:found) }
			end

			describe 'Users controller' do
				specify('index') { get users_path; expect(response).to have_http_status(:unauthorized) }
				specify('create') { post users_path; expect(response).to have_http_status(:unauthorized) }
				specify('show') { get user_path(user); expect(response).to have_http_status(:unauthorized) }
				specify('update') { put user_path(user); expect(response).to have_http_status(:unauthorized) }
				specify('delete') { delete user_path(user); expect(response).to have_http_status(:unauthorized) }
			end

			describe 'Devices controller' do
				let(:device) { Fabricate :switch_device }
				specify('index') { get devices_path; expect(response).to have_http_status(:unauthorized) }
				specify('create') { post devices_path; expect(response).to have_http_status(:unauthorized) }
				specify('show') { get device_path(device); expect(response).to have_http_status(:unauthorized) }
				specify('update') { put device_path(device); expect(response).to have_http_status(:unauthorized) }
				specify('delete') { delete device_path(device); expect(response).to have_http_status(:unauthorized) }
			end

			describe 'Device Scripts controller' do
				let(:device_script) { Fabricate :device_script }
				specify('index') { get device_scripts_path; expect(response).to have_http_status(:unauthorized) }
				specify('create') { post device_scripts_path; expect(response).to have_http_status(:unauthorized) }
				specify('show') { get device_script_path(device_script); expect(response).to have_http_status(:unauthorized) }
				specify('update') { put device_script_path(device_script); expect(response).to have_http_status(:unauthorized) }
				specify('delete') { delete device_script_path(device_script); expect(response).to have_http_status(:unauthorized) }
			end

			describe 'Buildings controller' do
				let(:building) { Fabricate :building }
				specify('index') { get buildings_path; expect(response).to have_http_status(:unauthorized) }
				specify('create') { post buildings_path; expect(response).to have_http_status(:unauthorized) }
				specify('show') { get building_path(building); expect(response).to have_http_status(:unauthorized) }
				specify('update') { put building_path(building); expect(response).to have_http_status(:unauthorized) }
				specify('delete') { delete building_path(building); expect(response).to have_http_status(:unauthorized) }
			end

			describe 'Floors controller' do
				let(:floor) { Fabricate :floor }
				specify('index') { get floors_path; expect(response).to have_http_status(:unauthorized) }
				specify('index') { get building_floors_path(floor.building); expect(response).to have_http_status(:unauthorized) }
				specify('create') { post building_floors_path(floor.building); expect(response).to have_http_status(:unauthorized) }
				specify('show') { get building_floor_path(floor.building, floor); expect(response).to have_http_status(:unauthorized) }
				specify('update') { put building_floor_path(floor.building, floor); expect(response).to have_http_status(:unauthorized) }
				specify('delete') { delete building_floor_path(floor.building, floor); expect(response).to have_http_status(:unauthorized) }
			end

			describe 'Rooms controller' do
				let(:room) { Fabricate :room }
				specify('index') { get rooms_path; expect(response).to have_http_status(:unauthorized) }
				specify('index') { get building_floor_rooms_path(room.floor, room.floor.building); expect(response).to have_http_status(:unauthorized) }
				specify('create') { post building_floor_rooms_path(room.floor.building, room.floor); expect(response).to have_http_status(:unauthorized) }
				specify('show') { get building_floor_room_path(room.floor.building, room.floor, room); expect(response).to have_http_status(:unauthorized) }
				specify('update') { put building_floor_room_path(room.floor.building, room.floor, room); expect(response).to have_http_status(:unauthorized) }
				specify('delete') { delete building_floor_room_path(room.floor.building, room.floor, room); expect(response).to have_http_status(:unauthorized) }
			end
		end
	end
end