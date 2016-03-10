Feature: GET /buildings/count
  In order to get an overview of all buildings
  as an API building
  I want to get a the building count

  Scenario: Get the number of currently stored buildings
    Given 2 buildings
    And I am authenticated as an administrator
    When I send a GET request to "/buildings/count"
    Then the response status should be "200"
    And the JSON response should be:
      """
      {
        "count": 2
      }
      """

  Scenario: Get the number of buildings without being authenticated
    When I send a GET request to "/buildings/count"
    Then the response status should be "401"
