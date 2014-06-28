Fabricator :dashboard do
	name { sequence(:name) { |n| "Dashboard #{n}" } }
	user { User.first || Fabricate(:user) }
	default false
end

Fabricator :widget do
end

Fabricator :device_widget do
	x 1
	y 1
	width 1
	height 1
end
