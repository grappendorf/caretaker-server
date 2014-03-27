class DeviceManager

	inject :xbee_master

	def initialize
		@devices_by_address = {}
		@devices_by_id = {}
	end

	def start
		Rails.logger.info 'Device Manager starting'
		xbee_master.when_message_received { |*args| xbee_message_received *args }
		begin
			xbee_master.start
		rescue => x
			Rails.logger.error "Unable to open xbee device #{x}"
		end
		Device.all.each do |device|
			add_device device
		end
	end

	def stop
		Rails.logger.info 'Device Manager stopping'
		xbee_master.stop
	end

	def restart
		stop
		start
	end

	def xbee_message_received address, data
		device = @devices_by_address[address.to_s]
		if not device
			return
		end
		message_code = data[0]
		if message_code == (CoYoHoMessages::COYOHO_MESSAGE_RESPONSE | CoYoHoMessages::COYOHO_ADD_LISTENER)
			device.xbee_connect_response
			return
		end
		message_type = data[0] & CoYoHoMessages::COYOHO_MESSAGE_TYPE_MASK
		if message_type == CoYoHoMessages::COYOHO_MESSAGE_RESPONSE or
				message_type == CoYoHoMessages::COYOHO_MESSAGE_NOTIFY
			data[0] = data[0] & CoYoHoMessages::COYOHO_MESSAGE_COMMAND_MASK
			device.message_received data
		end
	end

	def device_by_address address
		@devices_by_address[address]
	end

	def device_by_id id
		@devices_by_id[id]
	end

	def add_device device
		@devices_by_id[device.id] = device
		if device.address
			@devices_by_address[device.address] = device
		end
		device.init_connection_state
		device.when_changed do |device|
			WebsocketRails[:devices].trigger('state',
			                                 {type: device.class.name.underscore, id: device.id.to_s, state: device.current_state})
		end
		device.start
	end

	def create_device device
		if device.save
			add_device device
		end
	end

	def update_device device
		if device.save
			@devices_by_id[device.id].stop
			@devices_by_id[device.id] = device
			@devices_by_address[device.address] = device
			device.start
		end
	end

	def remove_device device_id
		device = @devices_by_id[device_id]
		@devices_by_address.delete(device.address)
		@devices_by_id.delete(device_id)
		device.destroy
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

end