class RobotDevice < Device

	include XbeeDevice

  def self.attr_accessible
    Device.attr_accessible
  end

  handle_connection_state_with XBeeConnectionState

	def self.small_icon() '16/cat.png' end

	def self.large_icon() '32/cat.png' end

	def message_received _
	end

	def current_state
	end

end
