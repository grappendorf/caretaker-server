class WlanMasterSimulator

  def initialize
    @message_listeners = []
  end

  def start
    Rails.logger.info 'WLAN master simualtor starting'

    @devices = {
        '192.168.1.37' =>
            {
                name: 'Switch-8-Port',
                description: '8-Port Switch',
                address: '192.168.1.37',
                states: [1, 0, 1, 1, 1, 0, 1, 1]
            },
        '192.168.1.33' =>
            {
                name: 'Dimmer',
                description: 'Dimmer',
                address: '192.168.1.33',
                value: 100
            }
    }
  end

  def stop
    Rails.logger.info 'WLAN master simulator stopping'
  end

  def send_message address, msg, params = []
    device = @devices[address]
    if device
      case msg
        when CaretakerMessages::SWITCH_WRITE
          set_switch device, params
        when CaretakerMessages::SWITCH_READ
          get_switch device, params
      end
    end
  end

  def when_message_received &block
    @message_listeners << block
  end

  def fire_message_received address, msg, *params
    @message_listeners.each do |l|
      l.call address, msg.to_i, params
    end
  end

  def set_switch device, params
    num = params[0]
    case params[1]
      when CaretakerMessages::WRITE_ABSOLUTE
        device[:states][num] = params[2]
      when CaretakerMessages::WRITE_TOGGLE
        device[:states][num] = 1 - device[:states][num]
    end
    fire_message_received device[:address], CaretakerMessages::SWITCH_STATE, num, device[:states][num]
  end

  def get_switch address, params
    num = params[0]
    fire_message_received address, CaretakerMessages::SWITCH_STATE, num, device[:states][num]
  end

end
