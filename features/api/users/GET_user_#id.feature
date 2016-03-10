Feature: GET /users/:id
  In order to get full information about a specific user
  as an API user
  I want to get the user

  Scenario: Get an existing user
    Given the following user with id "USER_ID":
      | email | alice@example.com |
      | name  | alice             |
    And I am authenticated as an administrator
    When I send a GET request to "/users/%{USER_ID}"
    Then the response status should be "200"
    And the JSON response should be:
      """
      {
        "id": %{USER_ID},
        "email": "alice@example.com",
        "name": "alice",
        "roles": ["user"]
      }
      """

  Scenario: Get a not existing user
    When I send a GET request to "/users/-1"
    Then the response status should be "404"

  Scenario: Get a user without being authenticated
    Given a user with id "USER_ID"
    When I send a GET request to "/users/%{USER_ID}"
    Then the response status should be "401"
