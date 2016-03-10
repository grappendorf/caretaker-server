Feature: PUT /users/:id
  In order to update a users attributes
  as an API user
  I want to put a user

  Scenario: Update an existing user
    Given the following user with id "USER_ID":
      | email | alice@example.com |
      | name  | alice             |
    And I am authenticated as an administrator
    When I send a PUT request to "/users/%{USER_ID}" with the following:
      """
      {
        "email": "alice@example.com",
        "name": "alice",
        "roles": ["a_new_role"]
      }
      """
    Then the response status should be "204"
    And I should see the following user in the database:
      | email | alice@example.com |
      | name  | alice             |
    And I should see the following role in the database:
      | name | a_new_role |

  Scenario: Update a not existing user
    When I send a PUT request to "/users/-1" with the following:
      """
      {
        "email": "alice@example.com",
        "name": "alice"
      }
      """
    Then the response status should be "404"

  Scenario: Update an existing user without being authenticated
    Given a user with id "USER_ID"
    When I send a PUT request to "/users/%{USER_ID}" with the following:
      """
      {
        "email": "alice@example.com",
        "name": "alice"
      }
      """
    Then the response status should be "401"
