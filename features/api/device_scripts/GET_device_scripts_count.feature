Feature: GET /device_scripts/count
  In order to get an overview of all device scripts
  as an API device_script
  I want to get a the device script count

  Scenario: Get the number of currently stored device scripts
    Given 2 device_scripts
    And I am authenticated as an administrator
    When I send a GET request to "/device_scripts/count"
    Then the response status should be "200"
    And the JSON response should be:
      """
      {
        "count": 2
      }
      """

  Scenario: Get the number of device scripts without being authenticated
    When I send a GET request to "/device_scripts/count"
    Then the response status should be "401"
