source 'https://supermarket.chef.io'

metadata

group :integration do
  cookbook 'git'
end

cookbook 'ssh_known_hosts',
         git:  'git@github.com:kierenevans/chef-ssh-known-hosts.git',
         ref:  'release/0.2.0'
