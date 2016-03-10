Feature: GET /buildings/:id
  In order to get full information about a specific building
  as an API user
  I want to get the building

  Scenario: Get an existing building
    Given the following building with id "BUILDING_ID":
      | name        | Castle          |
      | description | Home sweet home |
    And I am authenticated as an administrator
    When I send a GET request to "/buildings/%{BUILDING_ID}"
    Then the response status should be "200"
    And the JSON response should be:
      """
      {
        "id": %{BUILDING_ID},
        "name": "Castle",
        "description": "Home sweet home"
      }
      """

  Scenario: Get a not existing building
    Given I am authenticated as an administrator
    When I send a GET request to "/buildings/-1"
    Then the response status should be "404"

  Scenario: Get a building without being authenticated
    Given a building with id "BUILDING_ID"
    When I send a GET request to "/buildings/%{BUILDING_ID}"
    Then the response status should be "401"
