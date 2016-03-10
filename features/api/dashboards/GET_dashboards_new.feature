Feature: GET /dashboards/new
  In order create a new dashboard from its default values
  as an API user
  I want to get a new (unsaved) default dashboard

  Scenario: Get new default dashboard
    Given I am authenticated as a user
    When I send a GET request to "/dashboards/new"
    Then the response status should be "200"
    And the JSON response should be:
      """
      {
        "id": null,
        "name": null,
        "default": null,
        "user": {
          "id": %{CURRENT_USER_ID},
          "name": "%{CURRENT_USER_NAME}"
        },
        "widgets": [
        ]
      }
      """

  Scenario: Get a default dashboard without being authenticated
    When I send a GET request to "/dashboards/new"
    Then the response status should be "401"
