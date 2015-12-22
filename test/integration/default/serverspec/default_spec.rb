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

describe file('/etc/deploy/.ssh/known_hosts') do
  it { should be_file }
end
