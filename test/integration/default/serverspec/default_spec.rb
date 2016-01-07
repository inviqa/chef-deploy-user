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
  its(:sha256sum) { should eq '293674fde6378bb22ce090ff9a901592ec0fc79a8c4fae790a204d3b80bea332' }
end

describe file('/etc/deploy/.ssh/known_hosts') do
  it { should be_file }
  its(:content) { should match 'github.com,192.30.252.128,192.30.252.129,192.30.252.130,192.30.252.131 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==' }
end
