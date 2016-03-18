Feature: GET /devices
  In order to get information about the devices
  as an API user
  I want to list them

  Scenario: Get a list of all devices
    Given the following switch_device with id "DEVICE_1_ID":
      | uuid             | 1234            |
      | address          | 192.168.100.100 |
      | port             | 2020            |
      | name             | Room switch     |
      | description      | Room lights     |
      | num_switches     | 4               |
      | switches_per_row | 2               |
    And the following switch_device with id "DEVICE_2_ID":
      | uuid             | 5678            |
      | address          | 192.168.100.101 |
      | port             | 2020            |
      | name             | Kitchen switch  |
      | description      | Oven            |
      | num_switches     | 2               |
      | switches_per_row | 1               |
    And I am authenticated as an administrator
    When I send a GET request to "/devices"
    Then the response status should be "200"
    And the JSON response should be:
      """
      [
        {
          "id": %{DEVICE_1_ID},
          "specific_id": %{DEVICE_1_ID},
          "type": "SwitchDevice",
          "uuid": "1234",
          "address": "192.168.100.100",
          "port": 2020,
          "name": "Room switch",
          "description": "Room lights",
          "large_icon": "32/lightbulb_on.png",
          "small_icon": "16/lightbulb_on.png",
          "connected": null
        },
        {
          "id": %{DEVICE_2_ID},
          "specific_id": %{DEVICE_2_ID},
          "type": "SwitchDevice",
          "uuid": "5678",
          "address": "192.168.100.101",
          "port": 2020,
          "name": "Kitchen switch",
          "description": "Oven",
          "large_icon": "32/lightbulb_on.png",
          "small_icon": "16/lightbulb_on.png",
          "connected": null
        }
      ]
      """

  Scenario: Get a list of all devices when there are no devices
    Given I am authenticated as an administrator
    When I send a GET request to "/devices"
    Then the response status should be "200"
    And the JSON response should be:
      """
      []
      """

  Scenario: Get a list of all devices without being authenticated
    When I send a GET request to "/devices"
    Then the response status should be "401"
