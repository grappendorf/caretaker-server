Feature: DELETE /widgets/:id
  In order to remove superfluous widgets
  as an API user
  I want to delete an existing widget

  Scenario: Delete an existing widget
    Given I am authenticated as a user
    And a dashboard with id "DASHBOARD_ID"
    And that dashboard has a clock_widget with id "WIDGET_ID"
    And I am the owner of that dashboard
    When I send a DELETE request to "/dashboards/%{DASHBOARD_ID}/widgets/%{WIDGET_ID}"
    Then the response status should be "204"
    And I should see 0 widgets in the database

  Scenario: Delete a not existing widget
    Given I am authenticated as a user
    And a dashboard with id "DASHBOARD_ID"
    When I send a DELETE request to "/dashboards/%{DASHBOARD_ID}/widgets/-1"
    Then the response status should be "404"

  Scenario: Delete a widget without being authenticated
    Given a dashboard with id "DASHBOARD_ID"
    And that dashboard has a clock_widget with id "WIDGET_ID"
    When I send a DELETE request to "/dashboards/%{DASHBOARD_ID}/widgets/%{WIDGET_ID}"
    Then the response status should be "401"
