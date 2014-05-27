# == Schema Information
#
# Table name: device_scripts
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  script      :text
#  enabled     :boolean
#

require 'spec_helper'

describe DeviceScript do

	subject(:device_script) { FactoryGirl.create :device_script }

	let(:other_device_script) { FactoryGirl.create :device_script }

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
