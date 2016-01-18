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

When(/^I run sudo with an authorised command$/) do
  @sudo_dir = '/var/www/test'
  cmd = "sudo mkdir -p #{@sudo_dir}"
  sudo_command = `sudo -n -u #{@deploy_user} bash -c '#{cmd}' 2>&1`
end

When(/^I run sudo with an unauthorised command$/) do
  cmd = "sudo -n useradd inviqa-test"
  @useradd = `sudo -u #{@deploy_user} bash -c '#{cmd}' 2>&1`
end

Then(/^the incident is not reported$/) do
  dir = ::File.directory?(@sudo_dir)
  expect(dir).to be_truthy
end

Then(/^the command fails$/) do
  expect(@useradd).to match('sudo: a password is required')
end
