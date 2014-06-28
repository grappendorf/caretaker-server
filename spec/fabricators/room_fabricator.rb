Fabricator :room do
	number { sequence(:number) { |n| "Room-#{n}" } }
	description { sequence(:description) { |n| "This is room #{n}" } }
	floor { Floor.first || Fabricate(:floor) }
end
