Feature: PUT /device_scripts/:id
  In order to allow a device script to be executed
  as an API user
  I want to enable the device script

  Scenario: Enable a device script
    Given a device_script with id "DEVICE_SCRIPT_ID"
    And the device script is currently disabled
    And I am authenticated as an administrator
    When I send a PUT request to "/device_scripts/%{DEVICE_SCRIPT_ID}/enable"
    Then the response status should be "204"
    And the device script is now enabled
