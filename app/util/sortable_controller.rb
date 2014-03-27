module SortableController

  def self.included base
    base.helper_method :sort_column, :sort_order
  end

  private
	def sort_column
		allowed_columns = self.class.name.sub('Controller', '').singularize.constantize.attribute_names
		allowed_columns.include?(params[:sort]) ? params[:sort] : 'name'
	end

	private
	def sort_order
		%w{asc desc}.include?(params[:order]) ? params[:order] : 'desc'
	end

	private
	def sort_order_as_int
		{'asc' => 1, 'desc' => -1}[sort_order]
	end

end
