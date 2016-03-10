Feature: GET /floors
  In order to get information about the floors
  as an API user
  I want to list them

  Scenario: Get a list of all floors
    Given a building with id "BUILDING_ID"
    And that building has the following floor with id "FLOOR_1_ID":
      | name        | Level 1 |
      | description | Base    |
    And that building has the following floor with id "FLOOR_2_ID":
      | name        | Level 2    |
      | description | Production |
    And I am authenticated as an administrator
    When I send a GET request to "/buildings/%{BUILDING_ID}/floors"
    Then the response status should be "200"
    And the JSON response should be:
      """
      [
        {
          "id": %{FLOOR_1_ID},
          "name": "Level 1",
          "description": "Base"
        },
        {
          "id": %{FLOOR_2_ID},
          "name": "Level 2",
          "description": "Production"
        }
      ]
      """

  Scenario: Get a list of all floors when there are no floors
    Given a building with id "BUILDING_ID"
    And I am authenticated as an administrator
    When I send a GET request to "/buildings/%{BUILDING_ID}/floors"
    Then the response status should be "200"
    And the JSON response should be:
      """
      []
      """

  Scenario: Get a list of all floors without being authenticated
    Given a building with id "BUILDING_ID"
    When I send a GET request to "/buildings/%{BUILDING_ID}/floors"
    Then the response status should be "401"
