Feature: DELETE /floors/:id
  In order to remove superfluous floors
  as an API user
  I want to delete an existing floor

  Scenario: Delete an existing floor
    Given a building with id "BUILDING_ID"
    And that building has a floor with id "FLOOR_ID"
    And I am authenticated as an administrator
    When I send a DELETE request to "/buildings/%{BUILDING_ID}/floors/%{FLOOR_ID}"
    Then the response status should be "204"
    And I should see 0 floors in the database

  Scenario: Delete a not existing floor
    Given a building with id "BUILDING_ID"
    Given I am authenticated as an administrator
    When I send a DELETE request to "/buildings/%{BUILDING_ID}/floors/-1"
    Then the response status should be "404"

  Scenario: Delete a floor without being authenticated
    Given a building with id "BUILDING_ID"
    And that building has a floor with id "FLOOR_ID"
    When I send a DELETE request to "/buildings/%{BUILDING_ID}/floors/%{FLOOR_ID}"
    Then the response status should be "401"
