Feature: DELETE /buildings/:id
  In order to remove superfluous buildings
  as an API user
  I want to delete an existing building

  Scenario: Delete an existing building
    Given a building with id "BUILDING_ID"
    And I am authenticated as an administrator
    When I send a DELETE request to "/buildings/%{BUILDING_ID}"
    Then the response status should be "204"
    And I should see 0 buildings in the database

  Scenario: Delete a not existing building
    Given I am authenticated as an administrator
    When I send a DELETE request to "/buildings/-1"
    Then the response status should be "404"

  Scenario: Delete a building without being authenticated
    Given a building with id "BUILDING_ID"
    When I send a DELETE request to "/buildings/%{BUILDING_ID}"
    Then the response status should be "401"
