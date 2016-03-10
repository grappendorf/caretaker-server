Feature: GET /dashboards
  In order to get information about the dashboards
  as an API user
  I want to list them

  Scenario: Get a list of all dashboards
    Given I am authenticated as a user
    And the following dashboard with id "DASHBOARD_1_ID":
      | name    | Default |
      | default | true    |
    And I am the owner of that dashboard
    And the following dashboard with id "DASHBOARD_2_ID":
      | name    | Special |
      | default | false   |
    And I am the owner of that dashboard
    When I send a GET request to "/dashboards"
    Then the response status should be "200"
    And the JSON response should be:
      """
      [
        {
          "id": %{DASHBOARD_1_ID},
          "name": "Default",
          "default": true,
          "user": {
            "id": 1,
            "name": "user"
          }
        },
        {
          "id": %{DASHBOARD_2_ID},
          "name": "Special",
          "default": false,
          "user": {
            "id": 1,
            "name": "user"
          }
        }
      ]
      """

  Scenario: Get a list of all dashboards when there are no dashboards
    Given I am authenticated as a user
    When I send a GET request to "/dashboards"
    Then the response status should be "200"
    And the JSON response should be:
      """
      []
      """

  Scenario: Get a list of all dashboards without being authenticated
    When I send a GET request to "/dashboards"
    Then the response status should be "401"
