require 'spec_helper'

describe Widget do

	let(:widget) { FactoryGirl.build :widget }

	subject { widget }

	it { should respond_to :dashboard }
	it { should respond_to :title }

end
