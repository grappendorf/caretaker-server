def create_another_dashboard
  @other_dashboard = Fabricate :dashboard, user: @user
end

def create_switch_device
  unless @device
    @device = Fabricate :switch_device
    lookup(:device_manager).add_device @device
    lookup(:scheduler).travel 1.minute
  end
end

Given /^a user with a default dashboard$/ do
  @user = Fabricate :user
  @dashboard = @user.dashboards.default
end

Then /^i see the dashboard$/ do
  page.should have_content @dashboard.name
end

Given /^a switch device$/ do
  create_switch_device
end

Given /^a switch with a widget in the dashboard$/ do
  create_switch_device
  @dashboard.widgets << Fabricate(:device_widget, device: @device)
end

When /^i visit the dashboards$/ do
  sign_in_as :user
  visit default_dashboards_path
end

When /^the switch is off$/ do
end

Then /^it is displayed as off in the dashboard$/ do
  page.should have_selector 'td.off'
end

When /^the switch is on$/ do
end

Then /^it is displayed as on in the dashboard$/ do
  page.should have_selector 'td.on'
end

And(/^i select the switch device in "(.*?)"$/) do |field|
  fill_in 'Select the device to display in the widget', with: @device.name
  find('#widget_device + ul li.active').click
end

And(/^i click on the dashboard properties button$/) do
  click_button 'dashboardProperties'
end

Then(/^the dashboard name changed to "(.*?)"$/) do |name|
  should_not have_selector '#dashboards', text: @dashboard.name
  should have_selector '#dashboards', text: name
end

Then(/^i see "Your dashboard "New Dashboard" is currently empty"$/) do
  page.should have_content 'Your dashboard "New Dashboard" is currently empty'
end

Given(/^another dashboard$/) do
  create_another_dashboard
end

Given(/^another dashboard which is currenly displayed$/) do
  create_another_dashboard
  sign_in_as :user
  visit dashboard_path(@other_dashboard)
end

Then(/^the other dashboard is removed from the dashboard list$/) do
  should_not have_selector '#dashboards', text: @other_dashboard.name
end

And(/^the default dashboard is displayed$/) do
  should have_selector '#dashboards', text: @dashboard.name
end

And(/^i click on the dashboards dropdown$/) do
  click_button 'dashboards'
end

And(/^i click on the other dashboards dropdown item$/) do
  click_link @other_dashboard.name
end

Then(/^i see the other dashboard$/) do
  should have_selector '#dashboards', text: @other_dashboard.name
end

Then(/^i see a widget titled "(.*?)"$/) do |title|
  page.should have_selector '.panel-heading', text: title
end

And(/^i click on the delete button in the switch widget$/) do
  find('.panel-heading', text: @device.name).find('.fa-times-circle').click
end

Then(/^i see a widget showing the switch device$/) do
  page.should have_selector '.panel-heading', text: @device.name
end

Then(/^i don't see a widget showing the switch device$/) do
  page.should_not have_selector '.panel-heading', text: @device.name
end

And(/^i click on the properties button in the switch widget$/) do
  find('.panel-heading', text: @device.name).find('.fa-pencil-square').click
end

And(/^i click on the dashboard management button$/) do
  click_link 'dashboardManagement'
end

Then(/^i see the dashboard management view$/) do
  page.should have_content 'Dashboards'
  page.should have_selector 'th', text: 'Name'
  page.should have_selector 'th', text: 'User'
  page.should have_selector 'th', text: 'Default'
end

When(/^the switch is unconnected$/) do
  lookup(:device_manager).device_by_id(@device.id).disconnect
end

Then(/^it is displayed as unconnected in the dashboard$/) do
  page.should have_selector '.panel-heading .fa-square-o'
end

When(/^the switch is connected$/) do
  lookup(:device_manager).device_by_id(@device.id).connect
  lookup(:scheduler).travel 1.minute
end

Then(/^it is displayed as connected in the dashboard$/) do
  page.should have_selector '.panel-heading .fa-flash'
end