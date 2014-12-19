require 'spec_helper'

describe 'Device scripts API', type: :request do

	subject { response }

	let(:user) { Fabricate :admin }

	before { sign_in user }
	after { sign_out }


	describe 'GET /device_scripts' do

		before do
			3.times { Fabricate :device_script }
			get device_scripts_path
		end

		it 'should return all device scripts' do
			json = JSON.parse response.body
			expect(json.length).to eq 3
			expect(json.map { |b| b['name'] }).to match_array DeviceScript.all.pluck(:name)
		end

		it 'should return the required device script properties' do
			json = JSON.parse response.body
			expect(json[0]).to have_key 'id'
			expect(json[0]).to have_key 'name'
			expect(json[0]).to have_key 'enabled'
			expect(json[0]).to have_key 'description'
		end

		it 'should return with status :ok' do
			expect(response).to have_http_status :ok
		end
	end


	describe 'GET /device_scripts/:id' do

		let!(:device_script) { Fabricate :device_script }

		before do
			get device_script_path device_script
		end

		it 'should return the device script' do
			json = JSON.parse response.body
			expect(json).to eq device_script.attributes
		end

		it 'should return with status :ok' do
			expect(response).to have_http_status :ok
		end
	end


	describe 'POST /device_scripts' do

		let(:device_script_name) { 'New Device script' }
		let(:device_script_script) { 'puts "Hello world!"' }
		let(:device_script_description) { 'Print hello world' }
		let(:device_script_params) { { name: device_script_name,
		                               script: device_script_script,
		                               description: device_script_description }.to_json }

		context 'with valid parameters' do

			it 'should create a new device script' do
				expect do
					post device_scripts_path, device_script_params
				end.to change { DeviceScript.count }.by 1
				expect(DeviceScript.first.name).to eq device_script_name
				expect(DeviceScript.first.script).to eq device_script_script
				expect(DeviceScript.first.description).to eq device_script_description
			end

			it 'should return with status :ok' do
				post device_scripts_path, device_script_params
				expect(response).to have_http_status :ok
			end
		end

		context 'with invalid parameters' do

			let(:device_script_name) { '' }

			it 'should not create a new device script' do
				expect do
					post device_scripts_path, device_script_params
				end.not_to change { DeviceScript.count }
			end

			it 'should return the erroneous attributes' do
				post device_scripts_path, device_script_params
				json = JSON.parse response.body
				expect(json['errors']).to have_key 'name'
			end

			it 'should return with status :bad_request' do
				post device_scripts_path, device_script_params
				expect(response).to have_http_status :bad_request
			end
		end
	end


	describe 'PUT /device_scripts/:id' do

		let(:device_script_name) { 'Updated device script' }
		let(:device_script_params) { { name: device_script_name }.to_json }

		before { Fabricate :device_script }

		context 'with valid parameters' do

			it 'should update the device script' do
				put device_script_path(DeviceScript.first), device_script_params
				expect(DeviceScript.first.name).to eq device_script_name
			end

			it 'should return with status :ok' do
				put device_script_path(DeviceScript.first), device_script_params
				expect(response).to have_http_status :ok
			end
		end

		context 'with invalid parameters' do

			let(:device_script_name) { '' }

			it 'should not modify the device script' do
				expect do
					put device_script_path(DeviceScript.first), device_script_params
				end.not_to change { DeviceScript.first.name }
			end

			it 'should return with status :bad_request' do
				put device_script_path(DeviceScript.first), device_script_params
				expect(response).to have_http_status :bad_request
			end
		end
	end


	describe 'DELETE /device_scripts/:id' do

		before { Fabricate :device_script }

		it 'should delete the device script' do
			expect do
				delete device_script_path DeviceScript.first
			end.to change { DeviceScript.count }.by -1
		end

		it 'should return with status :ok' do
			delete device_script_path DeviceScript.first
			expect(response).to have_http_status :ok
		end
	end


	describe 'PUT /device_scripts/:id/enable' do
		let!(:device_script) { Fabricate :device_script, enabled: false }

		it 'should enable the device script' do
			expect do
				put enable_device_script_path device_script
			end.to change { device_script.reload.enabled }.to true
		end
	end


	describe 'PUT /device_scripts/:id/disable' do
		let!(:device_script) { Fabricate :device_script, enabled: true }

		it 'should disable the device script' do
			expect do
				put disable_device_script_path device_script
			end.to change { device_script.reload.enabled }.to false
		end
	end

end
