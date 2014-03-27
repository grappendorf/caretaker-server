require 'breadcrumbs_on_rails'

class BootstrapBreadcrumbsBuilder < BreadcrumbsOnRails::Breadcrumbs::Builder

	def render
		@context.content_tag(:ul, :class => 'pretty-breadcrumb') do
			elements_count = @elements.size
			i = 0
			@elements.collect do |element|
				i += 1
				render_element(element, last = (i == elements_count))
			end.join.html_safe
		end
	end

	def render_element(element, last = false)
		current = @context.current_page?(compute_path(element))

		@context.content_tag(:li, :class => ('active' if last)) do
			#if last
			#	link_or_text = @context.link_to compute_name(element), '#', onclick: 'return false;'
			#else
				link_or_text = @context.link_to(compute_name(element), compute_path(element), element.options)
			#end
			unless @options[:separator].blank?
				divider = @context.content_tag(:span, (@options[:separator]).html_safe, :class => 'divider') unless current
			end

			link_or_text + (last ? '' : (divider || ''))
		end
	end

end
