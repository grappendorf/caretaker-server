Feature: DELETE /device_scripts/:id
  In order to remove superfluous device scripts
  as an API user
  I want to delete an existing device script

  Scenario: Delete an existing device script
    Given a device_script with id "DEVICE_SCRIPT_ID"
    And I am authenticated as an administrator
    When I send a DELETE request to "/device_scripts/%{DEVICE_SCRIPT_ID}"
    Then the response status should be "204"
    And I should see 0 device_scripts in the database

  Scenario: Delete a not existing device script
    Given I am authenticated as an administrator
    When I send a DELETE request to "/device_scripts/-1"
    Then the response status should be "404"

  Scenario: Delete a device script without being authenticated
    Given a device_script with id "DEVICE_SCRIPT_ID"
    When I send a DELETE request to "/device_scripts/%{DEVICE_SCRIPT_ID}"
    Then the response status should be "401"
