# == Schema Information
#
# Table name: buildings
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#

require 'spec_helper'

describe Building do
  subject(:building) { Fabricate.build :building }

  let(:other_building) { Fabricate.build :building }

  it { is_expected.to respond_to :name }
  it { is_expected.to respond_to :description }
  it { is_expected.to respond_to :floors }
  it { is_expected.to be_valid }

  describe 'is invalid if it' do
    it 'has an empty name' do
      building.name = ''
      is_expected.not_to be_valid
    end

    it 'has the same name as another building' do
      other_building.save
      building.name = other_building.name
      is_expected.not_to be_valid
    end
  end
end
