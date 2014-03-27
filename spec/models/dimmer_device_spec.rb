require 'spec_helper'
require 'models/device_shared_examples'

describe DimmerDevice do

	let(:dimmer_device) { FactoryGirl.create :dimmer_device }

	subject { dimmer_device }

	it_behaves_like 'a device'

end
