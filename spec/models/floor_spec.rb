# == Schema Information
#
# Table name: floors
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  building_id :integer
#

require 'spec_helper'

describe Floor do
  subject(:floor) { Fabricate.build :floor }

  let(:other_floor) { Fabricate.build :floor }

  it { is_expected.to respond_to :name }
  it { is_expected.to respond_to :description }
  it { is_expected.to respond_to :rooms }
  it { is_expected.to be_valid }

  describe 'is invalid if it' do
    it 'has an empty name' do
      floor.name = ''
      is_expected.not_to be_valid
    end
  end
end
