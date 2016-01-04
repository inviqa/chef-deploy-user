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
  it { should be_file }
  it { should be_owned_by 'deploy' }
  its(:sha256sum) { should eq 'c3088e39cb3f6d127b2f86f212b73dc89dc973d13f1b15dd27ce56e73adb8f52' }
end

describe file('/etc/deploy/.ssh/known_hosts') do
  it { should be_file }
  its(:content) { should match 'github.com,192.30.252.128 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==' }
end
