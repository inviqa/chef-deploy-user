#
# Cookbook Name:: deploy-user
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'deploy-user::default' do
  deploy_home_dir = '/etc/deploy'
  deploy_ssh_dir = "#{deploy_home_dir}/.ssh"

  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    before do
      stub_command('passwd -S deploy').and_return(0)
    end
    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates a group with the default action' do
      expect(chef_run).to create_group('deploy').with(gid: 3000)
    end

    it 'should create the deploy user' do
      expect(chef_run).to create_user('Create deploy user').with(
        username: 'deploy',
        gid: 3000,
        home: deploy_home_dir,
        shell: '/sbin/nologin',
        manage_home: true
      )
    end

    it 'locks a user with an explicit action' do
      expect(chef_run).to lock_user('Lock deploy user').with(
        username: 'deploy'
      )
    end

    it 'creates deploy_permissions with sudo' do
      expect(chef_run).to install_sudo('deploy').with(
        user: 'deploy',
        defaults: ['!requiretty'],
        nopasswd: true
      )
    end

    it 'should set up the known hosts file' do
      expect(chef_run).to create_directory(deploy_ssh_dir).with(
        owner: 'deploy',
        group: 3000,
        mode: '0700'
      )
      expect(chef_run).to create_file("#{deploy_ssh_dir}/known_hosts").with(
        owner: 'deploy',
        group: 3000,
        mode: '0644'
      )
    end
  end

  context 'without a shell specified' do
    before do
      stub_command('passwd -S deploy').and_return(252)
    end
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new do |node|
        node.set['deploy_user']['shell'] = false
      end
      runner.converge(described_recipe)
    end

    it 'should still create the user' do
      expect(chef_run).to create_user('deploy')
    end

    it 'should not send through the shell to the user provider' do
      expect(chef_run.user('deploy').shell).to be_nil
    end
  end

  context 'with ssh hosts entries' do
    deploy_known_hosts_path = "#{deploy_ssh_dir}/known_hosts"
    before do
      stub_command('passwd -S deploy').and_return(252)
    end
    rsa_key = {
      key_type: 'rsa',
      host: 'example.com',
      key: 'a key that is not real'
    }

    dsa_key = {
      key_type: 'dsa',
      host: 'example.net',
      key: 'another key that is not real'
    }

    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new do |node|
        node.set['deploy_user']['ssh_known_hosts_entries'] = [
          rsa_key,
          dsa_key
        ]
      end
      runner.converge(described_recipe)
    end

    it 'should create a ssh known hosts entry' do
      expect(chef_run).to create_ssh_known_hosts_entry('example.com').with(
        path: deploy_known_hosts_path,
        key_type: rsa_key[:key_type],
        key: rsa_key[:key]
      )
    end

    it 'should create a second ssh known hosts entry' do
      expect(chef_run).to create_ssh_known_hosts_entry('example.net').with(
        path: deploy_known_hosts_path,
        key_type: dsa_key[:key_type],
        key: dsa_key[:key]
      )
    end
  end
  context 'with private keys as node attributes' do
    before do
      stub_command('passwd -S deploy').and_return(0)
    end

    private_key = {
      filename: 'foo_rsa',
      content: 'some content here'
    }

    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new do |node|
        node.set['deploy_user']['private_keys'] = [
          private_key
        ]
      end
      runner.converge(described_recipe)
    end

    it 'should create the private ssh key' do
      key_path = "#{deploy_ssh_dir}/#{private_key[:filename]}"
      expect(chef_run).to create_file(key_path)
    end
  end
end
