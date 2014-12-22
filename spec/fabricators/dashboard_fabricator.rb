# == Schema Information
#
# Table name: dashboards
#
#  id      :integer          not null, primary key
#  name    :string(255)
#  default :boolean
#  user_id :integer
#

Fabricator :dashboard do
	name { sequence(:name) { |n| "Dashboard #{n}" } }
	user { User.first || Fabricate(:user) }
	default false
end

Fabricator :widget do
end

Fabricator :device_widget do
	position 0
	width 1
	height 1
end
