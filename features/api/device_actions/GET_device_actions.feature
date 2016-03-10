Feature: GET /device_actions
  In order to get information about the device actions
  as an API user
  I want to list them

  Scenario: Get a list of all device actions
    Given the following device_action with id "DEVICE_ACTION_1_ID":
      | name        | Action 1       |
      | description | Do something 1 |
      | script      | puts '1'       |
    And the following device_action with id "DEVICE_ACTION_2_ID":
      | name        | Action 2       |
      | description | Do something 2 |
      | script      | puts '2'       |
    And I am authenticated as an administrator
    When I send a GET request to "/device_actions"
    Then the response status should be "200"
    And the JSON response should be:
      """
      [
        {
          "id": %{DEVICE_ACTION_1_ID},
          "name": "Action 1",
          "description": "Do something 1"
        },
        {
          "id": %{DEVICE_ACTION_2_ID},
          "name": "Action 2",
          "description": "Do something 2"
        }
      ]
      """

  Scenario: Get a list of all device actions when there are no device_actions
    Given I am authenticated as an administrator
    When I send a GET request to "/device_actions"
    Then the response status should be "200"
    And the JSON response should be:
      """
      []
      """

  Scenario: Get a list of all device actions without being authenticated
    When I send a GET request to "/device_actions"
    Then the response status should be "401"
