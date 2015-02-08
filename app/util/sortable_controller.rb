module SortableController

  def self.included base
    base.helper_method :sort_column, :sort_order
  end

  private
  def sort_column
    allowed_columns = self.class.name.sub('Controller', '').singularize.constantize.attribute_names
    allowed_columns.include?(params[:sort]) ? params[:sort] : default_sort_column
  end

  private
  def sort_order
    %w{asc desc}.include?(params[:order]) ? params[:order] : 'asc'
  end

end
