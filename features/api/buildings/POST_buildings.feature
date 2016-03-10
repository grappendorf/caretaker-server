Feature: POST /buildings
  In order to add a building to the system
  as an API user
  I want to create a new building

  Scenario: Create a new building with valid properties
    Given I am authenticated as an administrator
    When I send a POST request to "/buildings" with the following:
        """
        {
          "name": "Castle",
          "description": "Home sweet home"
        }
        """
    Then the response status should be "201"
    And the JSON response should have "id"
    And I should see the following building in the database:
      | name        | Castle          |
      | description | Home sweet home |

  Scenario: Create a new building with invalid properties
    Given I am authenticated as an administrator
    When I send a POST request to "/buildings" with the following:
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
    And I should see 0 buildings in the database

  Scenario: Create an building without being authenticated
    When I send a POST request to "/buildings" with the following:
        """
        {
          "name": "Castle"
        }
        """
    Then the response status should be "401"
