Feature: GET /rooms/:id
  In order to get full information about a specific room
  as an API user
  I want to get the room

  Scenario: Get an existing room
    Given a building with id "BUILDING_ID"
    And that building has a floor with id "FLOOR_ID"
    And that floor has the following room with id "ROOM_ID":
      | number      | 1.100        |
      | description | Meeting room |
    And I am authenticated as an administrator
    When I send a GET request to "/buildings/%{BUILDING_ID}/floors/%{FLOOR_ID}/rooms/%{ROOM_ID}"
    Then the response status should be "200"
    And the JSON response should be:
      """
      {
        "id": %{ROOM_ID},
        "number": "1.100",
        "description": "Meeting room"
      }
      """

  Scenario: Get a not existing room
    Given a building with id "BUILDING_ID"
    And that building has a floor with id "FLOOR_ID"
    And I am authenticated as an administrator
    When I send a GET request to "/buildings/%{BUILDING_ID}/floors/%{FLOOR_ID}/rooms/-1"
    Then the response status should be "404"

  Scenario: Get a room without being authenticated
    Given a building with id "BUILDING_ID"
    And that building has a floor with id "FLOOR_ID"
    And that floor has a room with id "ROOM_ID"
    When I send a GET request to "/buildings/%{BUILDING_ID}/floors/%{FLOOR_ID}/rooms/%{ROOM_ID}"
    Then the response status should be "401"
