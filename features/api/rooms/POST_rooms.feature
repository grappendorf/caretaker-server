Feature: POST /rooms
  In order to add a room to the system
  as an API user
  I want to create a new room

  Scenario: Create a new room with valid properties
    Given a building with id "BUILDING_ID"
    And that building has a floor with id "FLOOR_ID"
    Given I am authenticated as an administrator
    When I send a POST request to "/buildings/%{BUILDING_ID}/floors/%{FLOOR_ID}/rooms" with the following:
        """
        {
          "number": "1.100",
          "description": "Meeting room"
        }
        """
    Then the response status should be "201"
    And the JSON response should have "id"
    And I should see the following room in the database:
      | number      | 1.100        |
      | description | Meeting room |
      | floor_id    | %{FLOOR_ID}  |

  Scenario: Create a new room with invalid properties
    Given a building with id "BUILDING_ID"
    And that building has a floor with id "FLOOR_ID"
    And I am authenticated as an administrator
    When I send a POST request to "/buildings/%{BUILDING_ID}/floors/%{FLOOR_ID}/rooms" with the following:
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
    And I should see 0 rooms in the database

  Scenario: Create an room without being authenticated
    Given a building with id "BUILDING_ID"
    And that building has a floor with id "FLOOR_ID"
    When I send a POST request to "/buildings/%{BUILDING_ID}/floors/%{FLOOR_ID}/rooms" with the following:
        """
        {
          "number": "1.100",
          "description": "Meeting room"
        }
        """
    Then the response status should be "401"
