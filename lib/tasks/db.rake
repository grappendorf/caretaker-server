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

      puts 'Create some device scripts...'
      DeviceScript.create! name: 'Remote Control', description: 'Script for Remote Control buttons',
        enabled: true, script: <<-EOS.strip_heredoc
          def start
            device_manager = lookup :device_manager
            @remote = device_manager.device_by_uuid 'remote'
            @switch1 = device_manager.device_by_uuid 'switch1'
            @switch2 = device_manager.device_by_uuid 'switch2'
            @switch3 = device_manager.device_by_uuid 'switch3'
            @switch4 = device_manager.device_by_uuid 'switch4'

            if @remote
              @remote_listener = @remote.when_changed do
                if @remote.states[0] == 1
                  @switch1.toggle 0
                elsif @remote.states[0] == 2
                  @switch1.toggle 0
                elsif @remote.states[0] == 3
                  @switch2.toggle 0
                elsif @remote.states[0] == 4
                  @switch3.toggle 0
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
      dashboard = Dashboard.create! name: 'Default', default: true,
        user: User.find_by(email: 'user@example.com')
      position = 0
      DeviceAction.all.each do |action|
        dashboard.widgets << ActionWidget.new(device_action: action,
          position: position, width: 1, height: 1)
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
