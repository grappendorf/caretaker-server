Feature: GET /buildings/new
  In order create a new building from its default values
  as an API user
  I want to get a new (unsaved) default building

  Scenario: Get new default building
    Given I am authenticated as an administrator
    When I send a GET request to "/buildings/new"
    Then the response status should be "200"
    And the JSON response should be:
      """
      {
        "id": null,
        "name": null,
        "description": null
      }
      """

  Scenario: Get a default building without being authenticated
    When I send a GET request to "/buildings/new"
    Then the response status should be "401"
