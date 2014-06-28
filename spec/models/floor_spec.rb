# == Schema Information
#
# Table name: floors
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  building_id :integer
#

require 'spec_helper'

describe Floor do

	subject(:floor) { Fabricate.build :floor }

	let(:other_floor) { Fabricate.build :floor }

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
