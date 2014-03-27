class DashboardSerializer < ActiveModel::Serializer

	attributes :id, :name, :default
	has_many :widgets

end