class DeviceWidgetSerializer < WidgetSerializer

	has_one :device

	def type
		"#{device.class.name}Widget"
	end

end