require 'spec_helper'

shared_examples_for 'a device' do
  it { is_expected.to respond_to :uuid }
  it { is_expected.to respond_to :name }
  it { is_expected.to respond_to :address }
  it { is_expected.to respond_to :description }

  describe 'is invalid if' do
    it 'has an empty uuid' do
      subject.uuid = ''
      is_expected.not_to be_valid
    end

    it 'has an empty name' do
      subject.name = ''
      is_expected.not_to be_valid
    end

    it 'has an empty address' do
      subject.address = ''
      is_expected.not_to be_valid
    end

    it 'has a name that is already used' do
      other = Fabricate :device
      subject.name = other.name
      is_expected.not_to be_valid
    end
  end
end
