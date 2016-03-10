Feature: GET /users/new
  In order create a new user from its default values
  as an API user
  I want to get a new (unsaved) default user

  Scenario: Get new default user
    Given I am authenticated as an administrator
    When I send a GET request to "/users/new"
    Then the response status should be "200"
    And the JSON response should be:
      """
      {
        "id": null,
        "email": "",
        "name": null,
        "roles": []
      }
      """

  Scenario: Get new default user without being authenticated
    When I send a GET request to "/users/new"
    Then the response status should be "401"
