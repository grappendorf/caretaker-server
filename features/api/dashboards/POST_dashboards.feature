Feature: POST /dashboards
  In order to add a dashboard to the system
  as an API user
  I want to create a new dashboard

  Scenario: Create a new dashboard with valid properties
    Given I am authenticated as a user
    When I send a POST request to "/dashboards" with the following:
        """
        {
          "name": "Default",
          "default": true
        }
        """
    Then the response status should be "201"
    And the JSON response should have "id"
    And I should see the following dashboard in the database:
      | name    | Default            |
      | default | true               |
      | user_id | %{CURRENT_USER_ID} |

  Scenario: Create a new dashboard with invalid properties
    Given I am authenticated as a user
    When I send a POST request to "/dashboards" with the following:
        """
        {
          "name": ""
        }
        """
    Then the response status should be "400"
    And the JSON response at "error/errors" should be:
      """
      [
        {
          "attribute": "name",
          "message": "can't be blank"
        }
      ]
      """
    And I should see 0 dashboards in the database

  Scenario: Create an dashboard without being authenticated
    When I send a POST request to "/dashboards" with the following:
        """
        {
          "name": "Castle"
        }
        """
    Then the response status should be "401"
