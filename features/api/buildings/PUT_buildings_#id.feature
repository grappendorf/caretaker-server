Feature: PUT /buildings/:id
  In order to update a buildings attributes
  as an API user
  I want to put a building

  Scenario: Update a building with valid properties
    Given a building with id "BUILDING_ID"
    And I am authenticated as an administrator
    When I send a PUT request to "/buildings/%{BUILDING_ID}" with the following:
      """
      {
        "name": "Updated name",
        "description": "Updated description"
      }
      """
    Then the response status should be "204"
    And I should see the following building in the database:
      | name        | Updated name        |
      | description | Updated description |

  Scenario: Update a building with invalid properties
    Given a building with id "BUILDING_ID"
    And I am authenticated as an administrator
    When I send a PUT request to "/buildings/%{BUILDING_ID}" with the following:
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

  Scenario: Update a not existing building
    Given I am authenticated as an administrator
    When I send a PUT request to "/buildings/-1" with the following:
      """
      {
        "name": "Updated name",
        "description": "Updated description"
      }
      """
    Then the response status should be "404"

  Scenario: Update an building without being authenticated
    Given a building with id "BUILDING_ID"
    When I send a PUT request to "/buildings/%{BUILDING_ID}" with the following:
      """
      {
        "name": "Updated name"
      }
      """
    Then the response status should be "401"
