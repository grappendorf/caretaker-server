class WeatherWidget < Widget

	before_validation :set_default_title

	def self.attr_accessible
		Widget.attr_accessible
	end

	private
	def set_default_title
		self.title = 'Weather' unless self.title.present?
	end

end