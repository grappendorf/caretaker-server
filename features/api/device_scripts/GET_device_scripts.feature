Feature: GET /device_scripts
  In order to get information about the device scripts
  as an API user
  I want to list them

  Scenario: Get a list of all device scripts
    Given the following device_script with id "DEVICE_SCRIPT_1_ID":
      | name        | Script 1       |
      | description | Do something 1 |
      | script      | puts '1'       |
      | enabled     | true           |
    And the following device_script with id "DEVICE_SCRIPT_2_ID":
      | name        | Script 2       |
      | description | Do something 2 |
      | script      | puts '2'       |
      | enabled     | false          |
    And I am authenticated as an administrator
    When I send a GET request to "/device_scripts"
    Then the response status should be "200"
    And the JSON response should be:
      """
      [
        {
          "id": %{DEVICE_SCRIPT_1_ID},
          "name": "Script 1",
          "description": "Do something 1",
          "enabled": true
        },
        {
          "id": %{DEVICE_SCRIPT_2_ID},
          "name": "Script 2",
          "description": "Do something 2",
          "enabled": false
        }
      ]
      """

  Scenario: Get a list of all device scripts when there are no device_scripts
    Given I am authenticated as an administrator
    When I send a GET request to "/device_scripts"
    Then the response status should be "200"
    And the JSON response should be:
      """
      []
      """

  Scenario: Get a list of all device scripts without being authenticated
    When I send a GET request to "/device_scripts"
    Then the response status should be "401"
