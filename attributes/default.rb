default['deploy_user']['group']       = 'deploy'
default['deploy_user']['gid']         = 3000
default['deploy_user']['user']        = 'deploy'
default['deploy_user']['shell']       = '/sbin/nologin'
default['deploy_user']['home']        = '/etc/deploy'
default['deploy_user']['manage_home'] = true

default['deploy_user']['ssh_known_hosts']['entries'] = []
