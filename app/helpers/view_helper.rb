module ViewHelper

	def full_title page_title = nil
		base_title = 'CoYoHo - Control Your Home'
		unless page_title.blank?
			base_title + ' | ' + page_title
		else
			base_title
		end
	end

	def awesome_link_to text, icon, to, options = {}
		link_to to, options do
			concat content_tag(:i, '', class: "fa fa-#{icon}")
			concat content_tag(:span, ' ' + text)
		end
	end

	def link_to_or_placeholder_if condition, name, url, html_options
		if condition
			link_to name, url, html_options
		else
			content_tag 'span', name, class: Array(html_options[:class]) + ['disabled']
		end
	end

	def link_to_or_placeholder_unless condition, *args
		link_to_or_placeholder_if !condition, *args
	end

	def recognize_path?
		begin
			yield
			true
		rescue
			false
		end
	end

	def parent_layout layout = 'application'
		@view_flow.set :layout, output_buffer
		output = render :file => "layouts/#{layout}"
		self.output_buffer = ActionView::OutputBuffer.new output
	end

end
