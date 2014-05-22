class WidgetSerializer < ActiveModel::Serializer

	attributes :id, :type, :title, :x, :y, :width, :height

	def id
		object.as_widget.id
	end

	def type
		object.class.name
	end

end