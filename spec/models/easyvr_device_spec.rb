# == Schema Information
#
# Table name: easyvr_devices
#
#  id              :integer          not null, primary key
#  num_buttons     :integer
#  buttons_per_row :integer
#

require 'spec_helper'
require 'models/device_shared_examples'

describe EasyvrDevice do
  subject(:easyvr_device) { Fabricate :easyvr_device }

  it_behaves_like 'a device'

  it { is_expected.to respond_to :num_buttons }
  it { is_expected.to respond_to :buttons_per_row }

  describe 'is invalid if' do
    it 'has a number of buttons <= 0' do
      subject.num_buttons = 0
      is_expected.not_to be_valid
    end

    it 'has <= 0 buttons per row' do
      subject.buttons_per_row = 0
      is_expected.not_to be_valid
    end
  end
end
