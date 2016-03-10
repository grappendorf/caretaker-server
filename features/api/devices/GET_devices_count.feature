Feature: GET /devices/count
  In order to get an overview of all devices
  as an API device
  I want to get a the device count

  Scenario: Get the number of currently stored devices
    Given 2 devices
    And I am authenticated as an administrator
    When I send a GET request to "/devices/count"
    Then the response status should be "200"
    And the JSON response should be:
      """
      {
        "count": 2
      }
      """

  Scenario: Get the number of devices without being authenticated
    When I send a GET request to "/devices/count"
    Then the response status should be "401"
