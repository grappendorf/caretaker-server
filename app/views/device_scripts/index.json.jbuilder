json.array! @device_scripts do |device_script|
	json.id device_script.id
	json.name device_script.name
	json.enabled device_script.enabled
	json.description device_script.description
end