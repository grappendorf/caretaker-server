Feature: Status API

  Scenario: Get the current status of the API
    When I send a GET request to "/status"
    Then the JSON response should be {"status":"ok"}
