unless ARGV.any? { |a| a =~ /^gems/ } # Don't load anything when running the gems:* tasks

  begin

    namespace :db do

      desc 'Purge all database data and create! new sample'
      task :sample => :environment do

        puts 'Create some users...'

        5.times do |_|
          first_name = Faker::Name.first_name
          last_name = Faker::Name.last_name
          name = "#{first_name.downcase[0]}#{last_name.downcase}"
          password = 'password'
          User.create! name: name,
                       email: Faker::Internet.safe_email,
                       password: password, password_confirmation: password
        end

        puts 'Create some devices...'

        switch_device = SwitchDevice.create! guid: '6a27c513-994d-46cb-b9dd-7bbaf97fa504',
                                             name: 'Switch', address: '0000000000000001', description: '1 Switch',
                                             num_switches: 1, switches_per_row: 1

        switch8_device = SwitchDevice.create! guid: 'a7f9fad6-2779-4bac-a2de-555fa1a67527',
                                              name: '8-Port Switch', address: '0000000000000002', description: 'Lot\'s of Switches',
                                              num_switches: 8, switches_per_row: 4

        dimmer_device = DimmerDevice.create! guid: '082ea83d-6a39-4b13-8855-1dff06b6d556',
                                             name: 'Dimmer', address: '0000000000000003', description: '0% to 100%'

        dimmer_rgb_device = DimmerRgbDevice.create! guid: '7157e214-0093-47a4-a511-3180d49bd4f1',
                                                    name: 'Dimmer RGB', address: '0000000000000004', description: 'Ghost Light'

        camera1_device = CameraDevice.create! guid: '3ce1c6e2-1085-431a-8c24-a5cc66466d2e',
                                              name: 'Camera 1', address: '0000000000000005', description: 'What\'r you doing Dave?',
                                              host: '192.168.0.1', port: '80', user: 'view', password: 'view', refresh_interval: '5'

        camera2_device = IpCameraDevice.create! guid: '976e79c8-a722-49c7-b1b1-2c36093f9c03',
                                                name: 'Camera 2', address: '0000000000000006', description: 'What\'r you doing Dave?',
                                                host: '192.168.0.2', port: '80', user: 'view', password: 'view', refresh_interval: '5'

        reflow_oven_device = ReflowOvenDevice.create! guid: '22dbd24d-225b-4cea-bfb9-36e0a319ef0f',
                                                      name: 'Reflow Oven', address: '0000000000000007', description: 'Reflow Oven'

        puts 'Create some device scripts...'

        5.times do |n|
          DeviceScript.create! name: "Script-#{n}", description: "This is script number #{n}",
                               script: "puts \"Hello from Script-#{n}!\"", enabled: n%2 == 0
        end

        puts 'Create some dashboards...'

        dashboard = Dashboard.create! name: 'Default', default: true, user: User.find_by(email: 'user@example.com')
        dashboard.widgets << DeviceWidget.new(device: switch8_device, position: 0, width: 2, height: 2)
        dashboard.widgets << DeviceWidget.new(device: reflow_oven_device, position: 1, width: 3, height: 3)
        dashboard.widgets << DeviceWidget.new(device: camera1_device, position: 2, width: 2, height: 2)
        dashboard.widgets << DeviceWidget.new(device: switch_device, position: 3, width: 2, height: 1)
        dashboard.widgets << DeviceWidget.new(device: camera2_device, position: 4, width: 2, height: 2)
        dashboard.widgets << DeviceWidget.new(device: dimmer_device, position: 5, width: 2, height: 1)
        dashboard.widgets << DeviceWidget.new(device: dimmer_rgb_device, position: 6, width: 2, height: 1)
        dashboard.widgets << WeatherWidget.new(position: 7, width: 2, height: 2)

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

      task :private => :environment do

        private_data = '../caretaker-private/create-db-sample-data.rb'
        require_relative "../../#{private_data}"

      end

    end

  end
end
