# deploy-user
## Default values
These can be overridden in the environment files
```
default['deploy_user']['group']       = 'deploy'
default['deploy_user']['gid']         = 3000
default['deploy_user']['user']        = 'deploy'
default['deploy_user']['shell']       = '/sbin/nologin'
default['deploy_user']['home']        = '/etc/deploy'
default['deploy_user']['manage_home'] = true

default['deploy_user']['ssh_known_hosts_entries'] = []
```
## Deploy user private_keys and ssh_known_hosts_entries
To be added to the environment's Data Bag

```
"deploy_user": {
  "private_keys": [
    {
      "filename": "id_rsa",
      "content": "-----BEGIN RSA PRIVATE KEY-----\..........n-----END RSA PRIVATE KEY-----\n"
    }
  ],
  "ssh_known_hosts_entries": [
    {
      "host": "somehost.com,1.2.3.4,2.3.4.5"
    }
  ]
}
```
