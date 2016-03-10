Feature: DELETE /users/:id
  In order to remove superfluous users
  as an API user
  I want to delete an existing user

  Scenario: Delete an existing user
    Given a user with id "USER_ID"
    And I am authenticated as an administrator
    When I send a DELETE request to "/users/%{USER_ID}"
    Then the response status should be "204"
    And I should see 1 users in the database

  Scenario: Delete a not existing user
    When I send a DELETE request to "/users/-1"
    Then the response status should be "404"

  Scenario: Delete a user without being authenticated
    Given a user with id "USER_ID"
    When I send a DELETE request to "/users/%{USER_ID}"
    Then the response status should be "401"
