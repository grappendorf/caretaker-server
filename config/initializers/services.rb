module ServiceManager
  def self.start
    if ['rake', 'annotate'].include?(File.basename($0))
      return
    end

    Grape::API.logger.info 'Service manager starting'

    register_services

    lookup(:device_manager).start
    lookup(:device_script_manager).start
    lookup(:device_action_manager).start
    lookup(:philips_hue).start
    lookup(:websockets).start
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

    if Application.config.env == :test
      require_relative '../../app/util/deterministic_random'
      require_relative '../../app/services/manual_scheduler'
      register(:random) { DeterministicRandom.new }
      register(:scheduler) { ManualScheduler.new }
    else
      register(:random) { Random.new Random.new_seed }
      register(:scheduler) { Rufus::Scheduler.start_new }
    end

    if [:test, :development].include? Application.config.env
      require_relative '../../app/services/wlan_master_simulator'
      register(:wlan_master) { WlanMasterSimulator.new }
    else
      require_relative '../../app/services/wlan_master'
      register(:wlan_master) { WlanMaster.new }
    end
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
