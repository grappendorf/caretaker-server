Feature: PUT /device_actions/:id
  In order to update a device actions attributes
  as an API user
  I want to put a device action

  Scenario: Update a device action with valid properties
    Given a device_action with id "DEVICE_ACTION_ID"
    And I am authenticated as an administrator
    When I send a PUT request to "/device_actions/%{DEVICE_ACTION_ID}" with the following:
      """
      {
        "name": "Updated name",
        "description": "Updated deactionion",
        "script": "puts 'Updated'"
      }
      """
    Then the response status should be "204"
    And I should see the following device_action in the database:
      | name        | Updated name        |
      | description | Updated deactionion |
      | script      | puts 'Updated'      |

  Scenario: Update a device action with invalid properties
    Given a device_action with id "DEVICE_ACTION_ID"
    And I am authenticated as an administrator
    When I send a PUT request to "/device_actions/%{DEVICE_ACTION_ID}" with the following:
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

  Scenario: Update a not existing device action
    Given I am authenticated as an administrator
    When I send a PUT request to "/device_actions/-1" with the following:
      """
      {
        "name": "Updated name"
      }
      """
    Then the response status should be "404"

  Scenario: Update an device action without being authenticated
    Given a device_action with id "DEVICE_ACTION_ID"
    When I send a PUT request to "/device_actions/%{DEVICE_ACTION_ID}" with the following:
      """
      {
        "name": "Updated name"
      }
      """
    Then the response status should be "401"
