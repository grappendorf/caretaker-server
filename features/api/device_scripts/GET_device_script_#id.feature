Feature: GET /device_scripts/:id
  In order to get full information about a specific device script
  as an API user
  I want to get the device script

  Scenario: Get an existing device script
    Given the following device_script with id "DEVICE_SCRIPT_ID":
      | name        | Print                |
      | description | Write a message      |
      | script      | msg = 'Hello world!' |
      | enabled     | true                 |
    And I am authenticated as an administrator
    When I send a GET request to "/device_scripts/%{DEVICE_SCRIPT_ID}"
    Then the response status should be "200"
    And the JSON response should be:
      """
      {
        "id": %{DEVICE_SCRIPT_ID},
        "name": "Print",
        "description": "Write a message",
        "script":  "msg = 'Hello world!'",
        "enabled": true
      }
      """

  Scenario: Get a not existing device script
    Given I am authenticated as an administrator
    When I send a GET request to "/device_scripts/-1"
    Then the response status should be "404"

  Scenario: Get a device script without being authenticated
    Given a device_script with id "DEVICE_SCRIPT_ID"
    When I send a GET request to "/device_scripts/%{DEVICE_SCRIPT_ID}"
    Then the response status should be "401"
