require 'spec_helper'

describe DeviceScript do

	let(:device_script) { FactoryGirl.create :device_script }
	let(:other_device_script) { FactoryGirl.create :device_script }

	subject { device_script }

	it { should respond_to :name }
	it { should respond_to :description }
	it { should respond_to :script }
	it { should respond_to :enabled }

	describe 'is invalid' do

		describe 'if it has an empty name' do
			before { device_script.name = ' ' }
			it { should_not be_valid }
		end

		describe 'if it has an already taken name' do
			before { device_script.name = other_device_script.name }
			it { should_not be_valid }
		end

	end

end
