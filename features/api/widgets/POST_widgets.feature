Feature: POST /widgets
  In order to add a widget to the system
  as an API user
  I want to create a new widget

  Scenario: Create a new widget with valid properties
    Given I am authenticated as a user
    And a dashboard with id "DASHBOARD_ID"
    And I am the owner of that dashboard
    When I send a POST request to "/dashboards/%{DASHBOARD_ID}/clock_widgets" with the following:
        """
        {
          "title": "UTC",
          "height": 2,
          "width": 3
        }
        """
    Then the response status should be "201"
    And the JSON response should have "id"
    And I should see the following widget in the database:
      | title        | UTC             |
      | dashboard_id | %{DASHBOARD_ID} |
      | height       | 2               |
      | width        | 3               |
      | position     | 1               |

  Scenario: Create a new widget with invalid properties
    Given I am authenticated as a user
    And a dashboard with id "DASHBOARD_ID"
    And I am the owner of that dashboard
    When I send a POST request to "/dashboards/%{DASHBOARD_ID}/clock_widgets" with the following:
        """
        {
          "position": -1
        }
        """
    Then the response status should be "400"
    And the JSON response at "error/errors" should be:
      """
      [
        {
          "attribute": "position",
          "message": "must be greater than or equal to 0"
        }
      ]
      """
    And I should see 0 widgets in the database

  Scenario: Create an widget without being authenticated
    Given a dashboard with id "DASHBOARD_ID"
    When I send a POST request to "/dashboards/%{DASHBOARD_ID}/clock_widgets" with the following:
        """
        {
        }
        """
    Then the response status should be "401"
