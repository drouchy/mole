Feature: Command line
  As a user
  I want to have a friendly command line tool
  So I can delighted when I use it

  Background:
    Given I have a regular config file

  Scenario: no command
    When I run mole with no argument
    Then the exit status should be 0
    And the output should contain the usage test

  Scenario: invalid command
    When I run mole with an invalid command
    Then the exit status should be 0
    And the output should contain the usage test

  Scenario: help command
    When I run mole with 'help'
    Then the exit status should be 0
    And the output should contain the usage test
