Feature: PUT /floors/:id
  In order to update a floors attributes
  as an API user
  I want to put a floor

  Scenario: Update a floor with valid properties
    Given a building with id "BUILDING_ID"
    And that building has a floor with id "FLOOR_ID"
    And I am authenticated as an administrator
    When I send a PUT request to "/buildings/%{BUILDING_ID}/floors/%{FLOOR_ID}" with the following:
      """
      {
        "name": "Updated name",
        "description": "Updated description"
      }
      """
    Then the response status should be "204"
    And I should see the following floor in the database:
      | name        | Updated name        |
      | description | Updated description |
      | building_id | %{BUILDING_ID}      |

  Scenario: Update a floor with invalid properties
    Given a building with id "BUILDING_ID"
    And that building has a floor with id "FLOOR_ID"
    And I am authenticated as an administrator
    When I send a PUT request to "/buildings/%{BUILDING_ID}/floors/%{FLOOR_ID}" with the following:
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

  Scenario: Update a not existing floor
    Given a building with id "BUILDING_ID"
    And I am authenticated as an administrator
    When I send a PUT request to "/buildings/%{BUILDING_ID}/floors/-1" with the following:
      """
      {
        "name": "Updated name",
        "description": "Updated description"
      }
      """
    Then the response status should be "404"

  Scenario: Update an floor without being authenticated
    Given a building with id "BUILDING_ID"
    And that building has a floor with id "FLOOR_ID"
    When I send a PUT request to "/buildings/%{BUILDING_ID}/floors/%{FLOOR_ID}" with the following:
      """
      {
        "name": "Updated name"
      }
      """
    Then the response status should be "401"
