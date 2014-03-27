require 'spec_helper'
require 'models/device_shared_examples'

describe RobotDevice do

	let(:robot_device) { FactoryGirl.create :robot_device }

	subject { robot_device }

	it_behaves_like 'a device'

end
