Feature: POST /devices
  In order to add a device to the system
  as an API user
  I want to create a new device

  Scenario: Create a new device with valid properties
    Given I am authenticated as an administrator
    When I send a POST request to "/switch_devices" with the following:
        """
        {
          "name": "Room switch",
          "uuid": "1234",
          "address": "abcd",
          "num_switches": 4,
          "switches_per_row": 2
        }
        """
    Then the response status should be "201"
    And the JSON response should have "id"
    And I should see the following switch_device in the database:
      | name             | Room switch |
      | uuid             | 1234        |
      | address          | abcd        |
      | num_switches     | 4           |
      | switches_per_row | 2           |

  Scenario: Create a new device with invalid properties
    Given I am authenticated as an administrator
    When I send a POST request to "/switch_devices" with the following:
        """
        {
          "name": "",
          "uuid": "1234",
          "address": "abcd",
          "num_switches": 4,
          "switches_per_row": 2
        }
        """
    Then the response status should be "400"
    And the JSON response at "error/errors" should be:
      """
      [
        {
          "attribute": "name",
          "message": "can't be blank"
        }
      ]
      """
    And I should see 0 devices in the database

  Scenario: Create an device without being authenticated
    When I send a POST request to "/switch_devices" with the following:
        """
        {
          "name": "Room switch",
          "uuid": "1234",
          "address": "abcd",
          "num_switches": 4,
          "switches_per_row": 2
        }
        """
    Then the response status should be "401"
