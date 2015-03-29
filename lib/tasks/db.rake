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

        switch1_device = SwitchDevice.create! uuid: '00:00:00:00:00:01',
            name: 'Switch 1-Port', address: '192.168.1.1', description: 'One switch',
            num_switches: 1, switches_per_row: 1

        switch8_device = SwitchDevice.create! uuid: '00:00:00:00:00:02',
            name: 'Switch 8-Port', address: '192.168.1.2', description: 'Lot\'s of switches',
            num_switches: 8, switches_per_row: 4

        dimmer_device = DimmerDevice.create! uuid: '00:00:00:00:00:03',
            name: 'Dimmer', address: '192.168.1.3', description: '0% to 100%'

        dimmer_rgb_device = DimmerRgbDevice.create! uuid: '00:00:00:00:00:04',
            name: 'Dimmer RGB', address: '192.168.1.4', description: 'Rainbow colors'

        sensor_device = SensorDevice.create! uuid: '00:00:00:00:00:05',
            name: 'Sensor', address: '192.168.1.5', description: 'Senors',
            sensors: [{ type: CaretakerMessages::SENSOR_TEMPERATURE, min: -30, max: 80 },
                { type: CaretakerMessages::SENSOR_BRIGHTNESS, min: 0, max: 1000 }]

        remotecontrol_device = RemoteControlDevice.create! uuid: '00:00:00:00:00:06',
            name: 'Remote Control', address: '192.168.1.6', description: 'Lot\'s of buttons',
            num_buttons: 8, buttons_per_row: 4

        puts 'Create some device scripts...'

        DeviceScript.create! name: "Remote Control", description: "Script for Remote Control buttons",
            enabled: true, script: <<-EOS
              def start()
                device_manager = lookup :device_manager
                @remote = device_manager.device_by_uuid '00:00:00:00:00:06'
                @switch1 = device_manager.device_by_uuid '00:00:00:00:00:01'
                @switch8 = device_manager.device_by_uuid '00:00:00:00:00:02'
                @dimmer = device_manager.device_by_uuid '00:00:00:00:00:03'
                @sensor = device_manager.device_by_uuid '00:00:00:00:00:05'

                @lights_on = false

                @remote_listener = @remote.when_changed do
                  if @remote.states[0] == 1
                    if @lights_on
                    @switch8.set_state 0, 0
                    @switch8.set_state 1, 0
                      @dimmer.set_value 0
                    else
                      @switch8.set_state 0, 1
                      @switch8.set_state 1, 1
                      @dimmer.set_value 255
                    end
                    @lights_on = !@lights_on
                  end
                end

                @last_temp = 0.0

                @sensor_listener = @sensor.when_changed do
                  if @last_temp > 20.0 && @sensor.states[0] < 20.0
                    @switch1.set_state 0, 1
                  elsif @last_temp < 20.0 && @sensor.states[0] > 20.0
                    @switch1.set_state 0, 0
                  end
                  @last_temp = @sensor.states[0]
                end

              end

              def stop
                @remote.remove_change_listener @remote_listener
                @sensor.remove_change_listener @sensor_listener
              end
        EOS

        puts 'Create some dashboards...'

        dashboard = Dashboard.create! name: 'Default', default: true, user: User.find_by(email: 'user@example.com')
        dashboard.widgets << DeviceWidget.new(device: switch1_device, position: 0, width: 1, height: 1)
        dashboard.widgets << DeviceWidget.new(device: switch8_device, position: 1, width: 2, height: 1)
        dashboard.widgets << DeviceWidget.new(device: dimmer_device, position: 2, width: 2, height: 1)
        dashboard.widgets << DeviceWidget.new(device: dimmer_rgb_device, position: 3, width: 2, height: 1)
        dashboard.widgets << DeviceWidget.new(device: sensor_device, position: 4, width: 2, height: 1)
        dashboard.widgets << DeviceWidget.new(device: remotecontrol_device, position: 5, width: 2, height: 1)

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
