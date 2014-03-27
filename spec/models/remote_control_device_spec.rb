require 'spec_helper'
require 'models/device_shared_examples'

describe RemoteControlDevice do

	let(:remote_control_device) { FactoryGirl.create :remote_control_device }

	subject { remote_control_device }

	it_behaves_like 'a device'

	it { should respond_to :num_buttons }
	it { should respond_to :buttons_per_row }

	describe 'is invalid if' do

		it 'has a number of buttons <= 0' do
			subject.num_buttons = 0
			should_not be_valid
		end

		it 'has <= 0 buttons per row' do
			subject.buttons_per_row = 0
			should_not be_valid
		end

	end

end
