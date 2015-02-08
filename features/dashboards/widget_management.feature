@javascript
Feature: The user can add, remove and manipulate the dashborad widgets

  Background:

    Given a user with a default dashboard

  Scenario: Creating a new widget for the switch device

    Given a switch device
    When i visit the dashboards
    And i click on the button "Add widget"
    Then i see a dialog titled "Add widget"
    When i select the switch device in "Select the device to display in the widget"
    And i click on the button "Create widget"
    Then i see a widget showing the switch device

  Scenario: Creating a new widget for the switch device with a widget title

    Given a switch device
    When i visit the dashboards
    And i click on the button "Add widget"
    Then i see a dialog titled "Add widget"
    When i select the switch device in "Select the device to display in the widget"
    And i enter "Switch widget" into "Choose an optional widget title"
    And i click on the button "Create widget"
    Then i see a widget titled "Switch widget"

  Scenario: Deleting a widget

    Given a switch with a widget in the dashboard
    When i visit the dashboards
    And i click on the delete button in the switch widget
    Then i don't see a widget showing the switch device

  Scenario: Renaming the title of a widget

    Given a switch with a widget in the dashboard
    When i visit the dashboards
    And i click on the properties button in the switch widget
    And i enter "Switch widget" into "Title"
    And i click on the button "Save"
    Then i see a widget titled "Switch widget"
