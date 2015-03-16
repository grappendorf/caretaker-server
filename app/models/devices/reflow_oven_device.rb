# == Schema Information
#
# Table name: reflow_oven_devices
#
#  id :integer          not null, primary key
#

class ReflowOvenDevice < ActiveRecord::Base

  inherit DeviceBase
  include WlanDevice

  acts_as :device

  def self.attr_accessible
    Device.attr_accessible
  end

  def self.small_icon()
    '16/oven.png'
  end

  def self.large_icon()
    '32/oven.png'
  end

  def update
    send_message CaretakerMessages::REFLOW_OVEN_READ
  end

  def message_received message, params
    super
    case message
      when CaretakerMessages::SENSOR_STATE
        if params[0].to_i == CaretakerMessages::SENSOR_TEMPERATURE
          @temperature = { timestamp: Time.now, value: params[1] }
          notify_change_listeners
        end
      when CaretakerMessages::REFLOW_OVEN_STATE
        p params
        @mode = params[0].to_i
        @state = params[1].to_i
        @heater = params[2].to_i != 0
        @fan = params[3].to_i != 0
        notify_change_listeners
    end
  end

  def current_state
    { temperature: @temperature, mode: @mode, state: @state, heater: @heater, fan: @fan }
  end

  def put_state params
    case params['action']
      when 'start'
        send_message CaretakerMessages::REFLOW_OVEN_CMD, CaretakerMessages::REFLOW_OVEN_CMD_START
      when 'off'
        send_message CaretakerMessages::REFLOW_OVEN_CMD, CaretakerMessages::REFLOW_OVEN_CMD_OFF
      when 'cool'
        send_message CaretakerMessages::REFLOW_OVEN_CMD, CaretakerMessages::REFLOW_OVEN_CMD_COOL
      else
        raise InvalidArgumentError
    end
  end

end
