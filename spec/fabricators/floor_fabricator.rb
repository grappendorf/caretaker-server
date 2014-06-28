Fabricator :floor do
	name { sequence(:name) { |n| "Floor-#{n}" } }
	description { sequence(:description) { |n| "This is floor #{n}" } }
	building { Building.first || Fabricate(:building) }
end
