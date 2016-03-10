Feature: PUT /device_scripts/:id
  In order to update a device scripts attributes
  as an API user
  I want to put a device script

  Scenario: Update a device script with valid properties
    Given a device_script with id "DEVICE_SCRIPT_ID"
    And I am authenticated as an administrator
    When I send a PUT request to "/device_scripts/%{DEVICE_SCRIPT_ID}" with the following:
      """
      {
        "name": "Updated name",
        "description": "Updated description",
        "script": "puts 'Updated'",
        "enabled": false
      }
      """
    Then the response status should be "204"
    And I should see the following device_script in the database:
      | name        | Updated name        |
      | description | Updated description |
      | script      | puts 'Updated'      |
    And the device script is now disabled

  Scenario: Update a device script with invalid properties
    Given a device_script with id "DEVICE_SCRIPT_ID"
    And I am authenticated as an administrator
    When I send a PUT request to "/device_scripts/%{DEVICE_SCRIPT_ID}" with the following:
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

  Scenario: Update a not existing device script
    Given I am authenticated as an administrator
    When I send a PUT request to "/device_scripts/-1" with the following:
      """
      {
        "name": "Updated name"
      }
      """
    Then the response status should be "404"

  Scenario: Update an device script without being authenticated
    Given a device_script with id "DEVICE_SCRIPT_ID"
    When I send a PUT request to "/device_scripts/%{DEVICE_SCRIPT_ID}" with the following:
      """
      {
        "name": "Updated name"
      }
      """
    Then the response status should be "401"
