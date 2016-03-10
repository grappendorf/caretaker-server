module ServiceManager

  def self.start
    if ['rake', 'annotate'].include?(File.basename($0))
      return
    end

    Grape::API.logger.info 'Service manager starting'

    register_real_services if Application.config.env == :production
    register_fake_services unless Application.config.env == :production
    register_services

    lookup(:device_manager).start
    lookup(:device_script_manager).start
    lookup(:device_action_manager).start
    lookup(:philips_hue).start
    lookup(:websockets).start
  end

  def self.register_real_services
    require_relative '../../app/services/wlan_master'
    register(:random) { Random.new Random.new_seed }
    register(:scheduler) { Rufus::Scheduler.start_new }
    register(:wlan_master) { WlanMaster.new }
  end

  def self.register_fake_services
    require_relative '../../app/services/wlan_master_simulator'
    register(:random) { DeterministicRandom.new }
    register(:scheduler) { Rufus::Scheduler.start_new } if Application.config.env == :development
    register(:scheduler) { ManualScheduler.new } if Application.config.env == :test
    register(:wlan_master) { WlanMasterSimulator.new }
  end

  def self.register_services
    require_relative '../../app/services/device_manager'
    require_relative '../../app/services/device_script_manager'
    require_relative '../../app/services/device_action_manager'
    require_relative '../../app/services/philips_hue_manager'
    require_relative '../../app/services/websockets_manager'
    register(:async) { ThreadStorm.new size: 2 }
    register(:device_manager) { DeviceManager.new }
    register(:device_script_manager) { DeviceScriptManager.new }
    register(:device_action_manager) { DeviceActionManager.new }
    register(:philips_hue) { PhilipsHueManager.new }
    register(:websockets) { WebsocketsManager.new }
  end

  def self.stop
    if %w(rake annotate).include?(File.basename($0))
      return
    end

    Grape::API.logger.info 'Service manager stopping'

    lookup(:scheduler).try :stop
    lookup(:device_script_manager).try :stop rescue nil
    lookup(:device_manager).try :stop rescue nil
    lookup(:philips_hue).try :stop rescue nil
    lookup(:websockets).try :stop rescue nil
  end

end

at_exit do
  ServiceManager.stop
end
