require 'spec_helper'

describe group('deploy') do
  it { should exist }
  it { should have_gid 3000 }
end

describe user('deploy') do
  it { should exist }
  it { should belong_to_group 'deploy' }
end

describe user('deploy') do
  its(:encrypted_password) { should match(/^(!|\*){1}/) }
end

describe user('deploy') do
  it { should have_home_directory '/etc/deploy' }
end

describe user('deploy') do
  it { should have_login_shell '/sbin/nologin' }
end

describe file('/etc/deploy/.ssh/id_rsa') do
  sha256 = '293674fde6378bb22ce090ff9a901592ec0fc79a8c4fae790a204d3b80bea332'
  it { should be_file }
  it { should be_owned_by 'deploy' }
  its(:sha256sum) { should eq sha256 }
end

describe file('/etc/deploy/.ssh/known_hosts') do
  it { should be_file }
  hosts = [
    'github.com',
    '192.30.252.128',
    '192.30.252.129',
    '192.30.252.130',
    '192.30.252.131'
  ]
  key_type = 'ssh-rsa'
  key = 'AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7h'
  entry = "#{hosts.join(',')} #{key_type} #{key}"
  its(:content) { should match entry }
end

describe file('/etc/sudoers.d/deploy_permissions') do
  it { should be_file }
  its(:content) { should match(/deploy ALL=\(ALL\)/) }
end
