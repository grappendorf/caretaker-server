Feature: DELETE /dashboards/:id
  In order to remove superfluous dashboards
  as an API user
  I want to delete an existing dashboard

  Scenario: Delete an existing dashboard
    Given I am authenticated as a user
    And a dashboard with id "DASHBOARD_ID"
    And I am the owner of that dashboard
    When I send a DELETE request to "/dashboards/%{DASHBOARD_ID}"
    Then the response status should be "204"
    And I should see 0 dashboards in the database

  Scenario: Delete a not existing dashboard
    And I am authenticated as a user
    When I send a DELETE request to "/dashboards/-1"
    Then the response status should be "404"

  Scenario: Delete a dashboard without being authenticated
    Given a dashboard with id "DASHBOARD_ID"
    When I send a DELETE request to "/dashboards/%{DASHBOARD_ID}"
    Then the response status should be "401"
