require 'spec_helper'

describe 'Settings pages' do

	subject { page }

	describe 'Settings page' do

		before { visit settings_path }

		it { should have_title 'Settings' }
		it { should have_field 'Serial port' }
		it { should have_field 'Baud rate' }

	end

end