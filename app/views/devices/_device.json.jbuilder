json.id device.as_device.id
json.name device.name
unless params[:x]
	json.type device.class.name
	json.address device.address
	json.description device.description

	managed_device = lookup(:device_manager).device_by_id(device.id)

	json.state managed_device.current_state
	json.connected managed_device.connected?

	json.partial! "devices/#{device.class.name.underscore}", device: device
end
