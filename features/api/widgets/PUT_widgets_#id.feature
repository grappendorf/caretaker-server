Feature: PUT /widgets/:id
  In order to update a widgets attributes
  as an API user
  I want to put a widget

  Scenario: Update a widget with valid properties
    Given I am authenticated as a user
    And a dashboard with id "DASHBOARD_ID"
    And that dashboard has a clock_widget with id "WIDGET_ID"
    And I am the owner of that dashboard
    When I send a PUT request to "/dashboards/%{DASHBOARD_ID}/clock_widgets/%{WIDGET_ID}" with the following:
      """
      {
        "title": "UTC"
      }
      """
    Then the response status should be "204"
    And I should see the following widget in the database:
      | title        | UTC  |
      | dashboard_id | %{DASHBOARD_ID} |

  Scenario: Update a widget with invalid properties
    Given I am authenticated as a user
    And a dashboard with id "DASHBOARD_ID"
    And that dashboard has a clock_widget with id "WIDGET_ID"
    And I am the owner of that dashboard
    When I send a PUT request to "/dashboards/%{DASHBOARD_ID}/clock_widgets/%{WIDGET_ID}" with the following:
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

  Scenario: Update a not existing widget
    Given I am authenticated as a user
    And a dashboard with id "DASHBOARD_ID"
    And I am the owner of that dashboard
    When I send a PUT request to "/dashboards/%{DASHBOARD_ID}/clock_widgets/-1" with the following:
      """
      {
        "title": "UTC"
      }
      """
    Then the response status should be "404"

  Scenario: Update an widget without being authenticated
    Given a dashboard with id "DASHBOARD_ID"
    And that dashboard has a clock_widget with id "WIDGET_ID"
    When I send a PUT request to "/dashboards/%{DASHBOARD_ID}/clock_widgets/%{WIDGET_ID}" with the following:
      """
      {
        "name": "Updated name"
      }
      """
    Then the response status should be "401"
