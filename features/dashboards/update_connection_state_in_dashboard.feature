@javascript
Feature: The connection state of the devices is updated in the dashboard

  Background:

    Given a user with a default dashboard
    And a switch with a widget in the dashboard

  Scenario:

    Given i visit the dashboards
    When the switch is unconnected
    Then it is displayed as unconnected in the dashboard
    When the switch is connected
    Then it is displayed as connected in the dashboard
