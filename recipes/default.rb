#!/usr/bin/env ruby
#
# Cookbook Name:: deploy-user
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

def group_identifier_is_numeric(identifier)
  return (/\d+/).match(identifier.to_s)
end

def normalize_group_identifer(identifier)
  return nil if identifier == nil
  if group_identifier_is_numeric(identifier)
    identifier = '#' + identifier.to_s
  end
  return identifier
end

def sudo_file_name(deployer)
  # if the name has been specifically chosen return this
  return deployer['filename'] if deployer['filename']
  if deployer['user']
    sudo_filename = deployer['user'].to_s
  elsif deployer['group']
    sudo_filename = deployer['group'].to_s
    if group_identifier_is_numeric(deployer['group'])
      sudo_filename = 'zzz_' + sudo_filename
    end
  end
  return sudo_filename
end

ssh_dir_path          = "#{node['deploy_user']['home']}/.ssh"
ssh_known_hosts_path  = "#{ssh_dir_path}/known_hosts"

Chef::Log.debug 'Create the group with the designated GID.'
group node['deploy_user']['group'] do
  gid node['deploy_user']['gid']
end

Chef::Log.debug 'Create the deploy user.'
user node['deploy_user']['user'] do
  gid node['deploy_user']['gid']
  shell node['deploy_user']['shell'] if node['deploy_user']['shell']
  home node['deploy_user']['home'] if node['deploy_user']['home']
  manage_home node['deploy_user']['manage_home']
  action :create
end

Chef::Log.debug 'Lock the user so it cannot be directly logged into.'
user node['deploy_user']['user'] do
  action :lock
end

directory node['deploy_user']['home'] do
  owner node['deploy_user']['user']
  group node['deploy_user']['gid']
  action :create
  only_if {
    node['deploy_user']['home']
  }
end


Chef::Log.debug 'Create the deploy user SSH directory.'
directory ssh_dir_path do
  owner node['deploy_user']['user']
  group node['deploy_user']['gid']
  mode '0700'
  action :create
end

deploy_keys = node['deploy_user']['private_keys'] || []

Chef::Log.debug 'Loop through a data bag and create the SSH private keys'

known_hosts_data_bag  = node['deploy_user']['data_bag']

data_bag(known_hosts_data_bag).each do |bag_item_id|
  bag_item = Chef::EncryptedDataBagItem.load(known_hosts_data_bag, bag_item_id)
  Chef::Log.debug bag_item
  deploy_keys += bag_item['private_keys']
end if node['deploy_user']['data_bag']

deploy_keys.each do |private_key|
  file "#{ssh_dir_path}/#{private_key['filename']}" do
    content private_key['content']
    owner node['deploy_user']['user']
    group node['deploy_user']['gid']
    mode '0400'
    sensitive true
  end
end

Chef::Log.debug 'Create the known hosts file for the deploy user'
file ssh_known_hosts_path do
  owner node['deploy_user']['user']
  group node['deploy_user']['gid']
  mode '0644'
  action :create
end

Chef::Log.debug 'Add the known_host entries.'
node['deploy_user']['ssh_known_hosts_entries'].each do |known_host_entry|
  ssh_known_hosts_entry known_host_entry['host'] do
    path ssh_known_hosts_path
    key_type known_host_entry['key_type']
    key known_host_entry['key']
  end
end

Chef::Log.debug 'Allow the deploy user to have sudo.'
sudo node['deploy_user']['user'] do
  user node['deploy_user']['user']
  defaults ['!requiretty']
  commands node['deploy_user']['commands'] if node['deploy_user']['commands']
  nopasswd true
end

Chef::Log.debug 'Allow the following groups to have access to the deploy user'
node['deploy_user']['allowed_deployers'].each do |deployer|

  deployer_group = normalize_group_identifer(deployer['group'])

  sudo sudo_file_name(deployer) do
    user      deployer['user'] if deployer['user']
    group     deployer_group if deployer_group
    defaults  ['!requiretty']
    runas     node['deploy_user']['user']
    nopasswd  true
  end
end if node['deploy_user']['allowed_deployers']
