#!/usr/bin/env ruby

Given(/^the deploy user is "([^"]*)"$/) do |arg1|
  @deploy_user = arg1
end

Given(/^git is installed on the server/) do
end

When(/^I checkout my private repository$/) do
  repo = 'git@github.com:inviqa/chef-deploy-user.git'
  dir = '$(mktemp -d)'
  cmd = "sudo -u #{@deploy_user} bash -c 'git clone #{repo} #{dir}'"
  @git_clone = `#{cmd}`
end

Then(/^I am not asked to verify the host$/) do
  #::STDOUT.puts @git_clone
end
