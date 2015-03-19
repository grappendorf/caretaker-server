json.id device.acting_as.id
json.specific_id device.id
json.uuid device.uuid
json.name device.name
json.small_icon device.class.small_icon
json.large_icon device.class.large_icon
unless params[:x]
  json.type device.class.name
  json.address device.address
  json.description device.description

  managed_device = lookup(:device_manager).device_by_id(device.acting_as.id)
  if managed_device
    json.state managed_device.current_state
    json.connected managed_device.connected?
  end

  json.partial! "devices/#{device.class.name.underscore}", device: device
end
