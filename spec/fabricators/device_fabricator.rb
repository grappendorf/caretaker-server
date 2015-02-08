# == Schema Information
#
# Table name: devices
#
#  id             :integer          not null, primary key
#  as_device_id   :integer
#  as_device_type :string(255)
#  name           :string(255)
#  address        :string(255)
#  description    :string(255)
#

Fabricator :device do
  name 'Device'
  address '00:11:22:33:44:55'
  description 'A generic device'
end

Fabricator :switch_device do
  name 'Switch'
  address '0000000000000001'
  description 'Lot\'s of switches'
  num_switches 1
  switches_per_row 1
end

Fabricator :camera_device do
  name 'Camera 1'
  address '0000000000000005'
  description '..+++###'
  host '127.0.0.1'
  port 80
  user 'user'
  password 'password'
  refresh_interval 60
end

Fabricator :ip_camera_device do
  name 'Camera 2'
  address '0000000000000006'
  description '..+++###'
  host '127.0.0.1'
  port 80
  user 'user'
  password 'password'
  refresh_interval 60
end

Fabricator :dimmer_device do
  name 'Dimmer Device'
  address '0000000000000003'
  description '..+++###'
end

Fabricator :dimmer_rgb_device do
  name 'Dimmer RGB Device'
  address '0000000000000004'
  description '..+++###'
end

Fabricator :easyvr_device do
  name 'EasyVR Device'
  address '0000000000000008'
  description '..+++###'
  num_buttons 10
  buttons_per_row 5
end

Fabricator :remote_control_device do
  name 'Remote Control Device'
  address '0000000000000009'
  description '-~-~-~>>>'
  num_buttons 10
  buttons_per_row 5
end

Fabricator :robot_device do
  name 'Robot Device'
  address '000000000000000A'
  description 'A robot'
end
