module TableHelper

	def paginated model
		paginate model, theme: 'twitter-bootstrap-3'
	end

	def sortable column, title = nil
		column = column.to_s
		title ||= column.titleize
		is_sort_column = column == sort_column
		order = is_sort_column && sort_order == 'asc' ? 'desc' : 'asc'
		link_params = {sort: column, order: order}
		link_params[:search] = params[:search] unless params[:search].nil?
		content_tag(:a, href: url_for(params.merge link_params)) do
			concat content_tag :span, title
			concat content_tag :span, ''
			concat content_tag(:i, nil, class: order == 'asc' ? 'fa fa-caret-down' : 'fa fa-caret-up') if is_sort_column
		end
	end

end