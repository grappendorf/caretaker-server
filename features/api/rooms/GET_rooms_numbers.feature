Feature: GET /rooms/numbers
  In order to get short information about the rooms
  as an API user
  I want to list their numbers

  Scenario: Get a list of all room numbers
    Given a building with id "BUILDING_ID"
    And that building has a floor with id "FLOOR_ID"
    And that floor has the following room with id "ROOM_1_ID":
      | number      | 1.100        |
      | description | Meeting room |
    And that floor has the following room with id "ROOM_2_ID":
      | number      | 1.200     |
      | description | Cafeteria |
    And I am authenticated as an administrator
    When I send a GET request to "/buildings/%{BUILDING_ID}/floors/%{FLOOR_ID}/rooms/numbers"
    Then the response status should be "200"
    And the JSON response should be:
      """
      [
        {
          "id": %{ROOM_1_ID},
          "number": "1.100"
        },
        {
          "id": %{ROOM_2_ID},
          "number": "1.200"
        }
      ]
      """

  Scenario: Get a list of all room names when there are no rooms
    Given a building with id "BUILDING_ID"
    And that building has a floor with id "FLOOR_ID"
    And I am authenticated as an administrator
    When I send a GET request to "/buildings/%{BUILDING_ID}/floors/%{FLOOR_ID}/rooms/numbers"
    Then the response status should be "200"
    And the JSON response should be:
      """
      []
      """

  Scenario: Get a list of all room names without being authenticated
    Given a building with id "BUILDING_ID"
    And that building has a floor with id "FLOOR_ID"
    When I send a GET request to "/buildings/%{BUILDING_ID}/floors/%{FLOOR_ID}/rooms/numbers"
    Then the response status should be "401"
