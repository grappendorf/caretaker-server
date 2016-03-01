require 'socket'

class DeviceManager

  inject :wlan_master

  def initialize
    @devices_by_address = {}
    @devices_by_id = {}
    @devices_by_uuid = {}
  end

  def start
    Rails.logger.info 'Device Manager starting'

    Device.all.each {|device| add_device device.specific}

    wlan_master.when_message_received { |*args| wlan_message_received *args }
    wlan_master.start

    devices.each {|device| device.start }
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
    device_id = device.acting_as.id
    @devices_by_id[device_id] = device
    @devices_by_uuid[device.uuid] = device
    if device.address
      @devices_by_address[device.address] = device
    end
    device.init_connection_state
    device.when_connection_changed do |device|
      WebsocketRails[:devices].trigger 'connection', { id: device_id, connected: device.connected? }
    end
    device.when_changed do |device|
      WebsocketRails[:devices].trigger 'state',
                                       { type: device.class.name, id: device_id, state: device.current_state }
    end
  end

  def create_device device
    add_device device
    device.start
  end

  def update_device device
    device.stop
    remove_device device.acting_as.id
    add_device device
    device.start
  end

  def remove_device device_id
    device = @devices_by_id[device_id]
    device.stop
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
    if msg == CaretakerMessages::REGISTER_REQUEST
      unless Device.exists? uuid: params[0]
        device = Device.new_from_type "#{params[1]}Device"
        device.update_attributes uuid: params[0], address: address, name: params[2], description: params[3]
        device.update_attributes_from_registration params[4..-1]
        device.save!
        create_device device
        WebsocketRails[:devices].trigger 'register', { id: device.id }
      else
        device = Device.find_by_uuid params[0]
        if device.address != address
          @devices_by_address.delete device.address
          @devices_by_address[address] = device
        end
      end
      wlan_master.send_message address, CaretakerMessages::REGISTER_RESPONSE
    elsif msg > 0
      device_by_address(address).try(:message_received, msg, params)
    end
  end

end
