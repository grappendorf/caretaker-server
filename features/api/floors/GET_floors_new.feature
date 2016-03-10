Feature: GET /floors/new
  In order create a new floor from its default values
  as an API user
  I want to get a new (unsaved) default floor

  Scenario: Get new default floor
    Given a building with id "BUILDING_ID"
    Given I am authenticated as an administrator
    When I send a GET request to "/buildings/%{BUILDING_ID}/floors/new"
    Then the response status should be "200"
    And the JSON response should be:
      """
      {
        "id": null,
        "name": null,
        "description": null
      }
      """

  Scenario: Get a default floor without being authenticated
    Given a building with id "BUILDING_ID"
    When I send a GET request to "/buildings/%{BUILDING_ID}/floors/new"
    Then the response status should be "401"
