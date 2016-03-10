Feature: POST /users
  In order to add users to the system
  as an API user
  I want to create new users.

  Scenario: Create a new user with valid properties
    Given I am authenticated as an administrator
    When I send a POST request to "/users" with the following:
      """
      {
      	"email": "alice@example.com",
        "password": "s3cr3t",
        "name": "alice"
      }
      """
    Then the response status should be "201"
    And the JSON response should have "id"
    And I should see the following user in the database:
      | email | alice@example.com |
      | name  | alice             |
    And I should be able to login on "/sessions" with email "alice@example.com" and password "s3cr3t"


  Scenario: Create a new user with an already existing email
    Given the following user:
      | email | alice@example.com |
      | name  | alice             |
    And I am authenticated as an administrator
    When I send a POST request to "/users" with the following:
      """
      {
      	"email": "alice@example.com",
        "password": "s3cr3t",
        "name": "anny"
      }
      """
    Then the response status should be "400"
    And I should see 2 user in the database

  Scenario: Create a new user without being authenticated
    When I send a POST request to "/users" with the following:
      """
      {
      	"email": "alice@example.com",
        "password": "s3cr3t",
        "name": "alice"
      }
      """
    Then the response status should be "401"
