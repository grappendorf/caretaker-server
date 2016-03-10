# == Schema Information
#
# Table name: cipcam_devices
#
#  id               :integer          not null, primary key
#  user             :string
#  password         :string
#  refresh_interval :string
#

require 'spec_helper'
require 'models/device_shared_examples'

describe CipcamDevice do
  subject(:cipcam_device) { Fabricate :cipcam_device }

  it_behaves_like 'a device'

  it { is_expected.to respond_to :user }
  it { is_expected.to respond_to :password }
  it { is_expected.to respond_to :refresh_interval }

  describe 'is invalid if' do
    it 'has an invalid refresh interval' do
      subject.refresh_interval = 0
      is_expected.not_to be_valid
    end
  end
end
