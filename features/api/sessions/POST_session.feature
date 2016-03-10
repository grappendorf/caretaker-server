Feature: POST /sessions
  In order to use the API services
  as an API user
  I want to create a new session and login with my email and my password.

  Scenario: Create a session with a valid email address and password
    Given the following user with id "USER_ID":
      | email    | alice@example.com |
      | password | s3cr3t            |
      | name     | alice             |
    When I send a POST request to "/sessions" with the following:
          """
          {
          	"email": "alice@example.com",
            "password": "s3cr3t"
          }
          """
    And I keep the JSON response at "token" as "TOKEN"
    Then the response status should be "201"
    And the JSON response should be:
          """
          {
            "user": {
              "id": %{USER_ID},
              "email": "alice@example.com",
              "name": "alice",
              "roles": ["user"]
            },
            "token": %{TOKEN}
          }
          """

  Scenario: Create a session with a not existing email
    When I send a POST request to "/sessions" with the following:
      """
      {
        "email": "not_existing_user@example.com",
        "password": "s3cr3t"
      }
      """
    Then the response status should be "401"
    And the JSON response should be:
      """
      {
        "error": {
          "message": "Invalid credentials"
          }
      }
      """


  Scenario: Create a session with a wrong password
    Given the following user:
      | email    | alice@example.com |
      | password | s3cr3t            |
    When I send a POST request to "/sessions" with the following:
      """
      {
        "email": "alice@example.com",
        "password": "wrong_password"
      }
      """
    Then the response status should be "401"
    And the JSON response should be:
      """
      {
        "error": {
          "message": "Invalid credentials"
        }
      }
      """
