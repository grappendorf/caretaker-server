Feature: GET /widgets
  In order to get information about the widgets
  as an API user
  I want to list them

  Scenario: Get a list of all widgets
    Given I am authenticated as a user
    And a dashboard with id "DASHBOARD_ID"
    And that dashboard has the following clock_widget with id "WIDGET_1_ID":
      | title | UTC |
    And that dashboard has the following clock_widget with id "WIDGET_2_ID":
      | title | EDT |
    And I am the owner of that dashboard
    When I send a GET request to "/dashboards/%{DASHBOARD_ID}/widgets"
    Then the response status should be "200"
    And the JSON response should be:
      """
      [
        {
          "id": %{WIDGET_1_ID},
          "type": "ClockWidget",
          "title": "UTC",
          "height": 1,
          "width": 1,
          "position": 1
        },
        {
          "id": %{WIDGET_2_ID},
          "type": "ClockWidget",
          "title": "EDT",
          "height": 1,
          "width": 1,
          "position": 2
        }
      ]
      """

  Scenario: Get a list of all widgets when there are no widgets
    Given I am authenticated as a user
    And a dashboard with id "DASHBOARD_ID"
    And I am the owner of that dashboard
    When I send a GET request to "/dashboards/%{DASHBOARD_ID}/widgets"
    Then the response status should be "200"
    And the JSON response should be:
      """
      []
      """

  Scenario: Get a list of all widgets without being authenticated
    Given a dashboard with id "DASHBOARD_ID"
    When I send a GET request to "/dashboards/%{DASHBOARD_ID}/widgets"
    Then the response status should be "401"
