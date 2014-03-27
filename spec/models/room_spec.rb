require 'spec_helper'

describe Room do

	let(:room) { FactoryGirl.build :room }
	let(:other_room) { FactoryGirl.build :room }

	subject { room }

	it { should respond_to :number }
	it { should respond_to :description }
	it { should respond_to :devices }
	it { should be_valid }

	describe 'is invalid if it' do

		it 'has an empty number' do
			room.number = ''
			should_not be_valid
		end

	end

end
