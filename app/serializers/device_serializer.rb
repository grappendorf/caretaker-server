class DeviceSerializer < ActiveModel::Serializer

	inject :device_manager

	attributes :id, :type, :name, :address, :description, :state, :connected

	def id
		object.as_device.id
	end

	def type
		object.class.name
	end

	def state
		device_manager.device_by_id(id).current_state
	end

	def connected
		device_manager.device_by_id(id).connected?
	end

end