class ReflowOvenDevice < Device

	include XbeeDevice

  def self.attr_accessible
    Device.attr_accessible
  end

  handle_connection_state_with XBeeConnectionState

	def self.small_icon() '16/oven.png' end

	def self.large_icon() '32/oven.png' end

	def update
	end

	def message_received _
	end

	def current_state
	end

end
