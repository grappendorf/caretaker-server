require 'renum'

module ConnectionState

  # A devices is always in one of the following connection states:
  # - UNKNOWN
  #	We really don't know the current connection state
  # - DISCONNECTED
  #	We are unable to access the devices
  # - CONNECTED
  #   A successful connection is established and data can be transferred
  #	to and from the devices
  enum :State, [:UNKNOWN, :DISCONNECTED, :CONNECTED]

  def state
    :DISCONNECTED
  end

  # Check if the devices is connected (i.e. has the state :CONNECTED)
  def connected?
    state == :CONNECTED
  end

end
