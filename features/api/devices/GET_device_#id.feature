Feature: GET /devices/:id
  In order to get full information about a specific device
  as an API user
  I want to get the device

  Scenario: Get an existing device
    Given the following switch_device with id "DEVICE_ID":
      | uuid             | 1234            |
      | address          | 192.168.100.100 |
      | port             | 2020            |
      | name             | Room switch     |
      | description      | Room lights     |
      | num_switches     | 4               |
      | switches_per_row | 2               |
    And I am authenticated as an administrator
    When I send a GET request to "/devices/%{DEVICE_ID}"
    Then the response status should be "200"
    And the JSON response should be:
      """
      {
        "id": %{DEVICE_ID},
        "specific_id": %{DEVICE_ID},
        "type": "SwitchDevice",
        "uuid": "1234",
        "address": "192.168.100.100",
        "port": 2020,
        "name": "Room switch",
        "description": "Room lights",
        "large_icon": "32/lightbulb_on.png",
        "small_icon": "16/lightbulb_on.png",
        "num_switches": 4,
        "switches_per_row": 2,
        "state": null,
        "connected": null
      }
      """

  Scenario: Get a not existing device
    Given I am authenticated as an administrator
    When I send a GET request to "/devices/-1"
    Then the response status should be "404"

  Scenario: Get a device without being authenticated
    Given a device with id "DEVICE_ID"
    When I send a GET request to "/devices/%{DEVICE_ID}"
    Then the response status should be "401"
