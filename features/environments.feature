Feature: Environments
  As a user
  I want to manage environment
  So I can quickly execute commands

  Scenario: Listing environment
  Given I have a regular config file
  When I run mole with 'environments'
  Then the exit status should be 0
  And the output should contain
  """
    staging
    production

  """
