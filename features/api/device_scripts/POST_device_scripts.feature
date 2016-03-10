Feature: POST /device_scripts
  In order to add a device script to the system
  as an API user
  I want to create a new device script

  Scenario: Create a new device script with valid properties
    Given I am authenticated as an administrator
    When I send a POST request to "/device_scripts" with the following:
        """
        {
          "name": "Print",
          "description": "Write a message",
          "script": "msg = 'Hello world!'",
          "enabled": true
        }
        """
    Then the response status should be "201"
    And the JSON response should have "id"
    And I should see the following device_script in the database:
      | name        | Print                |
      | description | Write a message      |
      | script      | msg = 'Hello world!' |
    And the device script is now enabled

  Scenario: Create a new device script with invalid properties
    Given I am authenticated as an administrator
    When I send a POST request to "/device_scripts" with the following:
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
    And I should see 0 device_scripts in the database

  Scenario: Create an device script without being authenticated
    When I send a POST request to "/device_scripts" with the following:
        """
        {
          "name": "Print",
          "script": "msg = 'Hello world!'"
        }
        """
    Then the response status should be "401"
