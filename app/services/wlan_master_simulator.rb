class WlanMasterSimulator

  def initialize
    @message_listeners = []
  end

  def start
    Rails.logger.info 'WLAN master simualtor starting'

    @devices = {
        '192.168.1.1' =>
            {
                name: 'Switch 1-Port',
                address: '192.168.1.1',
                states: [0]
            },
        '192.168.1.2' =>
            {
                name: 'Switch 8-Port',
                address: '192.168.1.2',
                states: [1, 0, 1, 1, 1, 0, 1, 1]
            },
        '192.168.1.3' =>
            {
                name: 'Dimmer',
                address: '192.168.1.3',
                value: 100
            }
    }

    Thread.new do
      loop do
        fire_message_received '192.168.1.5', CaretakerMessages::SENSOR_STATE,
            0, (rand(11500) - 3000) / 100, 1, rand(100000) / 100
        sleep 5
      end
    end
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
        when CaretakerMessages::PWM_WRITE
          set_pwm device, params
        when CaretakerMessages::PWM_READ
          get_pwm device, params
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

  def set_pwm device, params
    case params[0]
      when CaretakerMessages::WRITE_ABSOLUTE
        device[:value] = params[1]
    end
    fire_message_received device[:address], CaretakerMessages::PWM_STATE, device[:value]
  end

  def get_pwm address, params
    fire_message_received device[:address], CaretakerMessages::PWM_STATE, device[:value]
  end

end
