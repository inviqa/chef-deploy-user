Feature: Add github to known hosts file
  In order to allow deployment from github non-interactively
  As a sysadmin
  I need to ensure github is a known host

Scenario: github is added to user known hosts
  Given I have provisioned the server
  And the deploy user is "deploy"
  When I checkout a repository
  Then I am not asked to verify the host
