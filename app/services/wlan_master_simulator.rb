class WlanMasterSimulator
  def initialize
    @message_listeners = []
  end

  def start
    Grape::API.logger.info 'WLAN master simualtor starting'
    @devices = {}
    add_device '192.168.1.1', { states: [0] }
    add_device '192.168.1.2', { states: [0, 0, 0, 0, 0, 0, 0, 0] }
    add_device '192.168.1.3', { value: 64 }
    add_device '192.168.1.4', { red: 50, green: 100, blue: 200 }
    add_device '192.168.1.5', {}
    add_device '192.168.1.6', { states: [0, 0, 0, 0, 0, 0, 0, 0] }
    add_device '192.168.1.7', { value: 192 }

    Thread.new do
      loop do
        sleep 5
        fire_message_received '192.168.1.5', CaretakerMessages::SENSOR_STATE,
          0, (rand(11500) - 3000) / 100,
          1, rand(100000) / 100
      end
    end
  end

  def stop
    Grape::API.logger.info 'WLAN master simulator stopping'
  end

  # Examples:
  #
  # add_device '192.168.1.1', { name: 'Switch 1-Port', states: [0] }
  #
  # add_device '192.168.1.4', { name: 'Dimmer RGB', red: 50, green: 100, blue: 200 }
  #
  def add_device address, config
    @devices[address] = config
    config[:address] = address
  end

  def send_message address, port, msg, params = []
    device = @devices[address]
    if device
      # noinspection RubyCaseWithoutElseBlockInspection
      case msg
        when CaretakerMessages::SWITCH_READ
          get_switch device, params
        when CaretakerMessages::SWITCH_WRITE
          set_switch device, params
        when CaretakerMessages::PWM_READ
          get_pwm device, params
        when CaretakerMessages::PWM_WRITE
          set_pwm device, params
        when CaretakerMessages::ROTARY_READ
          get_rotary device, params
        when CaretakerMessages::ROTARY_WRITE
          set_rotary device, params
        when CaretakerMessages::RGB_READ
          get_rgb device, params
        when CaretakerMessages::RGB_WRITE
          set_rgb device, params
      end
    end
  end

  def when_message_received &block
    @message_listeners << block
  end

  def fire_message_received address, msg, *params
    @message_listeners.each do |l|
      l.call address, Application.config.device_port, msg.to_i, params
    end
  end

  def get_switch device, params
    num = params[0]
    fire_message_received device[:address], CaretakerMessages::SWITCH_STATE, num, device[:states][num]
  end

  def set_switch device, params
    num = params[0]
    # noinspection RubyCaseWithoutElseBlockInspection
    case params[1]
      when CaretakerMessages::WRITE_ABSOLUTE
        device[:states][num] = params[2]
      when CaretakerMessages::WRITE_TOGGLE
        device[:states][num] = 1 - device[:states][num]
    end
    get_switch device, params
  end

  def get_pwm device, _params
    fire_message_received device[:address], CaretakerMessages::PWM_STATE, device[:value]
  end

  def set_pwm device, params
    # noinspection RubyCaseWithoutElseBlockInspection
    case params[0]
      when CaretakerMessages::WRITE_ABSOLUTE
        device[:value] = params[1]
    end
    get_pwm device, params
  end

  def get_rotary device, _params
    fire_message_received device[:address], CaretakerMessages::ROTARY_STATE, device[:value]
  end

  def set_rotary device, params
    # noinspection RubyCaseWithoutElseBlockInspection
    case params[0]
      when CaretakerMessages::WRITE_ABSOLUTE
        device[:value] = params[1]
    end
    get_rotary device, params
  end

  def get_rgb device, _params
    fire_message_received device[:address], CaretakerMessages::RGB_STATE, device[:red], device[:green], device[:blue]
  end

  def set_rgb device, params
    # noinspection RubyCaseWithoutElseBlockInspection
    case params[0]
      when CaretakerMessages::WRITE_ABSOLUTE
        device[:red] = params[1]
        device[:green] = params[2]
        device[:blue] = params[3]
    end
    get_rgb device, params
  end
end
