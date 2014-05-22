class DashboardSerializer < ActiveModel::Serializer

	attributes :id, :name, :default
	has_many :widgets

	def widgets
		object.widgets.map &:specific
	end

end
