Feature: Make the first dashboard the default one
  In order to have a default dashboard
  as an API user
  I want my first dashboard always to be the default one

  Scenario: Create a new dashboard without specifying the default attribute
    Given I am authenticated as a user
    When I send a POST request to "/dashboards" with the following:
        """
        {
          "name": "First dashboard"
        }
        """
    Then the response status should be "201"
    When I send a POST request to "/dashboards" with the following:
        """
        {
          "name": "Second dashboard"
        }
        """
    Then the response status should be "201"
    And I should see the following dashboard in the database:
      | name    | First dashboard    |
      | default | true               |
      | user_id | %{CURRENT_USER_ID} |
    And I should see the following dashboard in the database:
      | name    | Second dashboard   |
      | default | false              |
      | user_id | %{CURRENT_USER_ID} |
