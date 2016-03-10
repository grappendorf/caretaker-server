# == Schema Information
#
# Table name: device_scripts
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  script      :text
#  enabled     :boolean
#

require 'spec_helper'

describe DeviceScript do
  subject(:device_script) { Fabricate :device_script }

  let(:other_device_script) { Fabricate :device_script }

  it { is_expected.to respond_to :name }
  it { is_expected.to respond_to :description }
  it { is_expected.to respond_to :script }
  it { is_expected.to respond_to :enabled }

  describe 'is invalid' do
    describe 'if it has an empty name' do
      before { device_script.name = ' ' }
      it { is_expected.not_to be_valid }
    end

    describe 'if it has an already taken name' do
      before { device_script.name = other_device_script.name }
      it { is_expected.not_to be_valid }
    end
  end
end
