Feature: GET /device_scripts/new
  In order create a new device script from its default values
  as an API user
  I want to get a new (unsaved) default device script

  Scenario: Get new default device script
    Given I am authenticated as an administrator
    When I send a GET request to "/device_scripts/new"
    Then the response status should be "200"
    And the JSON response should be:
      """
      {
        "id": null,
        "name": null,
        "description": null,
        "enabled": null,
        "script": null
      }
      """

  Scenario: Get a default device script without being authenticated
    When I send a GET request to "/device_scripts/new"
    Then the response status should be "401"
