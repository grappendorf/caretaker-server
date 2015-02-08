require 'spec_helper'

describe XBeeConnectionState do

  inject :random
  inject :scheduler

  class XBeeConnectionStateDevice < Device
    handle_connection_state_with XBeeConnectionState

    def name;
      'under test';
    end

    def send_message msg;
    end
  end

  before :each do
    random.reset
    scheduler.reset
    @connection_state = XBeeConnectionStateDevice.new
    @connection_state.init_connection_state
  end

  it 'starts in state :DISCONNECTED' do
    expect(@connection_state.state).to eq ConnectionState::State::DISCONNECTED
  end

  it 'starts in internal state :DISCONNECTED' do
    expect(@connection_state.xbee_connection_state).to eq :DISCONNECTED
  end

  it 'stays in internal state :DISCONNECTED when receiving a connection response in :DISCONNECTED' do
    @connection_state.xbee_connect_response
    expect(@connection_state.xbee_connection_state).to eq :DISCONNECTED
  end

  it 'stays in internal state :DISCONNECTED when receiving :timeout in :DISCONNECTED' do
    @connection_state.xbee_timeout
    expect(@connection_state.xbee_connection_state).to eq :DISCONNECTED
  end

  it 'stays in internal state :DISCONNECTED when disconnecting in :DISCONNECTED' do
    @connection_state.disconnect
    expect(@connection_state.xbee_connection_state).to eq :DISCONNECTED
  end

  it 'enters internal state :WAIT_FOR_CONNECTION when connecting' do
    @connection_state.connect
    expect(@connection_state.xbee_connection_state).to eq :WAIT_FOR_CONNECTION
  end

  it 'tries to register with the device after a random delay when connecting' do
    random.next_number XBeeConnectionState::REGISTER_FIRST_ATTEMPT_DELAY_RANDOM
    expect(@connection_state).to receive(:send_message).with(CaretakerMessages::CARETAKER_ADD_LISTENER)
    @connection_state.connect
    scheduler.step XBeeConnectionState::REGISTER_FIRST_ATTEMPT_DELAY
    scheduler.step XBeeConnectionState::REGISTER_FIRST_ATTEMPT_DELAY_RANDOM
  end

  it 'retries to connect when a timeout occured when connecting' do
    random.next_number XBeeConnectionState::REGISTER_FIRST_ATTEMPT_DELAY_RANDOM
    expect(@connection_state).to receive(:send_message).with(CaretakerMessages::CARETAKER_ADD_LISTENER).twice
    @connection_state.connect
    scheduler.step XBeeConnectionState::REGISTER_FIRST_ATTEMPT_DELAY
    scheduler.step XBeeConnectionState::REGISTER_FIRST_ATTEMPT_DELAY_RANDOM
    scheduler.step XBeeConnectionState::REGISTER_TIMEOUT
    scheduler.step XBeeConnectionState::REGISTER_ATTEMPT_DELAY
    expect(@connection_state.xbee_connection_state).to eq :WAIT_FOR_CONNECTION
  end

  it 'enters internal state :DISCONNECTED when disconnecting during a connect attempt' do
    @connection_state.connect
    scheduler.step XBeeConnectionState::REGISTER_FIRST_ATTEMPT_DELAY
    @connection_state.disconnect
    expect(@connection_state.xbee_connection_state).to eq :DISCONNECTED
  end

  it 'enters internal state :CONNECTED when receiving a connection response in :WAIT_FOR_CONNECTION' do
    @connection_state.connect
    scheduler.step XBeeConnectionState::REGISTER_FIRST_ATTEMPT_DELAY
    @connection_state.xbee_connect_response
    expect(@connection_state.xbee_connection_state).to eq :CONNECTED
  end

  it 'enters state :CONNECTED when connected with a device' do
    @connection_state.connect
    scheduler.step XBeeConnectionState::REGISTER_FIRST_ATTEMPT_DELAY
    @connection_state.xbee_connect_response
    expect(@connection_state.state).to eq ConnectionState::State::CONNECTED
  end

  it 'notifies the listeners when it enters internal state :CONNECTED' do
    expect do |listener|
      @connection_state.when_connection_changed(&listener)
      @connection_state.connect
      scheduler.step XBeeConnectionState::REGISTER_FIRST_ATTEMPT_DELAY
      @connection_state.xbee_connect_response
    end.to yield_with_args @connection_state
  end

  it 'will not timeout when it enters internal state :CONNECTED' do
    @connection_state.connect
    scheduler.step XBeeConnectionState::REGISTER_FIRST_ATTEMPT_DELAY
    @connection_state.xbee_connect_response
    scheduler.step XBeeConnectionState::REGISTER_TIMEOUT
    expect(@connection_state.xbee_connection_state).to eq :CONNECTED
  end

  it 'renews the registration after a successful registration' do
    expect(@connection_state).to receive(:send_message).with(CaretakerMessages::CARETAKER_ADD_LISTENER).twice
    @connection_state.connect
    scheduler.step XBeeConnectionState::REGISTER_FIRST_ATTEMPT_DELAY
    @connection_state.xbee_connect_response
    scheduler.step XBeeConnectionState::REGISTER_LEASE
  end

  it 'doubles the connection delay after each unsuccessful connect attempt' do
    expect(@connection_state).to receive(:send_message).with(CaretakerMessages::CARETAKER_ADD_LISTENER).exactly(4).times
    @connection_state.connect
    scheduler.step XBeeConnectionState::REGISTER_FIRST_ATTEMPT_DELAY
    scheduler.step XBeeConnectionState::REGISTER_TIMEOUT
    scheduler.step XBeeConnectionState::REGISTER_ATTEMPT_DELAY
    scheduler.step XBeeConnectionState::REGISTER_TIMEOUT
    scheduler.step 2 * XBeeConnectionState::REGISTER_ATTEMPT_DELAY
    scheduler.step XBeeConnectionState::REGISTER_TIMEOUT
    scheduler.step 4 * XBeeConnectionState::REGISTER_ATTEMPT_DELAY
    scheduler.step XBeeConnectionState::REGISTER_TIMEOUT
  end

  it 'enters internal state :UNCONNECTED when disconnecting in :CONNECTED' do
    @connection_state.connect
    scheduler.step XBeeConnectionState::REGISTER_FIRST_ATTEMPT_DELAY
    @connection_state.xbee_connect_response
    @connection_state.disconnect
    expect(@connection_state.state).to eq ConnectionState::State::DISCONNECTED
  end

  it 'unregisters from the device when disconnecting' do
    allow(@connection_state).to receive(:send_message)
    expect(@connection_state).to receive(:send_message).with(CaretakerMessages::CARETAKER_REMOVE_LISTENER)
    @connection_state.connect
    scheduler.step XBeeConnectionState::REGISTER_FIRST_ATTEMPT_DELAY
    @connection_state.xbee_connect_response
    @connection_state.disconnect
  end

end
