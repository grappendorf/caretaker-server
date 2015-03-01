module WlanConnectionState

  include ConnectionState

  # noinspection RubyArgCount
  def init_connection_state
    @connection_listeners = []
    device = self

    # (ambigious state method)
    @machine = Statemachine.build do
      context device
      state :DISCONNECTED do
        on_entry :notify_connection_listeners
        event :connect, :WAIT_FOR_CONNECTION, :send_ping_request
      end
      state :WAIT_FOR_CONNECTION do
        event :ping_response, :CONNECTED
      end
      state :CONNECTED do
        on_entry :notify_connection_listeners
        event :disconnect, :DISCONNECTED
      end
    end
  end

  def connect
    @machine.connect
  end

  def disconnect
    @machine.disconnect
  end

  def state
    @machine.state
  end

  def connected?
    @machine.state == :CONNECTED
  end

  def when_connection_changed &block
    @connection_listeners << block
  end

  def notify_connection_listeners
    @connection_listeners.each { |l| l.call self }
  end

  def send_ping_request
    send_message CaretakerMessages::PING_REQUEST
  end

  def on_ping_response
    @machine.ping_response
  end

end
