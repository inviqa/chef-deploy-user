#
# Cookbook Name:: deploy-user
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

group node['deploy_user']['group'] do
  gid node['deploy_user']['gid']
end

user node['deploy_user']['user'] do
   gid node['deploy_user']['gid']
   shell node['deploy_user']['shell']
   home node['deploy_user']['home']
   manage_home node['deploy_user']['manage_home']
   action :create
end

user node['deploy_user']['user'] do
   action :lock
end

sudo 'deploy_permissions' do
  group node['deploy_user']['user']
  runas node['deploy_user']['group']
  nopasswd true
end
