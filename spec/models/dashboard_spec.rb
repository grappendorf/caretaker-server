require 'spec_helper'

describe Dashboard do

	let(:dashboard) { FactoryGirl.build :dashboard }

	subject { dashboard }

	it { should respond_to :name }
	it { should respond_to :default }
	it { should respond_to :user }
	it { should respond_to :widgets }

	describe 'is invalid if' do

		it 'has an empty name' do
			subject.name = ''
			should_not be_valid
		end

	end

end