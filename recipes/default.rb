#
# Cookbook Name:: deploy-user
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

ssh_dir_path          = "#{node['deploy_user']['home']}/.ssh"
ssh_known_hosts_path  = "#{ssh_dir_path}/known_hosts"

group node['deploy_user']['group'] do
  gid node['deploy_user']['gid']
end

user node['deploy_user']['user'] do
   gid node['deploy_user']['gid']
   shell node['deploy_user']['shell'] if node['deploy_user']['shell']
   home node['deploy_user']['home'] if node['deploy_user']['home']
   manage_home node['deploy_user']['manage_home']
   action :create
end

user node['deploy_user']['user'] do
   action :lock
end

directory ssh_dir_path do
  owner   node['deploy_user']['user']
  group   node['deploy_user']['gid']
  mode    "0700"
  action  :create
end

file ssh_known_hosts_path do
  owner   node['deploy_user']['user']
  group   node['deploy_user']['gid']
  mode    "0644"
  action  :create
end

node['deploy_user']['ssh_known_hosts_entries'].each do | known_host_entry |
  ssh_known_hosts_entry known_host_entry do
    path ssh_known_hosts_path
    key_type known_host_entry[:key_type]
    host known_host_entry[:host]
    key known_host_entry[:key]
  end
end

sudo 'deploy_permissions' do
  group node['deploy_user']['user']
  runas node['deploy_user']['group']
  nopasswd true
end
