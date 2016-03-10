Feature: GET /devices/names
  In order to get short information about the devices
  as an API user
  I want to list their names

  Scenario: Get a list of all device names
    Given the following switch_device with id "DEVICE_1_ID":
      | uuid             | 1234        |
      | address          | abcd        |
      | name             | Room switch |
      | description      | Room lights |
      | num_switches     | 4           |
      | switches_per_row | 2           |
    And the following switch_device with id "DEVICE_2_ID":
      | uuid             | 5678           |
      | address          | efgh           |
      | name             | Kitchen switch |
      | description      | Oven           |
      | num_switches     | 2              |
      | switches_per_row | 1              |
    And I am authenticated as an administrator
    When I send a GET request to "/devices/names"
    Then the response status should be "200"
    And the JSON response should be:
      """
      [
        {
          "id": %{DEVICE_1_ID},
          "name": "Room switch"
        },
        {
          "id": %{DEVICE_2_ID},
          "name": "Kitchen switch"
        }
      ]
      """

  Scenario: Get a list of all device names when there are no devices
    Given I am authenticated as an administrator
    When I send a GET request to "/devices/names"
    Then the response status should be "200"
    And the JSON response should be:
      """
      []
      """

  Scenario: Get a list of all device names without being authenticated
    When I send a GET request to "/devices/names"
    Then the response status should be "401"
