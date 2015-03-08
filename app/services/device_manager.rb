require 'socket'

class DeviceManager < SingletonService

  inject :wlan_master

  def initialize
    @devices_by_address = {}
    @devices_by_id = {}
    @devices_by_uuid = {}
  end

  def start
    super
    Rails.logger.info 'Device Manager starting'

    wlan_master.when_message_received { |*args| wlan_message_received *args }
    wlan_master.start

    Device.all.each do |device|
      add_device device.specific
    end
  end

  def stop
    Rails.logger.info 'Device Manager stopping'
    wlan_master.stop
    super
  end

  def restart
    stop
    start
  end

  def device_by_address address
    @devices_by_address[address]
  end

  def device_by_id id
    @devices_by_id[id]
  end

  def device_by_uuid uuid
    @devices_by_uuid[uuid]
  end

  def add_device device
    device_id = device.as_device.id
    @devices_by_id[device_id] = device
    @devices_by_uuid[device.uuid] = device
    if device.address
      @devices_by_address[device.address] = device
    end
    device.init_connection_state
    device.when_connection_changed do |device|
      WebsocketRails[:devices].trigger('connection', { id: device_id, connected: device.connected? })
    end
    device.when_changed do |device|
      WebsocketRails[:devices].trigger('state',
                                       { type: device.class.name, id: device_id, state: device.current_state })
    end
    device.start
  end

  def create_device device
    add_device device
  end

  def update_device device
    remove_device device.as_device.id
    add_device device
  end

  def remove_device device_id
    device = @devices_by_id[device_id]
    @devices_by_address.delete device.address
    @devices_by_uuid.delete device.uuid
    @devices_by_id.delete device_id
  end

  def remove_all_devices
    @devices_by_id.each { |id, _| remove_device id }
  end

  def devices
    @devices_by_id.values
  end

  def devices_by_id
    @devices_by_id
  end

  def wlan_message_received address, msg, params
    Rails.logger.debug "WLAN device message received: #{address}, #{msg}, #{params}"
    if msg == CaretakerMessages::REGISTER_REQUEST
      Rails.logger.debug "Registration request from: #{params[0]}"
      unless Device.exists? uuid: params[0]
        Rails.logger.debug "Create new device: #{params[2]}"
        device = Device.new_from_type "#{params[1]}Device"
        device.update_attributes uuid: params[0], address: address, name: params[2], description: params[3]
        device.update_attributes_from_registration params[4..-1]
        device.save!
        add_device device
        WebsocketRails[:devices].trigger 'register', { id: device.id }
      else
        device = Device.find_by_uuid params[0]
        if device.address != address
          Rails.logger.debug "Device address changed to: #{address}"
          @devices_by_address.delete device.address
          @devices_by_address[address] = device
        else
          Rails.logger.debug "Known device re-registered"
        end
      end
      wlan_master.send_message address, CaretakerMessages::REGISTER_RESPONSE
    elsif msg > 0
      device_by_address(address).message_received msg, params
    end
  end

end
