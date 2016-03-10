Feature: GET /floors/count
  In order to get an overview of all floors
  as an API floor
  I want to get a the floor count

  Scenario: Get the number of currently stored floors
    Given a building with id "BUILDING_ID"
    And that building has 2 floors
    And I am authenticated as an administrator
    When I send a GET request to "/buildings/%{BUILDING_ID}/floors/count"
    Then the response status should be "200"
    And the JSON response should be:
      """
      {
        "count": 2
      }
      """

  Scenario: Get the number of floors without being authenticated
    Given a building with id "BUILDING_ID"
    When I send a GET request to "/buildings/%{BUILDING_ID}/floors/count"
    Then the response status should be "401"
