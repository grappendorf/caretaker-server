class DeviceWidget < Widget

	belongs_to :device

	inject :device_manager

	def title
		read_attribute(:title) || device.name
	end

	def self.attr_accessible
		Widget.attr_accessible + [:device_id]
	end

end
