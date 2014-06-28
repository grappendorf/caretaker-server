# == Schema Information
#
# Table name: switch_devices
#
#  id               :integer          not null, primary key
#  num_switches     :integer
#  switches_per_row :integer
#

require 'spec_helper'
require 'models/device_shared_examples'

describe SwitchDevice do

	subject(:switch_device) { Fabricate :switch_device }

	it_behaves_like 'a device'

	it { should respond_to :num_switches }
	it { should respond_to :switches_per_row }

	describe 'is invalid if' do

		it 'has a number of switches <= 0' do
			subject.num_switches = 0
			should_not be_valid
		end

		it 'has <= 0 switches per row' do
			subject.switches_per_row = 0
			should_not be_valid
		end

	end

end
