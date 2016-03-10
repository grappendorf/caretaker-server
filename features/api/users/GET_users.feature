Feature: GET /users
  In order to get information about the users
  as an API user
  I want to list them.

  Scenario: Get a list of all users
    Given I am authenticated as an administrator
    And the following user with id "USER_ID":
      | email | alice@example.com |
      | name  | alice             |
    When I send a GET request to "/users"
    Then the response status should be "200"
    And the JSON response should be:
      """
      [
        {
          "id": %{CURRENT_USER_ID},
          "email": "admin@example.com",
          "name": "admin",
          "roles": ["admin", "manager", "user"]
        },
        {
          "id": %{USER_ID},
          "email": "alice@example.com",
          "name": "alice",
          "roles": ["user"]
         }
      ]
      """

  Scenario: Get a list of users without being authenticated
    When I send a GET request to "/users"
    Then the response status should be "401"
