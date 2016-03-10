Feature: GET /widgets/:id
  In order to get full information about a specific widget
  as an API user
  I want to get the widget

  Scenario: Get an existing widget
    Given I am authenticated as a user
    And a dashboard with id "DASHBOARD_ID"
    And that dashboard has a clock_widget with id "WIDGET_ID"
    And I am the owner of that dashboard
    When I send a GET request to "/dashboards/%{DASHBOARD_ID}/widgets/%{WIDGET_ID}"
    Then the response status should be "200"
    And the JSON response should be:
      """
      {
        "id": %{WIDGET_ID},
        "type": "ClockWidget",
        "title": "Clock",
        "height": 1,
        "width": 1,
        "position": 1
      }
      """

  Scenario: Get a not existing widget
    Given I am authenticated as a user
    And a dashboard with id "DASHBOARD_ID"
    And I am the owner of that dashboard
    When I send a GET request to "/dashboards/%{DASHBOARD_ID}/widgets/-1"
    Then the response status should be "404"

  Scenario: Get a widget without being authenticated
    Given a dashboard with id "DASHBOARD_ID"
    And that dashboard has a widget with id "WIDGET_ID"
    When I send a GET request to "/dashboards/%{DASHBOARD_ID}/widgets/%{WIDGET_ID}"
    Then the response status should be "401"
