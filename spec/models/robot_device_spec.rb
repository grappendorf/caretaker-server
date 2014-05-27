# == Schema Information
#
# Table name: robot_devices
#
#  id :integer          not null, primary key
#

require 'spec_helper'
require 'models/device_shared_examples'

describe RobotDevice do

	subject(:robot_device) { FactoryGirl.create :robot_device }

	it_behaves_like 'a device'

end
