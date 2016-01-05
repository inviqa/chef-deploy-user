#!/usr/bin/env ruby

Given(/^the deploy user is "([^"]*)"$/) do |arg1|
  # Placeholder step
end

When(/^I checkout a repository$/) do
  git_clone = `git clone git@github.com:inviqa/chef-deploy-user.git`
end

Then(/^I am not asked to verify the host$/) do
  ::STDOUT.puts git_clone
end
