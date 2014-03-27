FactoryGirl.define do

	factory :admin, class: User do
		name 'admin'
		email 'admin@example.com'
		password 'password'
		password_confirmation 'password'
		after(:create) do |admin|
			admin.add_role :admin
			admin.add_role :manager
			admin.add_role :user
			FactoryGirl.create(:dashboard, user: admin, default: true)
		end
	end

	factory :manager, class: User do
		name 'manager'
		email 'manager@example.com'
		password 'password'
		password_confirmation 'password'
		after(:create) do |manager|
			manager.add_role :manager
			manager.add_role :user
			FactoryGirl.create(:dashboard, user: manager, default: true)
		end
	end

	factory :user, class: User do
		name 'user'
		email 'user@example.com'
		password 'password'
		password_confirmation 'password'
		after(:create) do |user|
			user.add_role :user
			FactoryGirl.create(:dashboard, user: user, default: true)
		end
	end

	factory :other_user, class: User do
		name 'roe'
		email 'jane.roe@example.com'
		password 'password'
		password_confirmation 'password'
		after(:create) do |user|
			user.add_role :user
			FactoryGirl.create(:dashboard, user: user, default: true)
		end
	end

	factory :alice, class: User do
		name 'alice'
		email 'alice@example.com'
		password 'password'
		password_confirmation 'password'
		after(:create) do |user|
			user.add_role :user
			FactoryGirl.create(:dashboard, user: user, default: true)
		end
	end

	factory :bob, class: User do
		name 'bob'
		email 'bob@example.com'
		password 'password'
		password_confirmation 'password'
		after(:create) do |user|
			user.add_role :user
			FactoryGirl.create(:dashboard, user: user, default: true)
		end
	end

	factory :carol, class: User do
		name 'carol'
		email 'carol@example.com'
		password 'password'
		password_confirmation 'password'
		after(:create) do |user|
			user.add_role :user
			FactoryGirl.create(:dashboard, user: user, default: true)
		end
	end

	factory :device do
		name 'Device'
		address '00:11:22:33:44:55'
		description 'A generic device'
	end

	factory :switch_device do
		name 'Switch'
		address '0000000000000001'
		description 'Lot\'s of switches'
		num_switches 1
		switches_per_row 1
	end

	factory :camera_device do
		name 'Camera 1'
		address '0000000000000005'
		description '..+++###'
		host '127.0.0.1'
		port 80
		user 'user'
		password 'password'
		refresh_interval 60
	end

	factory :ip_camera_device do
		name 'Camera 2'
		address '0000000000000006'
		description '..+++###'
		host '127.0.0.1'
		port 80
		user 'user'
		password 'password'
		refresh_interval 60
	end

	factory :dimmer_device do
		name 'Dimmer Device'
		address '0000000000000003'
		description '..+++###'
	end

	factory :dimmer_rgb_device do
		name 'Dimmer RGB Device'
		address '0000000000000004'
		description '..+++###'
	end

	factory :easyvr_device do
		name 'EasyVR Device'
		address '0000000000000008'
		description '..+++###'
		num_buttons 10
		buttons_per_row 5
	end

	factory :remote_control_device do
		name 'Remote Control Device'
		address '0000000000000009'
		description '-~-~-~>>>'
		num_buttons 10
		buttons_per_row 5
	end

	factory :robot_device do
		name 'Robot Device'
		address '000000000000000A'
		description 'A robot'
	end

	factory :device_script do
		sequence(:name) { |n| "Script-#{n}" }
		sequence(:description) { |n| Faker::Lorem.sentence }
		script '10.times { puts "Hello!" }'
		enabled true
	end

	factory :building do
		sequence(:name) { |n| "Building-#{n}" }
		sequence(:description) { |n| "This is building #{n}" }
	end

	factory :floor do
		sequence(:name) { |n| "Floor-#{n}" }
		sequence(:description) { |n| "This is floor #{n}" }
		building { Building.first || FactoryGirl.create(:building) }
	end

	factory :room do
		sequence(:number) { |n| "Room-#{n}" }
		sequence(:description) { |n| "This is room #{n}" }
		floor { Floor.first || FactoryGirl.create(:floor) }
	end

	factory :dashboard do
		sequence(:name) { |n| "Dashboard #{n}" }
		user { User.first || FactoryGirl.create(:user) }
		default false
	end

	factory :widget do
	end

	factory :device_widget do
		x 1
		y 1
		width 1
		height 1
	end

end
