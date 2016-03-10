Feature: POST /device_actions
  In order to add a device action to the system
  as an API user
  I want to create a new device action

  Scenario: Create a new device action with valid properties
    Given I am authenticated as an administrator
    When I send a POST request to "/device_actions" with the following:
        """
        {
          "name": "Print",
          "description": "Write a message",
          "script": "msg = 'Hello world!'"
        }
        """
    Then the response status should be "201"
    And the JSON response should have "id"
    And I should see the following device_action in the database:
      | name        | Print                |
      | description | Write a message      |
      | script      | msg = 'Hello world!' |

  Scenario: Create a new device action with invalid properties
    Given I am authenticated as an administrator
    When I send a POST request to "/device_actions" with the following:
        """
        {
          "name": "",
          "script": ""
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
    And I should see 0 device_actions in the database

  Scenario: Create an device action without being authenticated
    When I send a POST request to "/device_actions" with the following:
        """
        {
          "name": "Print",
          "script": "msg = 'Hello world!'"
        }
        """
    Then the response status should be "401"
