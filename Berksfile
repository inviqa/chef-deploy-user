source 'https://supermarket.chef.io'

metadata

group :integration do
  cookbook 'git'
end

cookbook 'ssh_known_hosts',
         git:  'git@github.com:shrikeh/chef-ssh-known-hosts.git',
         ref:  '0.1.0'
