Feature: GET /widgets/count
  In order to get an overview of all widgets
  as an API widget
  I want to get a the widget count

  Scenario: Get the number of currently stored widgets
    Given I am authenticated as a user
    And a dashboard with id "DASHBOARD_ID"
    And that dashboard has 2 widgets
    And I am the owner of that dashboard
    When I send a GET request to "/dashboards/%{DASHBOARD_ID}/widgets/count"
    Then the response status should be "200"
    And the JSON response should be:
      """
      {
        "count": 2
      }
      """

  Scenario: Get the number of widgets without being authenticated
    Given a dashboard with id "DASHBOARD_ID"
    When I send a GET request to "/dashboards/%{DASHBOARD_ID}/widgets/count"
    Then the response status should be "401"
