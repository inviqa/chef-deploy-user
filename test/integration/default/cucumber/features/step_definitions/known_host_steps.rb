#!/usr/bin/env ruby

Given(/^the deploy user is "([^"]*)"$/) do |arg1|
  @deploy_user = arg1
end

Given(/^git is installed on the server/) do
end

When(/^I checkout my private repository$/) do
  repo = 'git@github.com:inviqa/chef-deploy-user.git'
  dir = '/etc/deploy/chef-deploy-user'
  cmd = "sudo -u #{@deploy_user} git clone #{repo} #{dir}"
  @git_clone = `#{cmd}`
end

Then(/^I am not asked to verify the host$/) do
  ::STDOUT.puts @git_clone
end

When(/^I run sudo$/) do
  @sudo_dir = '/var/www/test'
  cmd = "sudo mkdir -p #{@sudo_dir}"
  @sudo_command = `sudo -u #{@deploy_user} #{cmd}`
  ::STDOUT.puts @sudo_command
end

Then(/^the incident is not reported$/) do
  dir = ::File.directory?(@sudo_dir)
  expect(dir).to be_truthy
end
