Feature: DELETE /device_actions/:id
  In order to remove superfluous device actions
  as an API user
  I want to delete an existing device action

  Scenario: Delete an existing device action
    Given a device_action with id "DEVICE_ACTION_ID"
    And I am authenticated as an administrator
    When I send a DELETE request to "/device_actions/%{DEVICE_ACTION_ID}"
    Then the response status should be "204"
    And I should see 0 device_actions in the database

  Scenario: Delete a not existing device action
    Given I am authenticated as an administrator
    When I send a DELETE request to "/device_actions/-1"
    Then the response status should be "404"

  Scenario: Delete a device action without being authenticated
    Given a device_action with id "DEVICE_ACTION_ID"
    When I send a DELETE request to "/device_actions/%{DEVICE_ACTION_ID}"
    Then the response status should be "401"
