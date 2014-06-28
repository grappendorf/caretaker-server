Fabricator :building do
	name { sequence(:name) { |n| "Building-#{n}" } }
	description { sequence(:description) { |n| "This is building #{n}" } }
end
