# == Schema Information
#
# Table name: floors
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  building_id :integer
#

Fabricator :floor do
	name { sequence(:name) { |n| "Floor-#{n}" } }
	description { sequence(:description) { |n| "This is floor #{n}" } }
	building { Building.first || Fabricate(:building) }
end
