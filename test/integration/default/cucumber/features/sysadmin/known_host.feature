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
  When I run sudo
  Then the incident is not reported
