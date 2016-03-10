Feature: GET /widgets/new
  In order create a new widget from its default values
  as an API user
  I want to get a new (unsaved) default widget

  Scenario: Get new default widget
    Given I am authenticated as a user
    And a dashboard with id "DASHBOARD_ID"
    And I am the owner of that dashboard
    When I send a GET request to "/dashboards/%{DASHBOARD_ID}/clock_widgets/new"
    Then the response status should be "200"
    And the JSON response should be:
      """
      {
         "id": null,
         "type": "NilClass",
         "title": null,
         "height": 1,
         "width": 1,
         "position": null
      }
      """

  Scenario: Get a default widget without being authenticated
    Given a dashboard with id "DASHBOARD_ID"
    When I send a GET request to "/dashboards/%{DASHBOARD_ID}/clock_widgets/new"
    Then the response status should be "401"
