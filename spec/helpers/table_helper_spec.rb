require 'spec_helper'

describe TableHelper do

	describe '#paginated' do

		it 'should call paginate with a twitter-bootstrap-3 theme' do
			expect(helper).to receive(:paginate).with(anything, theme: 'twitter-bootstrap-3')
			helper.paginated 'a model'
		end

	end

	describe '#sortable' do

		it 'should create a column title with a change-sort-link' do
			allow(helper).to receive(:sort_column).and_return('')
			expect(helper).to receive(:url_for).with(sort: 'a_column', order: 'asc').and_return('url')
			helper.sortable(:a_column).should ==
					'<a href="url"><span>A Column</span><span></span></a>'
		end

		it 'should pass all params to change-sort-link' do
			allow(helper).to receive(:sort_column).and_return('')
			allow(helper).to receive(:params).and_return(q: 'search')
			expect(helper).to receive(:url_for).with(hash_including(q: 'search'))
			helper.sortable(:a_column)
		end

		it 'should create a column title with an up arrow if the table is sorted ascending by the current column ' do
			allow(helper).to receive(:sort_column).and_return('a_column')
			allow(helper).to receive(:sort_order).and_return('asc')
			allow(helper).to receive(:url_for).and_return('url')
			helper.sortable(:a_column).should ==
					'<a href="url"><span>A Column</span><span></span><i class="fa fa-caret-up"></i></a>'
		end

		it 'should create a column title with an up arrow if the table is sorted descending by the current column ' do
			allow(helper).to receive(:sort_column).and_return('a_column')
			allow(helper).to receive(:sort_order).and_return('desc')
			allow(helper).to receive(:url_for).and_return('url')
			helper.sortable(:a_column).should ==
					'<a href="url"><span>A Column</span><span></span><i class="fa fa-caret-down"></i></a>'
		end

		it 'should create a column with a specific title' do
			allow(helper).to receive(:sort_column).and_return('')
			allow(helper).to receive(:url_for).and_return('url')
			helper.sortable(:a_column, 'Special Title').should ==
					'<a href="url"><span>Special Title</span><span></span></a>'
		end

	end

end
