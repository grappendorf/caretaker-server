require 'spec_helper'

shared_examples_for 'a device' do

  it { should respond_to :uuid }
  it { should respond_to :name }
  it { should respond_to :address }
  it { should respond_to :description }

  describe 'is invalid if' do

    it 'has an empty uuid' do
      subject.uuid = ''
      should_not be_valid
    end

    it 'has an empty name' do
      subject.name = ''
      should_not be_valid
    end

    it 'has an empty address' do
      subject.address = ''
      should_not be_valid
    end

    it 'has a name that is already used' do
      other = Fabricate :device
      subject.name = other.name
      should_not be_valid
    end
  end

end
