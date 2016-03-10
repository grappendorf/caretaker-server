# == Schema Information
#
# Table name: rooms
#
#  id          :integer          not null, primary key
#  number      :string
#  description :string
#  floor_id    :integer
#

require 'spec_helper'

describe Room do
  subject(:room) { Fabricate.build :room }

  let(:other_room) { Fabricate.build :room }

  it { is_expected.to respond_to :number }
  it { is_expected.to respond_to :description }
  it { is_expected.to respond_to :devices }
  it { is_expected.to be_valid }

  describe 'is invalid if it' do
    it 'has an empty number' do
      room.number = ''
      is_expected.not_to be_valid
    end
  end
end
