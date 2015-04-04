module ServiceManager

  def self.start
    if ['rake', 'annotate'].include?(File.basename($0)) || Rails.const_defined?('Console')
      return
    end

    Rails.logger.info 'Service manager starting'

    # Preload all device classes
    Dir['app/models/devices/*_device.rb'].each { |f| require_relative "../../#{f}" }

    # Preload all widget classes
    Dir['app/models/widgets/*_widget.rb'].each { |f| require_relative "../../#{f}" }

    register_real_services if real_mode?
    register_fake_services unless real_mode?
    register_services

    lookup(:device_manager).start
    lookup(:device_script_manager).start
    lookup(:philips_hue).start
  end

  def self.register_real_services
    register(:random) { Random.new Random.new_seed }
    register(:scheduler) { Rufus::Scheduler.start_new }
    register(:wlan_master) { WlanMaster.new }
  end

  def self.register_fake_services
    register(:random) { DeterministicRandom.new }
    register(:scheduler) { Rufus::Scheduler.start_new } if Rails.env.development?
    register(:scheduler) { ManualScheduler.new } if Rails.env.test?
    register(:wlan_master) { WlanMasterSimulator.new }
  end

  def self.register_services
    register(:async) { ThreadStorm.new size: 2 }
    register(:device_manager) { DeviceManager.new }
    register(:device_script_manager) { DeviceScriptManager.new }
    register(:philips_hue) { PhilipsHueManager.new }
  end

  def self.stop
    if ['rake', 'annotate'].include?(File.basename($0)) || Rails.const_defined?('Console')
      return
    end

    Rails.logger.info 'Service manager stopping'

    lookup(:scheduler).try :stop
    lookup(:device_script_manager).try :stop rescue nil
    lookup(:device_manager).try :stop rescue nil
    lookup(:philips_hue).try :stop rescue nil
  end

end

at_exit do
  ServiceManager.stop
end
