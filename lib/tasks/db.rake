unless ARGV.any? { |a| a =~ /^gems/ } # Don't load anything when running the gems:* tasks

	begin

		namespace :db do

			desc 'Purge all database data and create! new sample'
			task sample: [:environment, 'db:mongoid:purge', 'db:seed'] do

				# User

				5.times do |_|
					first_name = Faker::Name.first_name
					last_name = Faker::Name.last_name
					name = "#{first_name.downcase[0]}#{last_name.downcase}"
					password = 'password'
					User.create! name: name,
					             email: Faker::Internet.safe_email,
					             password: password, password_confirmation: password
				end

				# Devices

				switch_device = SwitchDevice.create! name: 'Switch', address: '0000000000000001', description: '1 Switch',
				                                     num_switches: 1, switches_per_row: 1

				switch8_device = SwitchDevice.create! name: '8-Port Switch', address: '0000000000000002', description: 'Lot\'s of Switches',
				                                      num_switches: 8, switches_per_row: 4

				dimmer_device = DimmerDevice.create! name: 'Dimmer', address: '0000000000000003', description: '0% to 100%'

				dimmer_rgb_device = DimmerRgbDevice.create! name: 'Dimmer RGB', address: '0000000000000004', description: 'Ghost Light'

				camera1_device = CameraDevice.create! name: 'Camera 1', address: '0000000000000005', description: 'What\'r you doing Dave?',
				                                      host: '192.168.0.1', port: '80', user: 'view', password: 'view', refresh_interval: '5'

				camera2_device = IpCameraDevice.create! name: 'Camera 2', address: '0000000000000006', description: 'What\'r you doing Dave?',
				                                        host: '192.168.0.2', port: '80', user: 'view', password: 'view', refresh_interval: '5'

				reflow_oven_device = ReflowOvenDevice.create! name: 'Reflow Oven', address: '0000000000000007', description: 'Reflow Oven'

				# Device Scripts

				5.times do |n|
					DeviceScript.create! name: "Script-#{n}", description: "This is script number #{n}",
					                     script: "puts \"Hello from Script-#{n}!\"", enabled: n%2 == 0
				end

				# Dashboard

				dashboard = Dashboard.create! name: 'Default', default: true, user: User.find_by(email: 'user@example.com')
				dashboard.widgets << DeviceWidget.new(device: switch8_device, x: 1, y: 1, width: 2, height: 2)
				dashboard.widgets << DeviceWidget.new(device: switch_device, x: 1, y: 3, width: 2, height: 1)
				dashboard.widgets << DeviceWidget.new(device: dimmer_device, x: 3, y: 1, width: 2, height: 1)
				dashboard.widgets << DeviceWidget.new(device: dimmer_rgb_device, x: 3, y: 2, width: 2, height: 1)
				dashboard.widgets << DeviceWidget.new(device: camera1_device, x: 5, y: 1, width: 2, height: 2)
				dashboard.widgets << DeviceWidget.new(device: camera2_device, x: 5, y: 3, width: 2, height: 2)
				dashboard.widgets << DeviceWidget.new(device: reflow_oven_device, x: 3, y: 3, width: 2, height: 2)

				(1..5).each do |i|
					building = Building.create! name: "Building #{i}", description: "This is building #{i}"
					(1..5).each do |j|
						floor = building.floors.create! name: "Floor #{i}.#{j}", description: "This is floor #{j} in building #{i}"
						(1..50).each do |k|
							floor.rooms.create! number: "#{i}.#{j}.#{k}", description: "This is room #{k} on floor #{j} in building #{i}"
						end
					end
				end

			end

			task private: [:environment, 'db:mongoid:purge', 'db:seed'] do

				private_data = '../coyoho-private/create-db-sample-data.rb'
				require_relative "../../#{private_data}"

			end

		end

	end
end
