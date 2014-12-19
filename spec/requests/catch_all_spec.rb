require 'spec_helper'

describe 'Catch all' do

	subject { page }

	describe 'visiting a non existing page' do

		before { visit '/invalid' }

		it { should have_content 'Sorry, the requested page doesn\'t exist' }
	end
end
