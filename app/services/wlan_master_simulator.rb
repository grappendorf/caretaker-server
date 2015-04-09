class WlanMasterSimulator

  def initialize
    @message_listeners = []
  end

  def start
    Rails.logger.info 'WLAN master simualtor starting'

    # noinspection RubyStringKeysInHashInspection
    @devices = {
        '192.168.1.1' =>
            {
                name: 'Switch 1-Port',
                states: [0]
            },
        '192.168.1.2' =>
            {
                name: 'Switch 8-Port',
                states: [1, 0, 1, 1, 1, 0, 1, 1]
            },
        '192.168.1.3' =>
            {
                name: 'Dimmer',
                value: 100
            },
        '192.168.1.4' =>
            {
                name: 'Dimmer RGB',
                red: 50,
                green: 100,
                blue: 200
            },
        '192.168.1.7' =>
            {
                name: 'Knob',
                value: 50
            }
    }
    @devices.each{|address,device| device[:address] = address}

    Thread.new do
      begin
        delta_rotary = 4
        loop do
          5.times do
            fire_message_received '192.168.1.7', CaretakerMessages::ROTARY_STATE, @devices['192.168.1.7'][:value]
            @devices['192.168.1.7'][:value] += delta_rotary
            if @devices['192.168.1.7'][:value] > 255
              @devices['192.168.1.7'][:value] = 255
              delta_rotary = -4
            elsif @devices['192.168.1.7'][:value] < 0
              @devices['192.168.1.7'][:value] = 0
              delta_rotary = 4
            end
            sleep 1
          end
          fire_message_received '192.168.1.5', CaretakerMessages::SENSOR_STATE,
              0, (rand(11500) - 3000) / 100, 1, rand(100000) / 100
        end
      rescue => x
        puts x
        puts x.backtrace.join "\n"
      end
    end
  end

  def stop
    Rails.logger.info 'WLAN master simulator stopping'
  end

  def send_message address, msg, params = []
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
      l.call address, msg.to_i, params
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
    device[:value] = params[0].to_i
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
    get_rgb address, params
  end

end
