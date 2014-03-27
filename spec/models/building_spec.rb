require 'spec_helper'

describe Building do

	let(:building) { FactoryGirl.build :building }
	let(:other_building) { FactoryGirl.build :building }

	subject { building }

	it { should respond_to :name }
	it { should respond_to :description }
	it { should respond_to :floors }
	it { should be_valid }

	describe 'is invalid if it' do

		it 'has an empty name' do
			building.name = ''
			should_not be_valid
		end

		it 'has the same name as another building' do
			other_building.save
			building.name = other_building.name
			should_not be_valid
		end

	end

end
