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
  expect(@useradd).to match(/sudo.*password.*required.*/)
end

Given(/^the test user is "([^"]*)"$/) do |test_user|
  output = `user_exists=$(id -u #{test_user} > /dev/null 2>&1; echo $?)`
  useradd = `sudo -b -n userdd #{test_user}  2>&1 &`
end

When(/^I run sudo as "([^"]*)" to "([^"]*)"$/) do |deployer, deploy_user|
  @test_dir = '/etc/foo'
  cmd = "sudo -b -n /bin/mkdir -p #{@test_dir}"
  @sudo_command = `sudo -b -n su #{deployer} && sudo -b -n -u #{deploy_user} bash -c '#{cmd}' 2>&1 &`
end

Then(/^the command succeeds$/) do
  expect(@sudo_command).not_to match(/sudo.*password.*required.*/)
  dir = ::File.directory?(@test_dir)
  expect(dir).to be_truthy
end
