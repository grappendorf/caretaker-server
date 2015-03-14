# == Schema Information
#
# Table name: buildings
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#

Fabricator :building do
  name { sequence(:name) { |n| "Building-#{n}" } }
  description { sequence(:description) { |n| "This is building #{n}" } }
end
