Feature: PUT /devices/:id
  In order to update a devices attributes
  as an API user
  I want to put a device

  Scenario: Update a device with valid properties
    Given a switch_device with id "DEVICE_ID"
    And I am authenticated as an administrator
    When I send a PUT request to "/switch_devices/%{DEVICE_ID}" with the following:
      """
      {
        "name": "Updated name",
        "description": "Updated description",
        "num_switches": 1024,
        "switches_per_row": 256
      }
      """
    Then the response status should be "204"
    And I should see the following switch_device in the database:
      | name             | Updated name        |
      | description      | Updated description |
      | num_switches     | 1024                |
      | switches_per_row | 256                 |

  Scenario: Update a device with invalid properties
    Given a switch_device with id "DEVICE_ID"
    And I am authenticated as an administrator
    When I send a PUT request to "/switch_devices/%{DEVICE_ID}" with the following:
      """
      {
        "name": ""
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

  Scenario: Update a not existing device
    Given I am authenticated as an administrator
    When I send a PUT request to "/switch_devices/-1" with the following:
      """
      {
        "name": "Updated name",
        "description": "Updated description"
      }
      """
    Then the response status should be "404"

  Scenario: Update an device without being authenticated
    Given a device with id "DEVICE_ID"
    When I send a PUT request to "/switch_devices/%{DEVICE_ID}" with the following:
      """
      {
        "name": "Updated name"
      }
      """
    Then the response status should be "401"
