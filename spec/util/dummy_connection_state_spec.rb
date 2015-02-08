require 'spec_helper'
require 'util/dummy_connection_state'

describe DummyConnectionState do

  class DummyConnectionStateDevice < Device
    handle_connection_state_with DummyConnectionState
  end

  it 'should always return the :UNKNOWN connection state' do
    connection_state = DummyConnectionStateDevice.new
    expect(connection_state.state).to eq ConnectionState::State::UNKNOWN
  end

end
