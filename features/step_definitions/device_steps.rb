Given /^this device is managed by the device manager$/ do
  @current_device = Device.last.specific
  allow(@current_device).to receive(:stop) do
    @current_device.instance_variable_set :@test_device_was_stopped, true
  end
  lookup(:device_manager).add_device @current_device
end

Then /^the device should be stopped$/ do
  expect(@current_device.instance_variable_get :@test_device_was_stopped).to be_truthy,
    -> { 'expected the device to be stopped, but it wasn\'t' }
end
