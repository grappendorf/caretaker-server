require 'spec_helper'

describe ViewHelper do

	describe '#full_title' do

		let (:base_title) { /CoYoHo - Control Your Home/ }

		it 'should include the base title' do
			helper.full_title('foo').should =~ base_title
		end

		it 'should include the page title' do
			helper.full_title('foo').should =~ /foo/
		end

		it 'should include a bar to separate the base and page titles' do
			helper.full_title('foo').should =~ / \| /
		end

		it 'should not include a bar on the home page' do
			helper.full_title('').should_not =~ /\|/
		end

		it 'should include the base title if the page title is nil' do
			helper.full_title(nil).should =~ base_title
		end

		it 'should include the base title if the page title is empty' do
			helper.full_title('').should =~ base_title
		end

	end

	describe '#awesome_link_to' do

		it 'should create an awesome link' do
			helper.awesome_link_to('text', 'icon', 'to').should ==
					'<a href="to"><i class="fa fa-icon"></i><span> text</span></a>'
		end

	end

	describe '#link_to_or_placeholder_if' do

		it 'should create a link if the condition is true' do
			helper.link_to_or_placeholder_if(true, 'name', 'url', {}).should == '<a href="url">name</a>'
		end

		it 'should create a placeholder if the condition is false' do
			helper.link_to_or_placeholder_if(false, 'name', 'url', {}).should == '<span class="disabled">name</span>'
		end

	end

	describe '#link_to_or_placeholder_unless' do

		it 'should be the opposite of link_to_or_placeholder_if' do
			expect(helper).to receive(:link_to_or_placeholder_if).with(false, 'name', 'url', {})
			helper.link_to_or_placeholder_unless(true, 'name', 'url', {})
		end

	end

end
