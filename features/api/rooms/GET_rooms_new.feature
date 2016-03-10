Feature: GET /rooms/new
  In order create a new room from its default values
  as an API user
  I want to get a new (unsaved) default room

  Scenario: Get new default room
    Given a building with id "BUILDING_ID"
    And that building has a floor with id "FLOOR_ID"
    Given I am authenticated as an administrator
    When I send a GET request to "/buildings/%{BUILDING_ID}/floors/%{FLOOR_ID}/rooms/new"
    Then the response status should be "200"
    And the JSON response should be:
      """
      {
        "id": null,
        "number": null,
        "description": null
      }
      """

  Scenario: Get a default room without being authenticated
    Given a building with id "BUILDING_ID"
    And that building has a floor with id "FLOOR_ID"
    When I send a GET request to "/buildings/%{BUILDING_ID}/floors/%{FLOOR_ID}/rooms/new"
    Then the response status should be "401"
