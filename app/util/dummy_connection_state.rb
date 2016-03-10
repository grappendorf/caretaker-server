module DummyConnectionState
  include ConnectionState

  def init_connection_state
  end

  def state
    ConnectionState::State::UNKNOWN
  end

  def when_connection_changed &_
  end

  def connect
  end

  def disconnect
  end
end
