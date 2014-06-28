Fabricator :device_script do
	name { sequence(:name) { |n| "Script-#{n}" } }
	description { sequence(:description) { |n| Faker::Lorem.sentence } }
	script '10.times { puts "Hello!" }'
	enabled true
end
