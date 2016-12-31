unless ARGV.any? { |a| a =~ /^gems/ } # Don't load anything when running the gems:* tasks

  include ActiveRecord::Tasks

  class Seeder
    def initialize(seed_file)
      @seed_file = seed_file
    end

    def load_seed
      raise "Seed file '#{@seed_file}' does not exist" unless File.file?(@seed_file)
      load @seed_file
    end
  end

  root = File.expand_path '../../..', __FILE__
  DatabaseTasks.env = ENV['RACK_ENV'] || 'development'
  DatabaseTasks.database_configuration = YAML.load(File.read(File.join(root, 'config/database.yml')))
  DatabaseTasks.db_dir = File.join root, 'db'
  DatabaseTasks.fixtures_path = File.join root, 'test/fixtures'
  DatabaseTasks.migrations_paths = [File.join(root, 'db/migrate')]
  DatabaseTasks.seed_loader = Seeder.new File.join root, 'db/seeds.rb'
  DatabaseTasks.root = root

  load 'active_record/railties/databases.rake'

  namespace :db do
    desc 'Create some sample data'
    task :demo => [:environment, 'db:reset'] do

      puts 'Create some users...'
      5.times do |_|
        first_name = Faker::Name.first_name
        last_name = Faker::Name.last_name
        name = "#{first_name.downcase[0]}#{last_name.downcase}"
        password = 'password'
        User.create! name: name,
          email: Faker::Internet.safe_email,
          password: password
      end

      puts 'Create some devices...'
      switch1_device = SwitchDevice.create! uuid: 'switch1',
        name: 'Switch 1-Port', description: 'One switch',
        address: '192.168.1.1', port: Application.config.device_port,
        num_switches: 1, switches_per_row: 1
      switch8_device = SwitchDevice.create! uuid: 'switch8',
        name: 'Switch 8-Port', description: 'Lot\'s of switches',
        address: '192.168.1.2', port: Application.config.device_port,
        num_switches: 8, switches_per_row: 4
      dimmer_device = DimmerDevice.create! uuid: 'dimmer',
        name: 'Dimmer', description: '0% to 100%',
        address: '192.168.1.3', port: Application.config.device_port
      dimmer_rgb_device = DimmerRgbDevice.create! uuid: 'rgb',
        name: 'Dimmer RGB', description: 'Rainbow colors',
        address: '192.168.1.4', port: Application.config.device_port
      sensor_device = SensorDevice.create! uuid: 'sensor',
        name: 'Sensor', description: 'Senors',
        address: '192.168.1.5', port: Application.config.device_port,
        sensors: [
          { type: CaretakerMessages::SENSOR_TEMPERATURE, min: -30, max: 80 },
          { type: CaretakerMessages::SENSOR_BRIGHTNESS, min: 0, max: 1000 }]
      remotecontrol_device = RemoteControlDevice.create! uuid: 'remote',
        name: 'Remote Control', description: 'Lot\'s of buttons',
        address: '192.168.1.6', port: Application.config.device_port,
        num_buttons: 8, buttons_per_row: 4
      rotary_knob_device = RotaryKnobDevice.create! uuid: 'rotary',
        address: '192.168.1.7', port: Application.config.device_port,
        name: 'Rotary Knob', address: '192.168.1.7', description: 'Knob'

      puts 'Create some device scripts...'
      DeviceScript.create! name: 'Remote Control', description: 'Script for Remote Control buttons',
        enabled: true, script: <<-EOS.strip_heredoc
          def start
            device_manager = lookup :device_manager
            @remote = device_manager.device_by_uuid 'remote'
            @switch = device_manager.device_by_uuid 'switch8'

            if @remote
              @remote_listener = @remote.when_changed do
                if @remote.states[0] == 1
                  @switch.toggle 0
                elsif @remote.states[1] == 1
                  @switch.toggle 1
                elsif @remote.states[2] == 1
                  @switch.toggle 2
                elsif @remote.states[3] == 1
                  @switch.toggle 3
                end
              end
            end
          end

          def stop
            if @remote
              @remote.remove_change_listener @remote_listener
            end
          end
      EOS

      DeviceScript.create! name: 'Rotary', description: 'Rotary Knob => Dimmer',
        enabled: true, script: <<-EOS.strip_heredoc
              def start
                device_manager = lookup :device_manager
                @rotary = device_manager.device_by_uuid 'rotary'
                @dimmer = device_manager.device_by_uuid 'dimmer'

                if @rotary
                  @rotary_listener = @rotary.when_changed do
                    @dimmer.set_value @rotary.value
                  end
                end
              end

              def stop
                if @rotary
                  @rotary.remove_change_listener @rotary_listener
                end
              end
      EOS

      puts 'Create some actions...'
      1.upto 4 do |n|
        DeviceAction.create! name: "Toggle #{n}", description: "Toggel switch #{n}",
          script: <<-EOS.strip_heredoc
            device_manager = lookup :device_manager
            @switch = device_manager.device_by_uuid "switch#{n}"
            @switch.toggle 0
        EOS
      end

      puts 'Create some dashboards...'
      dashboard = Dashboard.create! name: 'Default', default: true, user: User.find_by(email: 'user@example.com')
      dashboard.widgets << DeviceWidget.new(device: switch1_device, position: 0, width: 1, height: 1)
      dashboard.widgets << DeviceWidget.new(device: switch8_device, position: 1, width: 2, height: 1)
      dashboard.widgets << DeviceWidget.new(device: dimmer_device, position: 2, width: 2, height: 1)
      dashboard.widgets << DeviceWidget.new(device: dimmer_rgb_device, position: 3, width: 2, height: 1)
      dashboard.widgets << DeviceWidget.new(device: sensor_device, position: 4, width: 2, height: 1)
      dashboard.widgets << DeviceWidget.new(device: remotecontrol_device, position: 5, width: 2, height: 1)
      dashboard.widgets << DeviceWidget.new(device: rotary_knob_device, position: 6, width: 1, height: 1)
      DeviceAction.all.each_with_index do |action, i|
        dashboard.widgets << ActionWidget.new(device_action: action,
          position: 8 + i, width: 1, height: 1)
      end

      puts 'Create some buildings, floors, rooms, ...'
      (1..5).each do |i|
        building = Building.create! name: "Building #{i}",
          description: "This is building #{i}"
        (1..5).each do |j|
          floor = building.floors.create! name: "Floor #{i}.#{j}",
            description: "This is floor #{j} in building #{i}"
          (1..20).each do |k|
            floor.rooms.create! number: "#{i}.#{j}.#{k}",
              description: "This is room #{k} on floor #{j} in building #{i}"
          end
        end
      end
    end
  end
end
