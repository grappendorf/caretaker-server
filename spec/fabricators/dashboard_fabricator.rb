# == Schema Information
#
# Table name: dashboards
#
#  id      :integer          not null, primary key
#  name    :string
#  default :boolean
#  user_id :integer
#

Fabricator :dashboard do
  name { sequence(:name) { |n| "Dashboard #{n}" } }
  user { User.first || Fabricate(:user) }
  default false
end
