@javascript
Feature: Users can manage their dashboards

	Background:

		Given a user with a default dashboard

	Scenario: Creating a new dashboard

		When i visit the dashboards
		And i click on the button "New dashboard"
		And i enter "New Dashboard" into "Name"
		And i click on the button "Create dashboard"
		Then i see "Your dashboard is currently empty"

	Scenario: Selecting a dashboard

		Given another dashboard
		When i visit the dashboards
		And i click on the dashboards dropdown
		And i click on the other dashboards dropdown item
		Then i see the other dashboard

	Scenario: Renaming a dashboard

		When i visit the dashboards
		And i click on the dashboard properties button
		And i enter "New name" into "Name"
		And i click on the button "Save"
		Then the dashboard name changed to "New name"

	Scenario: Deleting a dashboard

		Given another dashboard which is currenly displayed
		When i click on the button "Delete dashboard"
		Then i see a confirmation dialog
		When i click on the button "Yes"
		Then the other dashboard is removed from the dashboard list
		And the default dashboard is displayed

	Scenario: Dashboard management view

		When i visit the dashboards
		And i click on the dashboard management button
		Then i see the dashboard management view
