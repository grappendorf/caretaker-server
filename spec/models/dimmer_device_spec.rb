# == Schema Information
#
# Table name: dimmer_devices
#
#  id :integer          not null, primary key
#

require 'spec_helper'
require 'models/device_shared_examples'

describe DimmerDevice do

	subject(:dimmer_device) { FactoryGirl.create :dimmer_device }

	it_behaves_like 'a device'

end
