Feature: GET /floors/names
  In order to get short information about the floors
  as an API user
  I want to list their names

  Scenario: Get a list of all floor names
    Given a building with id "BUILDING_ID"
    And the following floor with id "FLOOR_1_ID":
      | name        | Level 1 |
      | description | Base    |
    And the following floor with id "FLOOR_2_ID":
      | name        | Level 2    |
      | description | Production |
    And I am authenticated as an administrator
    When I send a GET request to "/buildings/%{BUILDING_ID}/floors/names"
    Then the response status should be "200"
    And the JSON response should be:
      """
      [
        {
          "id": %{FLOOR_1_ID},
          "name": "Level 1"
        },
        {
          "id": %{FLOOR_2_ID},
          "name": "Level 2"
        }
      ]
      """

  Scenario: Get a list of all floor names when there are no floors
    Given a building with id "BUILDING_ID"
    And I am authenticated as an administrator
    When I send a GET request to "/buildings/%{BUILDING_ID}/floors/names"
    Then the response status should be "200"
    And the JSON response should be:
      """
      []
      """

  Scenario: Get a list of all floor names without being authenticated
    Given a building with id "BUILDING_ID"
    When I send a GET request to "/buildings/%{BUILDING_ID}/floors/names"
    Then the response status should be "401"
