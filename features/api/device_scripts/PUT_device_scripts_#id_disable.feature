Feature: PUT /device_scripts/:id
  In order to prevent a device script from being executed
  as an API user
  I want to disable the device script

  Scenario: Disable a device script
    Given a device_script with id "DEVICE_SCRIPT_ID"
    And the device script is currently enabled
    And I am authenticated as an administrator
    When I send a PUT request to "/device_scripts/%{DEVICE_SCRIPT_ID}/disable"
    Then the response status should be "204"
    And the device script is now disabled
