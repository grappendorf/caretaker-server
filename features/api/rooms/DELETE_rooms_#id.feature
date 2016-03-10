Feature: DELETE /rooms/:id
  In order to remove superfluous rooms
  as an API user
  I want to delete an existing room

  Scenario: Delete an existing room
    Given a building with id "BUILDING_ID"
    And that building has a floor with id "FLOOR_ID"
    And that floor has a room with id "ROOM_ID"
    And I am authenticated as an administrator
    When I send a DELETE request to "/buildings/%{BUILDING_ID}/floors/%{FLOOR_ID}/rooms/%{ROOM_ID}"
    Then the response status should be "204"
    And I should see 0 rooms in the database

  Scenario: Delete a not existing room
    Given a building with id "BUILDING_ID"
    And that building has a floor with id "FLOOR_ID"
    Given I am authenticated as an administrator
    When I send a DELETE request to "/buildings/%{BUILDING_ID}/floors/%{FLOOR_ID}/rooms/-1"
    Then the response status should be "404"

  Scenario: Delete a room without being authenticated
    Given a building with id "BUILDING_ID"
    And that building has a floor with id "FLOOR_ID"
    And that floor has a room with id "ROOM_ID"
    When I send a DELETE request to "/buildings/%{BUILDING_ID}/floors/%{FLOOR_ID}/rooms/%{ROOM_ID}"
    Then the response status should be "401"
