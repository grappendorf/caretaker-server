require 'spec_helper'

describe Floor do

	let(:floor) { FactoryGirl.build :floor }
	let(:other_floor) { FactoryGirl.build :floor }

	subject { floor }

	it { should respond_to :name }
	it { should respond_to :description }
	it { should respond_to :rooms }
	it { should be_valid }

	describe 'is invalid if it' do

		it 'has an empty name' do
			floor.name = ''
			should_not be_valid
		end

	end

end
