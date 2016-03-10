Feature: GET /users/count
  In order to get an overview of all users
  as an API user
  I want to get a the user count

  Scenario: Get the number of currently stored users
    Given 2 users
    And I am authenticated as an administrator
    When I send a GET request to "/users/count"
    Then the response status should be "200"
    And the JSON response should be:
      """
      {
        "count": 3
      }
      """

  Scenario: Get the number of users without being authenticated
    When I send a GET request to "/users/count"
    Then the response status should be "401"
