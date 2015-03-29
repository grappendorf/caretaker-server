# == Schema Information
#
# Table name: sensor_devices
#
#  id      :integer          not null, primary key
#  sensors :text
#

class SensorDevice < ActiveRecord::Base

  inherit DeviceBase
  include WlanDevice

  acts_as :device

  # [{ type: <sensor-type>, min: minimum value, max: maximum value }, ...]
  serialize :sensors

  def self.attr_accessible
    Device.attr_accessible
  end

  def self.small_icon()
    '16/thermometer.png'
  end

  def self.large_icon()
    '32/thermometer.png'
  end

  def update_attributes_from_registration params
    num_sensors = params[0].to_i
    sensor_defs = params[1..-1].in_groups_of(3).take num_sensors
    update_attributes sensors: sensor_defs.each_with_index.map { |d| { type: d[0].to_i, min: d[1].to_i, max: d[2].to_i } }
  end

  def states
    @states ||= Array.new(sensors.count, 0.0)
  end

  def update
  end

  def message_received message, params
    super
    if message == CaretakerMessages::SENSOR_STATE
      params.in_groups_of(2).each do |num, value|
        states[num.to_i] = value.to_f
      end
      notify_change_listeners
    end
  end

  def current_state
    states
  end

end
