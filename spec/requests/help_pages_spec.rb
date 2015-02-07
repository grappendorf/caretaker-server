require 'spec_helper'

describe 'Help pages' do

	subject { page }

	describe 'About page' do

		before { visit help_about_path }

		it { should have_title 'About' }

		it 'should display the application name' do
			should have_content 'Caretaker'
		end

		it 'should display the application version' do
			should have_content 'Version'
		end

		it 'should display the copyright information' do
			should have_content 'Copyright'
		end

		it 'should display a link to the authors web page' do
			should have_link 'www.grappendorf.net', href: 'http://www.grappendorf.net'
		end

	end

end
