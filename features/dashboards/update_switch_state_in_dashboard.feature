@javascript
Feature: The state of the switches is updated in the dashboard

  Background:

    Given a user with a default dashboard
    And a switch with a widget in the dashboard

  Scenario:

    Given i visit the dashboards
    When the switch is off
    Then it is displayed as off in the dashboard
    When the switch is on
    Then it is displayed as on in the dashboard
