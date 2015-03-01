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
    register(:scheduler) { SingletonService.new { Rufus::Scheduler.start_new } }
  end

  def self.register_fake_services
    register(:random) { DeterministicRandom.new }
    case Settings.xbee.driver
      when :serial
        register(:xbee) { XBeeRuby::XBee.new port: Settings.xbee.tty, rate: Settings.xbee.rate }
      else
        register(:xbeesim) { XbeeSim.new }
        register(:xbee) { XBeeRuby::XBee.new serial: lookup(:xbeesim) }
    end
    register(:scheduler) { SingletonService.new { Rufus::Scheduler.start_new } } if Rails.env.development?
    register(:scheduler) { ManualScheduler.new } if Rails.env.test?
  end

  def self.register_services
    register(:async) { ThreadStorm.new size: 2 }
    register(:wlan_master) { WlanMaster.new }
    register(:xbee_master) { XbeeMaster.new }
    register(:device_manager) { DeviceManager.new }
    register(:device_script_manager) { DeviceScriptManager.new }
  end

  def self.stop
    Rails.logger.info 'Service manager stopping' if real_mode?
    lookup(:scheduler).try :stop
    lookup(:device_script_manager).try :stop rescue nil
    lookup(:device_manager).try :stop rescue nil
  end

end

at_exit do
  ServiceManager.stop
end
