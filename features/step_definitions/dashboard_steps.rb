Given /^I am the owner of that dashboard$/ do
  Dashboard.last.user = @current_user
end

Given /^I am the owner of these dashboards$/ do
  Dashboard.all.each {|d| d.user = @current_user }
end
