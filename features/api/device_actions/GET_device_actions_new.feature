Feature: GET /device_actions/new
  In order create a new device action from its default values
  as an API user
  I want to get a new (unsaved) default device action

  Scenario: Get new default device action
    Given I am authenticated as an administrator
    When I send a GET request to "/device_actions/new"
    Then the response status should be "200"
    And the JSON response should be:
      """
      {
        "id": null,
        "name": null,
        "description": null,
        "script": null
      }
      """

  Scenario: Get a default device action without being authenticated
    When I send a GET request to "/device_actions/new"
    Then the response status should be "401"
