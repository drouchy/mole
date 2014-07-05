Feature: Configuration
  As a user
  I want to be able to manager my configuration
  So I can easily use mole

  Scenario: no config file
    Given I don't have a config file
    When I run a valid mole command
    Then the exit status should be 2
    And the stderr should contain "no config file found. Use 'mole config init' to create one"

  Scenario: invalid config file
    Given I have an invalid config file
    When I run a valid mole command
    Then the exit status should be 3
    And the stderr should contain "invalid config file"
