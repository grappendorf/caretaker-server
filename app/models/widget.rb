class Widget

	include Mongoid::Document

	belongs_to :dashboard

	field :x, type: Integer, default: 1
	field :y, type: Integer, default: 1
	field :width, type: Integer, default: 1
	field :height, type: Integer, default: 1
	field :title, type: String

	def self.attr_accessible
		[:dashboard_id, :x, :y, :width, :height, :title]
	end

	def self.models
		Widget.subclasses
	end

	def self.models_paths
		self.models.map{|m| m.model_name.plural}
	end
end
