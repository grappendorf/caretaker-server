require 'spec_helper'

describe 'Device pages' do

	include ViewHelper

	inject :device_manager
	inject :scheduler

	before do
		device_manager.add_device @switch_device = Fabricate(:switch_device)
		device_manager.add_device Fabricate :dimmer_device
		device_manager.add_device Fabricate :remote_control_device
	end

	after do
		device_manager.remove_all_devices
	end

	let(:user) { Fabricate :admin }

	subject { page }

	before { sign_in user }

	describe 'Authenticated users have a link to the device list' do
		before { visit root_path }
		it { should have_link 'Devices', href: devices_path }
	end

	describe 'Index' do

		describe 'page' do

			before { visit devices_path }

			it { should have_selector 'th', text: 'Name' }
			it { should have_selector 'th', text: 'Type' }
			it { should have_selector 'th', text: 'Address' }
			it { should have_selector 'th i.fa-bolt' }
			it { should have_selector 'th', text: 'Description' }

			it 'should display all devices' do
				Device.all.each { |device| should have_selector 'td', text: device.name }
			end

			it 'should have action links for each device' do
				Device.all.each do |device|
					should have_link 'Edit', href: edit_device_path(device)
					should have_link 'Delete', href: device_path(device)
				end
			end

			it 'should have links to create all types of devices' do
				Device.models.each do |device_model|
					# TODO: This check is only there to prevent the device_pages_scpec from failing %>
					# The spec temporarily creates a device subclass which is not registered as a valid %>
					# route, resulting in an excpetion in the new_device_path function %>
					if recognize_path? { new_device_path(type: device_model.model_name.plural) }
						should have_link '', href: new_device_path(type: device_model.model_name.plural)
					end
				end
			end

		end

	end

	describe 'New' do

		before { visit new_device_path(type: :switch_devices) }

		describe 'cannot create an abstract device' do
			specify do
				expect { visit new_device_path }.to raise_error
			end
		end

		describe 'page' do
			it { should have_selector 'legend', text: 'Switch' }
			it { should have_field 'Name' }
			it { should have_field 'Address' }
			it { should have_field 'Description' }
			it { should have_field 'Number of switches' }
			it { should have_field 'Switches per row' }
		end

		describe 'submit with valid data' do

			it 'should create a new device' do
				expect do
					fill_in 'Name', with: 'TheNewDevice'
					fill_in 'Address', with: '01:23:45:67:89'
					fill_in 'Number of switches', with: '10'
					fill_in 'Switches per row', with: '5'
					click_button 'Save'
				end.to change(Device, :count).by 1
			end

			it 'should redirect to the device list and show a flash success' do
				fill_in 'Name', with: 'TheNewDevice'
				fill_in 'Address', with: '01:23:45:67:89'
				fill_in 'Number of switches', with: '10'
				fill_in 'Switches per row', with: '5'
				click_button 'Save'
				current_path.should == devices_path
				should have_selector '.alert-success'
			end

		end

		describe 'submit with invalid data' do

			it 'should not create a new device' do
				expect do
					click_button 'Save'
				end.not_to change(Device, :count)
			end

			it 'should stay on the edit page and show a flash error' do
				click_button 'Save'
				current_path.should == devices_path
				should have_selector '.alert-error'
			end

		end

		it 'should only be possible to create a form for device subclasses' do
			expect { visit new_device_path(type: 'xxx') }.to raise_error ActionController::UrlGenerationError
		end

	end

	describe 'Edit' do

		before { visit edit_device_path @switch_device }

		describe 'page' do
			it { should have_selector 'legend', text: "Device #{@switch_device.name}" }
			it { should have_field 'Name', with: @switch_device.name }
			it { should have_field 'Address', with: @switch_device.address }
			it { should have_field 'Description', with: @switch_device.description }
			it { should_not have_field 'Id' }
			it { should_not have_field 'Udated At' }
			it { should_not have_field 'Created At' }
			it { should have_field 'Number of switches', with: @switch_device.num_switches.to_s }
			it { should have_field 'Switches per row', with: @switch_device.switches_per_row.to_s }
		end

	end

	describe 'Delete' do

		it 'should delete the device' do
			expect do
				visit devices_path
				click_link 'Delete', href: device_path(@switch_device)
			end.to change(Device, :count).by -1
		end

		it 'should redirect to the device list and show a flash success' do
			visit devices_path
			click_link 'Delete', href: device_path(@switch_device)
			current_path.should == devices_path
			should have_selector '.alert-success'
		end

	end

end
