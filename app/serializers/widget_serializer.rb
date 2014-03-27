class WidgetSerializer < ActiveModel::Serializer

	attributes :id, :type, :title, :x, :y, :width, :height

	def type
		object.class.name
	end

end