Feature: GET /buildings
  In order to get information about the buildings
  as an API user
  I want to list them

  Scenario: Get a list of all buildings
    Given the following building with id "BUILDING_1_ID":
      | name        | Castle          |
      | description | Home sweet home |
    And the following building with id "BUILDING_2_ID":
      | name        | Cabin             |
      | description | A makers workshop |
    And I am authenticated as an administrator
    When I send a GET request to "/buildings"
    Then the response status should be "200"
    And the JSON response should be:
      """
      [
        {
          "id": %{BUILDING_1_ID},
          "name": "Castle",
          "description": "Home sweet home"
        },
        {
          "id": %{BUILDING_2_ID},
          "name": "Cabin",
          "description": "A makers workshop"
        }
      ]
      """

  Scenario: Get a list of all buildings when there are no buildings
    Given I am authenticated as an administrator
    When I send a GET request to "/buildings"
    Then the response status should be "200"
    And the JSON response should be:
      """
      []
      """

  Scenario: Get a list of all buildings without being authenticated
    When I send a GET request to "/buildings"
    Then the response status should be "401"
