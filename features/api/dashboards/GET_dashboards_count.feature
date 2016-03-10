Feature: GET /dashboards/count
  In order to get an overview of all dashboards
  as an API dashboard
  I want to get a the dashboard count

  Scenario: Get the number of currently stored dashboards
    Given I am authenticated as a user
    And 2 dashboards
    And I am the owner of these dashboards
    When I send a GET request to "/dashboards/count"
    Then the response status should be "200"
    And the JSON response should be:
      """
      {
        "count": 2
      }
      """

  Scenario: Get the number of dashboards without being authenticated
    When I send a GET request to "/dashboards/count"
    Then the response status should be "401"
