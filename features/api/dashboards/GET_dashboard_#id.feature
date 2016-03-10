Feature: GET /dashboards/:id
  In order to get full information about a specific dashboard
  as an API user
  I want to get the dashboard

  Scenario: Get an existing dashboard
    Given I am authenticated as a user
    And the following dashboard with id "DASHBOARD_ID":
      | name    | Default |
      | default | true    |
    And I am the owner of that dashboard
    When I send a GET request to "/dashboards/%{DASHBOARD_ID}"
    Then the response status should be "200"
    And the JSON response should be:
      """
      {
        "id": %{DASHBOARD_ID},
        "name": "Default",
        "default": true,
        "user": {
          "id": 1,
          "name": "user"
        },
        "widgets": [
        ]
      }
      """

  Scenario: Get a not existing dashboard
    Given I am authenticated as a user
    When I send a GET request to "/dashboards/-1"
    Then the response status should be "404"

  Scenario: Get a dashboard without being authenticated
    Given a dashboard with id "DASHBOARD_ID"
    When I send a GET request to "/dashboards/%{DASHBOARD_ID}"
    Then the response status should be "401"
