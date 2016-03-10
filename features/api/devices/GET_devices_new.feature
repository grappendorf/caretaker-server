Feature: GET /devices/new
  In order create a new device from its default values
  as an API user
  I want to get a new (unsaved) default device

  Scenario: Get new default device
    Given I am authenticated as an administrator
    When I send a GET request to "/switch_devices/new"
    Then the response status should be "200"
    And the JSON response should be:
      """
      {
        "id": null,
        "specific_id": null,
        "type": "SwitchDevice",
        "uuid": null,
        "address": null,
        "name": null,
        "description": null,
        "large_icon": "32/lightbulb_on.png",
        "small_icon": "16/lightbulb_on.png",
        "num_switches": null,
        "switches_per_row": null,
        "connected": null,
        "state": null
      }
      """

  Scenario: Get a default device without being authenticated
    When I send a GET request to "/switch_devices/new"
    Then the response status should be "401"
