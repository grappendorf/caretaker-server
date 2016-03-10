Feature: PUT /dashboards/:id
  In order to update a dashboards attributes
  as an API user
  I want to put a dashboard

  Scenario: Update a dashboard with valid properties
    Given I am authenticated as a user
    And a dashboard with id "DASHBOARD_ID"
    And I am the owner of that dashboard
    When I send a PUT request to "/dashboards/%{DASHBOARD_ID}" with the following:
      """
      {
        "name": "Updated name"
      }
      """
    Then the response status should be "204"
    And I should see the following dashboard in the database:
      | name    | Updated name       |
      | user_id | %{CURRENT_USER_ID} |

  Scenario: Update a dashboard with invalid properties
    Given I am authenticated as a user
    And a dashboard with id "DASHBOARD_ID"
    And I am the owner of that dashboard
    When I send a PUT request to "/dashboards/%{DASHBOARD_ID}" with the following:
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

  Scenario: Update a not existing dashboard
    Given I am authenticated as an administrator
    When I send a PUT request to "/dashboards/-1" with the following:
      """
      {
        "name": "Updated name",
        "description": "Updated description"
      }
      """
    Then the response status should be "404"

  Scenario: Update an dashboard without being authenticated
    Given a dashboard with id "DASHBOARD_ID"
    When I send a PUT request to "/dashboards/%{DASHBOARD_ID}" with the following:
      """
      {
        "name": "Updated name"
      }
      """
    Then the response status should be "401"
