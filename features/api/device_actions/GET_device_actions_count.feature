Feature: GET /device_actions/count
  In order to get an overview of all device actions
  as an API device_action
  I want to get a the device action count

  Scenario: Get the number of currently stored device actions
    Given 2 device_actions
    And I am authenticated as an administrator
    When I send a GET request to "/device_actions/count"
    Then the response status should be "200"
    And the JSON response should be:
      """
      {
        "count": 2
      }
      """

  Scenario: Get the number of device actions without being authenticated
    When I send a GET request to "/device_actions/count"
    Then the response status should be "401"
