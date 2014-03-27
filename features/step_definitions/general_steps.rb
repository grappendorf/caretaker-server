When /^i log in$/ do
	sign_in_as :user
end

When(/^i click the link "(.*?)"$/) do |text|
	click_link text
end

When(/^i click on the button "(.*?)"$/) do |text|
	click_button text
end

Then(/^i see a dialog titled "(.*?)"$/) do |title|
	page.should have_selector 'div.modal div.modal-header', text: title
end

When(/^i enter "(.*?)" into "(.*?)"$/) do |value, field|
	fill_in field, with: value
end

Then(/^i see "([^"]*)"$/) do |text|
	page.should have_content text
end

Then(/^i see a confirmation dialog$/) do
	page.should have_selector 'div.modal div.modal-header', text: 'confirm'
end