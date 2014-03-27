class DeviceSerializer < ActiveModel::Serializer

	inject :device_manager

	attributes :id, :type, :name, :address, :description, :state

	def type
		object.class.name
	end

	def state
		device_manager.device_by_id(id).current_state
	end

end