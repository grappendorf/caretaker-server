module ServiceManager

	def self.start
		Rails.logger.info 'Service manager starting' if real_mode?

		# Preload all device classes
		Dir['app/models/devices/*_device.rb'].each { |f| require_relative "../../#{f}" }

		# Preload all widget classes
		Dir['app/models/widgets/*_widget.rb'].each { |f| require_relative "../../#{f}" }

		register_real_services if real_mode?
		register_fake_services unless real_mode?
		register_services

		unless File.basename($0) == 'rake'
			lookup(:device_manager).start
			lookup(:device_script_manager).start
		end
	end

	def self.register_real_services
		register(:random) { Random.new Random.new_seed }
		register(:xbee) { XBeeRuby::XBee.new port: Settings.xbee.tty, rate: Settings.xbee.rate }
		register(:scheduler) { Rufus::Scheduler.start_new }
	end

	def self.register_fake_services
		register(:random) { DeterministicRandom.new }
		case Settings.xbee.driver
			when :serial
				register(:xbee) { XBeeRuby::XBee.new port: Settings.xbee.tty, rate: Settings.xbee.rate }
			else
				xbeesim = XbeeSim.new
				register(:xbeesim) { xbeesim }
				register(:xbee) { XBeeRuby::XBee.new serial: xbeesim }
		end
		register(:scheduler) { Rufus::Scheduler.start_new } if Rails.env.development?
		register(:scheduler) { ManualScheduler.new } if Rails.env.test?
	end

	def self.register_services
		register(:async) { ThreadStorm.new size: 2 }
		register(:xbee_master) { XbeeMaster.new }
		register(:device_manager) { DeviceManager.new }
		register(:device_script_manager) { DeviceScriptManager.new }
	end

	def self.stop
		Rails.logger.info 'Service manager stopping' if real_mode?
		lookup(:device_script_manager).stop if registered?(:device_script_manager)
		lookup(:device_manager).stop if registered?(:device_manager)
	end

end

at_exit do
	ServiceManager.stop
end
