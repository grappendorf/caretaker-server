class DeviceEventsController < WebsocketRails::BaseController

	inject :device_manager

	def state
		device = device_manager.device_by_id(BSON::ObjectId.from_string(message[:id]))
		device.put_state message[:state]
	end

	def reconnect
		device = device_manager.device_by_id(BSON::ObjectId.from_string(message[:id]))
		device.disconnect
		device.connect
	end

end
