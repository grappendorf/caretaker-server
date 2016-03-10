Given /^the device script is currently enabled$/ do
  DeviceScript.last.update_attribute :enabled, true
end

Given /^the device script is currently disabled$/ do
  DeviceScript.last.update_attribute :enabled, false
end

Then /^the device script is now enabled$/ do
  expect(DeviceScript.last).to be_enabled
end

Then /^the device script is now disabled$/ do
  expect(DeviceScript.last).not_to be_enabled
end
