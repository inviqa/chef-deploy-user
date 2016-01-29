Feature: Add github to known hosts file
  In order to allow deployment from github non-interactively
  As a sysadmin
  I need to ensure github is a known host

Scenario: github is added to user known hosts
  Given the deploy user is "deploy"
  And git is installed on the server
  When I checkout my private repository
  Then I am not asked to verify the host

Scenario: deploy user has sudo
  Given the deploy user is "deploy"
  When I run sudo with an authorised command
  Then the incident is not reported

Scenario: deploy user has sudo limited to certain commands
  Given the deploy user is "deploy"
  When I run sudo with an unauthorised command
  Then the command fails

Scenario: an unprivileged user may run commands as deploy
  Given the deploy user is "deploy"
  And the test user is "deployer1"
  When I run sudo as "deployer1" to "deploy"
  Then the command succeeds

Scenario: an unprivileged user in an authorised group may run commands as deploy
  Given the deploy user is "deploy"
  And the test user is "deployer2" in the "deployer" group
  When I run sudo as "deployer2" to "deploy"
  Then the command succeeds

  Scenario: an unprivileged user in an authorised group specified by gid may run commands as deploy
    Given the deploy user is "deploy"
    And the test user is "deployer3" in the "deployer2" group
    And the "deployer2" group has gid of "7001"
    When I run sudo as "deployer2" to "deploy"
    Then the command succeeds
