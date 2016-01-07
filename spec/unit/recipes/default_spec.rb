#
# Cookbook Name:: deploy-user
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'deploy-user::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates a group with the default action' do
      expect(chef_run).to create_group('deploy').with(gid: 3000)
    end

    it 'should create the deploy user' do
      expect(chef_run).to create_user('deploy').with(gid: 3000)
      expect(chef_run).to create_user('deploy').with(home: '/etc/deploy')
    end

    it 'locks a user with an explicit action' do
      expect(chef_run).to lock_user('deploy')
    end

    it 'creates deploy_permissions with sudo' do
      expect(chef_run).to create_file('/etc/sudoers.d/deploy_permissions')
      expect(chef_run).to render_file('/etc/sudoers.d/deploy_permissions').with_content('%deploy(/s+)!requiretty')
    end

    it 'should set up the known hosts file' do
      expect(chef_run).to create_directory('/etc/deploy/.ssh')
      expect(chef_run).to create_file('/etc/deploy/.ssh/known_hosts')
    end
  end
end
