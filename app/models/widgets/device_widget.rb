# == Schema Information
#
# Table name: device_widgets
#
#  id          :integer          not null, primary key
#  device_id   :integer
#  device_type :string(255)
#

class DeviceWidget < ActiveRecord::Base

	inherit WidgetBase

	is_a :widget

	belongs_to :device, polymorphic: true

	inject :device_manager

	before_save :assign_device_if_only_device_id_is_set

	def title
		as_widget.title || device.name
	end

	def self.attr_accessible
		Widget.attr_accessible + [:device_id]
	end

	private
	def assign_device_if_only_device_id_is_set
		self.device = Device.find(device_id).specific if device_type.nil?
	end
end
