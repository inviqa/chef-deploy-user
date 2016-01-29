Feature: Users in a deploying group may use deploy for sudo

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
And the test user is "deployer1" in the "deploysolo" group
When I run sudo as "deployer1" to "deploy"
Then the command succeeds

Scenario: an unprivileged user in an authorised group may run commands as deploy
Given the deploy user is "deploy"
And the test user is "deployer2" in the "deployergroup1" group
When I run sudo as "deployer2" to "deploy"
Then the command succeeds

Scenario: an unprivileged user in an authorised group specified by gid may run commands as deploy
Given the deploy user is "deploy"
And the test user is "deployer3" in the "deployergroup2" group
And the "deployergroup2" group has gid of "7001"
When I run sudo as "deployer2" to "deploy"
Then the command succeeds
