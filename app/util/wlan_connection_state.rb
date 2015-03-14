module WlanConnectionState

  include ConnectionState

  inject :scheduler

  PING_TIMEOUT = 10 * 60

  # noinspection RubyArgCount
  # (ambigious state method)
  def init_connection_state
    @connection_listeners = []
    device = self

    @machine = Statemachine.build do
      context device
      state :DISCONNECTED do
        on_entry :device_disconnected
        event :connect, :WAIT_FOR_PING, :send_ping
        event :ping, :CONNECTED
      end
      state :WAIT_FOR_PING do
        event :ping, :CONNECTED
        event :timeout, :WAIT_FOR_PING, :send_ping
      end
      state :CONNECTED do
        on_entry :device_connected
        event :ping, :CONNECTED
        event :timeout, :DISCONNECTED
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

  def send_ping
    send_message CaretakerMessages::PING
  end

  def on_ping
    @timeout_job.unschedule if @timeout_job
    @timeout_job = scheduler.in PING_TIMEOUT do
      @timeout_job = nil
      @machine.timeout
    end
    @machine.ping
  end

  def device_connected
    notify_connection_listeners
  end

  def device_disconnected
    notify_connection_listeners
  end
end
