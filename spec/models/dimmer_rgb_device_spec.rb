# == Schema Information
#
# Table name: dimmer_rgb_devices
#
#  id :integer          not null, primary key
#

require 'spec_helper'
require 'models/device_shared_examples'

describe DimmerRgbDevice do

	let(:dimmer_rgb_device) { FactoryGirl.create :dimmer_rgb_device }

	subject { dimmer_rgb_device }

	it_behaves_like 'a device'

end
