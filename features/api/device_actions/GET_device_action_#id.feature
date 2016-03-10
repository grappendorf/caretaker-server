Feature: GET /device_actions/:id
  In order to get full information about a specific device action
  as an API user
  I want to get the device action

  Scenario: Get an existing device action
    Given the following device_action with id "DEVICE_ACTION_ID":
      | name        | Print                |
      | description | Write a message      |
      | script      | msg = 'Hello world!' |
    And I am authenticated as an administrator
    When I send a GET request to "/device_actions/%{DEVICE_ACTION_ID}"
    Then the response status should be "200"
    And the JSON response should be:
      """
      {
        "id": %{DEVICE_ACTION_ID},
        "name": "Print",
        "description": "Write a message",
        "script":  "msg = 'Hello world!'"
      }
      """

  Scenario: Get a not existing device action
    Given I am authenticated as an administrator
    When I send a GET request to "/device_actions/-1"
    Then the response status should be "404"

  Scenario: Get a device action without being authenticated
    Given a device_action with id "DEVICE_ACTION_ID"
    When I send a GET request to "/device_actions/%{DEVICE_ACTION_ID}"
    Then the response status should be "401"
