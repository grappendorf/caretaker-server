Feature: GET /floors/:id
  In order to get full information about a specific floor
  as an API user
  I want to get the floor

  Scenario: Get an existing floor
    Given a building with id "BUILDING_ID"
    And that building has the following floor with id "FLOOR_ID":
      | name        | Level 1 |
      | description | Base    |
    And I am authenticated as an administrator
    When I send a GET request to "/buildings/%{BUILDING_ID}/floors/%{FLOOR_ID}"
    Then the response status should be "200"
    And the JSON response should be:
      """
      {
        "id": %{FLOOR_ID},
        "name": "Level 1",
        "description": "Base"
      }
      """

  Scenario: Get a not existing floor
    Given a building with id "BUILDING_ID"
    And I am authenticated as an administrator
    When I send a GET request to "/buildings/%{BUILDING_ID}/floors/-1"
    Then the response status should be "404"

  Scenario: Get a floor without being authenticated
    Given a building with id "BUILDING_ID"
    And that building has a floor with id "FLOOR_ID"
    When I send a GET request to "/buildings/%{BUILDING_ID}/floors/%{FLOOR_ID}"
    Then the response status should be "401"
