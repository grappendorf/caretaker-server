Feature: GET /dashboards/names
  In order to get short information about the dashboards
  as an API user
  I want to list their names

  Scenario: Get a list of all dashboard names
    And I am authenticated as a user
    And the following dashboard with id "DASHBOARD_1_ID":
      | name    | Default |
      | default | true    |
    And I am the owner of that dashboard
    And the following dashboard with id "DASHBOARD_2_ID":
      | name    | Special |
      | default | false   |
    And I am the owner of that dashboard
    When I send a GET request to "/dashboards/names"
    Then the response status should be "200"
    And the JSON response should be:
      """
      [
        {
          "id": %{DASHBOARD_1_ID},
          "name": "Default",
          "default": true
        },
        {
          "id": %{DASHBOARD_2_ID},
          "name": "Special",
          "default": false
        }
      ]
      """

  Scenario: Get a list of all dashboard names when there are no dashboards
    Given I am authenticated as an administrator
    When I send a GET request to "/dashboards/names"
    Then the response status should be "200"
    And the JSON response should be:
      """
      []
      """

  Scenario: Get a list of all dashboard names without being authenticated
    When I send a GET request to "/dashboards/names"
    Then the response status should be "401"
