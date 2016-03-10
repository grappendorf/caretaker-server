Feature: DELETE /devices/:id
  In order to remove superfluous devices
  as an API user
  I want to delete an existing device

  Scenario: Delete an existing device
    Given a switch_device with id "DEVICE_ID"
    And this device is managed by the device manager
    And I am authenticated as an administrator
    When I send a DELETE request to "/devices/%{DEVICE_ID}"
    Then the response status should be "204"
    And the device should be stopped
    And I should see 0 devices in the database

  Scenario: Delete a not existing device
    Given I am authenticated as an administrator
    When I send a DELETE request to "/devices/-1"
    Then the response status should be "404"

  Scenario: Delete a device without being authenticated
    Given a device with id "DEVICE_ID"
    When I send a DELETE request to "/devices/%{DEVICE_ID}"
    Then the response status should be "401"
