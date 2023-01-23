### Install Ansible

* You have to know how to do it on your OS or you can look at the google.com :)

### Prepare your virtual server

* Buy __Debian Linux__ VM in *DigitalOcean*, *Amazon* or somewhere else...
* Configure access to the server with __ssh key__
* The ssh user should be able to do `sudo su -` command without password. Or use command-line key `--ask-become-pass` to provide sudo password
* Add your host or hosts into `inventory/hosts`
```
[vpn]
vpn01 ansible_host=vpn01.mydomain.org ansible_user=root ansible_port=22
vpn02 ansible_host=12.243.116.23 ansible_user=admin ansible_port=22
```
* _!!! Before the first run use the default user name and port. Then use your `manager user name` and `port` from `sshPort` variable. Don't forget to update the file !!!_

#### Ansible Groups

* Keep the group `lnx` with member `vpn`, because it used for macro variables for __Linux OS__
* Put group with your server to group `rus` (Russia) in case it is placed inside of Russia, or into `etc` (External) if the server is outside of Russia

#### Ansible Variables

* `groups_vars/all`:
  1. `managerName` - Ansible will create this user with UID `managerUID` for accessing the server with ssh. This action is needed if you access your server with user `root`. Ssh access for user `root` will be blocked. If you already have a user, just specify the user name, groups, UID, and GID in the variables. In will not be recreated. By default I set `65432`
  2. `sshPort` - I recommend not using default port `22` due to bots permanently trying to connect to this port and it causes a lot of trash in security/auth logs. Better to use something else.

#### Ansible files

* Put your PUBLIC ssh key into the file `files/authorized_keys`

#### Important !!!

__**fatal: [vpn01]: UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: ssh: connect to host 123.45.67.8 port 22: Connection refused", "unreachable": true}**__

* If you see something like this after the first run, just update the file `inventory/hosts` with data from variables `managerName` and `sshPort` from the file `groups_vars/all`!
```
[vpn]
# OLD
vpn01 ansible_host=vpn01.mydomain.org ansible_user=root ansible_port=22
# NEW
vpn01 ansible_host=vpn01.mydomain.org ansible_user=admin ansible_port=65432
```

----------

__REMOVE SSH KEY__
