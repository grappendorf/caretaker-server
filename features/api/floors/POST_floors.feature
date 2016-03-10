Feature: POST /floors
  In order to add a floor to the system
  as an API user
  I want to create a new floor

  Scenario: Create a new floor with valid properties
    Given a building with id "BUILDING_ID"
    Given I am authenticated as an administrator
    When I send a POST request to "/buildings/%{BUILDING_ID}/floors" with the following:
        """
        {
          "name": "Level 1",
          "description": "Base"
        }
        """
    Then the response status should be "201"
    And the JSON response should have "id"
    And I should see the following floor in the database:
      | name        | Level 1        |
      | description | Base           |
      | building_id | %{BUILDING_ID} |

  Scenario: Create a new floor with invalid properties
    Given a building with id "BUILDING_ID"
    And I am authenticated as an administrator
    When I send a POST request to "/buildings/%{BUILDING_ID}/floors" with the following:
        """
        {
          "name": ""
        }
        """
    Then the response status should be "400"
    And the JSON response at "error/errors" should be:
      """
      [
        {
          "attribute": "name",
          "message": "can't be blank"
        }
      ]
      """
    And I should see 0 floors in the database

  Scenario: Create an floor without being authenticated
    Given a building with id "BUILDING_ID"
    When I send a POST request to "/buildings/%{BUILDING_ID}/floors" with the following:
        """
        {
          "name": "Castle"
        }
        """
    Then the response status should be "401"
