class XbeeSim

	register_as :xbeesim

	def self.reload
		load __FILE__
	end

	def self.method_missing name, *args
		@@instance.send name, *args
	end

	def initialize
		@@instance = self

		@push_read_bytes_mutex = Mutex.new

		# TODO: Initialize devices from the database
		@devices = {
				[0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01] =>
						{
								name: 'Switch',
								address16: [0x79, 0x38],
								states: [0]
						},
				[0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02] =>
						{
								name: '8-Port Switch',
								address16: [0x79, 0x38],
								states: [1, 0, 1, 1, 1, 0, 1, 1]
						},
				[0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03] =>
						{
								name: 'Dimmer',
								address16: [0x79, 0x38],
								value: 100
						},
				[0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04] =>
						{
								name: 'Dimmer RGB',
								address16: [0x79, 0x38],
								red: 50,
								green: 100,
								blue: 200
						},
				[0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05] =>
						{
								name: 'Camera 1',
								address16: [0x79, 0x38]
						},
				[0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x06] =>
						{
								name: 'Camera 2',
								address16: [0x79, 0x38]
						},
				[0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x07] =>
						{
								name: 'Reflow Oven',
								address16: [0x79, 0x38]
						},
		}

		@read_buffer = Queue.new

	end

	def write bytes
		data = XBeeRuby::Packet.from_bytes(bytes.unpack 'C*').data
		case data[0]
			when 0x10 # TxRequest
				tx_response data
				case data[14]
					when CoYoHoMessages::COYOHO_ADD_LISTENER
						rx_response_listener_added data
					when CoYoHoMessages::COYOHO_SWITCH_READ
						rx_response_switch_read data
					when CoYoHoMessages::COYOHO_SWITCH_WRITE
						rx_response_switch_write data
					when CoYoHoMessages::COYOHO_PWM_READ
						rx_response_pwm_read data
					when CoYoHoMessages::COYOHO_RGB_READ
						rx_response_rgb_read data
					when CoYoHoMessages::COYOHO_RGB_WRITE
						rx_response_rgb_write data
				end
		end
	end

	def push_read_bytes bytes
		@push_read_bytes_mutex.synchronize do
			bytes.each { |b| @read_buffer.push b }
		end
	end

	def readbyte
		@read_buffer.pop
	end

	def flush
	end

	def close
		#@ctl_thread.terminate
	end

	def tx_response data
		device = @devices[data[2..9]]
		push_read_bytes XBeeRuby::Packet.new([0x8b, data[1], device[:address16][0], device[:address16][1], 0, 0, 0]).bytes_escaped
	end

	def rx_response_listener_added data
		device = @devices[data[2..9]]
		push_read_bytes XBeeRuby::Packet.new([0x90] + data[2..9] + [device[:address16][0], device[:address16][1], 0x01, CoYoHoMessages::COYOHO_ADD_LISTENER|CoYoHoMessages::COYOHO_MESSAGE_RESPONSE]).bytes_escaped
	end

	def device_by_name name
		@devices.find { |_, device| device[:name] == name }
	end

	def rx_response_switch_read data
		device = @devices[data[2..9]]
		switch_num = data[15]
		msg = [CoYoHoMessages::COYOHO_SWITCH_READ|CoYoHoMessages::COYOHO_MESSAGE_RESPONSE, switch_num, device[:states][switch_num]]
		push_read_bytes XBeeRuby::Packet.new([0x90] + data[2..9] + device[:address16] + [0x01] + msg).bytes_escaped
	end

	def rx_response_switch_write data
		set_switch @devices[data[2..9]][:name], data[15], data[17]
	end

	def set_switch name, num, state
		address64, device = device_by_name(name)
		device[:states][num] = state
		msg = [CoYoHoMessages::COYOHO_SWITCH_READ|CoYoHoMessages::COYOHO_MESSAGE_NOTIFY, num, device[:states][num]]
		push_read_bytes XBeeRuby::Packet.new([0x90] + address64 + device[:address16] + [0x01] + msg).bytes_escaped
	end

	def get_switch name
		_, device = device_by_name(name)
		device[:states]
	end

	def rx_response_pwm_read data
		device = @devices[data[2..9]]
		pwm_num = data[15]
		msg = [CoYoHoMessages::COYOHO_PWM_READ|CoYoHoMessages::COYOHO_MESSAGE_RESPONSE, pwm_num, device[:value]]
		push_read_bytes XBeeRuby::Packet.new([0x90] + data[2..9] + device[:address16] + [0x01] + msg).bytes_escaped
	end

	def rx_response_pwm_write data
		set_dimmer @devices[data[2..9]][:name], data[17]
	end

	def set_dimmer name, value
		address64, device = device_by_name(name)
		device[:value] = value
		pwm_num = 0
		msg = [CoYoHoMessages::COYOHO_PWM_READ|CoYoHoMessages::COYOHO_MESSAGE_NOTIFY, pwm_num, device[:value]]
		push_read_bytes XBeeRuby::Packet.new([0x90] + address64 + device[:address16] + [0x01] + msg).bytes_escaped
	end

	def get_dimmer name
		_, device = device_by_name(name)
		device[:value]
	end

	def rx_response_rgb_read data
		device = @devices[data[2..9]]
		rgb_num = 0
		msg = [CoYoHoMessages::COYOHO_RGB_READ|CoYoHoMessages::COYOHO_MESSAGE_RESPONSE, rgb_num, device[:red], device[:green], device[:blue]]
		push_read_bytes XBeeRuby::Packet.new([0x90] + data[2..9] + device[:address16] + [0x01] + msg).bytes_escaped
	end

	def rx_response_rgb_write data
		set_dimmer_rgb @devices[data[2..9]][:name], data[17], data[18], data[19]
	end

	def set_dimmer_rgb name, red, green, blue
		address64, device = device_by_name(name)
		device[:red], device[:green], device[:blue] = red, green, blue
		rgb_num = 0
		msg = [CoYoHoMessages::COYOHO_RGB_READ|CoYoHoMessages::COYOHO_MESSAGE_NOTIFY, rgb_num, device[:red], device[:green], device[:blue]]
		push_read_bytes XBeeRuby::Packet.new([0x90] + address64 + device[:address16] + [0x01] + msg).bytes_escaped
	end

	def get_dimmer_rgb name
		_, device = device_by_name(name)
		[device[:red], device[:green], device[:blue]]
	end
end