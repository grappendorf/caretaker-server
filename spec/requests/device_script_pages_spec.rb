require 'spec_helper'

describe 'Device script pages' do

	subject { page }

	let(:device_script) { Fabricate :device_script }
	let(:user) { Fabricate :admin }

	before { sign_in user }

	describe 'authenticated users have a link to the device script list' do
		before { visit root_path }
		it { should have_link 'Device Scripts', href: device_scripts_path }
	end

	describe 'Index' do

		describe 'page' do

			before do
				3.times { Fabricate :device_script }
				visit device_scripts_path
			end

			it { should have_title 'Device Scripts' }
			it { should have_link 'New', href: new_device_script_path }
			it 'should display all devices scripts' do
				DeviceScript.all.each { |device_script| should have_selector 'td', text: device_script.name }
			end
			it 'should have action links for each device script' do
				DeviceScript.all.each do |device_script|
					should have_link 'Edit', href: edit_device_script_path(device_script)
					should have_link 'Delete', href: device_script_path(device_script)
				end
			end

		end

		describe 'enabling a device script' do

			before do
				@device_script = Fabricate :device_script, enabled: false
				visit device_scripts_path
			end

			it 'should enable the device script' do
				expect do
					click_link 'Off'
					@device_script.reload
				end.to change(@device_script, :enabled?).to(true)
			end

		end

		describe 'disabling a device script' do

			before do
				@device_script = Fabricate :device_script, enabled: true
				visit device_scripts_path
			end

			it 'should disable the device script' do
				expect do
					click_link 'On'
					@device_script.reload
				end.to change(@device_script, :enabled?).to(false)
			end

		end


	end

	describe 'New' do

		before { visit new_device_script_path }

		describe 'page' do
			it { should have_title 'New Device Script' }
			it { should have_field 'Name' }
			it { should have_field 'Description' }
			it { should have_field 'Script' }
			it { should have_field 'Enabled' }
			it { should have_button 'Save' }
			it { should have_link 'Cancel' }
		end

		describe 'submit with valid data' do

			it 'should create a new device script' do
				expect do
					fill_in 'Name', with: 'TheNewScript'
					click_button 'Save'
				end.to change(DeviceScript, :count).by 1
			end

			it 'should redirect to the device scripts list and show a flash success' do
				fill_in 'Name', with: 'TheNewScript'
				click_button 'Save'
				current_path.should == device_scripts_path
				should have_selector '.alert-success'
			end

		end

		describe 'submit with invalid data' do

			it 'should not create a new device script' do
				expect do
					click_button 'Save'
				end.not_to change(DeviceScript, :count)
			end

			it 'should stay on the edit page and show a flash error' do
				click_button 'Save'
				current_path.should == device_scripts_path
				should have_selector '.alert-error'
			end

		end

	end

	describe 'Edit' do

		before { visit edit_device_script_path device_script }

		describe 'page' do
			it { should have_title "Device Script #{device_script.name}" }
			it { should have_selector 'legend', text: 'Device Script' }
			it { should have_field 'Name', with: device_script.name }
			it { should have_field 'Description', with: device_script.description }
			it { should have_field 'Script', with: device_script.script }
			it { should have_field 'Enabled', checked: device_script.enabled }
			it { should have_button 'Save' }
			it { should have_link 'Cancel' }
		end

		describe 'with valid information' do

			let(:new_name) { 'NewDeviceScriptName' }
			let(:new_description) { 'New Description' }
			let(:new_enabled) { !device_script.enabled }
			let(:new_script) { 'puts "New Script Code"' }

			before do
				fill_in 'Name', with: new_name
				fill_in 'Description', with: new_description
				check_or_uncheck 'Enabled', new_enabled
				fill_in 'Script', with: new_script
				click_button 'Save'
			end

			it { should have_selector '.alert-success' }
			it { should have_selector 'td', new_name }
			it { should have_selector 'td', new_description }
			specify { device_script.reload.name.should == new_name }
			specify { device_script.reload.description.should == new_description }
			specify { device_script.reload.enabled.should == new_enabled }
			specify { device_script.reload.script.should == new_script }

		end

	end

	describe 'Delete' do

		before do
			@device_script = Fabricate :device_script
		end

		it 'should delete the device script' do
			expect do
				visit device_scripts_path
				click_link 'Delete', href: device_script_path(@device_script)
			end.to change(DeviceScript, :count).by -1
		end

		it 'should redirect to the device script list and show a flash success' do
			visit device_scripts_path
			click_link 'Delete', href: device_script_path(@device_script)
			current_path.should == device_scripts_path
			should have_selector '.alert-success'
		end

	end

end
