@javascript
Feature: Show dashboard after login

  Background:

    Given a user with a default dashboard

  Scenario:

    When i log in
    Then i see the dashboard
