class DeviceEventsController < WebsocketRails::BaseController

  inject :xbee_device_manager

  def state
    device = xbee_device_manager.device_by_id(message[:id])
    device.put_state message[:state]
  end

  def reconnect
    device = xbee_device_manager.device_by_id(message[:id])
    device.disconnect
    device.connect
  end

end
