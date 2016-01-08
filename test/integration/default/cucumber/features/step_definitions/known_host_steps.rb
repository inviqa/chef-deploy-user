#!/usr/bin/env ruby

Given(/^the deploy user is "([^"]*)"$/) do |arg1|
  # Placeholder step
end

Given(/^git is installed on the server/) do

end

When(/^I checkout my private repository$/) do
  @git_clone = `sudo -u deploy git clone git@github.com:inviqa/chef-deploy-user.git /etc/deploy/chef-deploy-user`
end

Then(/^I am not asked to verify the host$/) do
  ::STDOUT.puts @git_clone
end

When (/^I run sudo$/) do
  @sudo_command = `sudo -u deploy sudo mkdir -p /var/www/test`
end

Then(/^the incident is not reported$/) do
  dir = ::File.directory?('/var/www/test')
  expect(dir).to be_truthy
end
