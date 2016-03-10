Feature: PUT /rooms/:id
  In order to update a rooms attributes
  as an API user
  I want to put a room

  Scenario: Update a room with valid properties
    Given a building with id "BUILDING_ID"
    And that building has a floor with id "FLOOR_ID"
    And that floor has a room with id "ROOM_ID"
    And I am authenticated as an administrator
    When I send a PUT request to "/buildings/%{BUILDING_ID}/floors/%{FLOOR_ID}/rooms/%{ROOM_ID}" with the following:
      """
      {
        "number": "Updated number",
        "description": "Updated description"
      }
      """
    Then the response status should be "204"
    And I should see the following room in the database:
      | number      | Updated number      |
      | description | Updated description |
      | floor_id    | %{FLOOR_ID}         |

  Scenario: Update a room with invalid properties
    Given a building with id "BUILDING_ID"
    And that building has a floor with id "FLOOR_ID"
    And that floor has a room with id "ROOM_ID"
    And I am authenticated as an administrator
    When I send a PUT request to "/buildings/%{BUILDING_ID}/floors/%{FLOOR_ID}/rooms/%{ROOM_ID}" with the following:
      """
      {
        "number": ""
      }
      """
    Then the response status should be "400"
    And the JSON response at "error/errors" should be:
      """
      [
        {
          "attribute": "number",
          "message": "can't be blank"
        }
      ]
      """

  Scenario: Update a not existing room
    Given a building with id "BUILDING_ID"
    And that building has a floor with id "FLOOR_ID"
    And I am authenticated as an administrator
    When I send a PUT request to "/buildings/%{BUILDING_ID}/floors/%{FLOOR_ID}/rooms/-1" with the following:
      """
      {
        "number": "Updated number",
        "description": "Updated description"
      }
      """
    Then the response status should be "404"

  Scenario: Update an room without being authenticated
    Given a building with id "BUILDING_ID"
    And that building has a floor with id "FLOOR_ID"
    And that floor has a room with id "ROOM_ID"
    When I send a PUT request to "/buildings/%{BUILDING_ID}/floors/%{FLOOR_ID}/rooms/-1" with the following:
      """
      {
        "number": "Updated number"
      }
      """
    Then the response status should be "401"
