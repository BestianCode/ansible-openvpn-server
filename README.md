# Easy personal OpenVPN Server with login/password authentication

### Install Ansible, configure ssh and etc...

* You have to know how to do it on your OS or you can look at the google.com :)
* Also you have to know what is Linux, SSH, and how networks work :)

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
* Put group with your server to group `rus` (Russia) in case it is run inside of Russia, or into `ext` (External) if the server is outside of Russia

#### Ansible Variables

* `groups_vars/all`:
  1. `managerName` - Ansible will create this user with UID `managerUID` for accessing the server with ssh. This action is needed if you access your server with user `root`. Ssh access for user `root` will be blocked. If you already have a user, just specify the user name, groups, UID, and GID in the variables. It will not be recreated.
  2. `sshPort` - I recommend not using default port `22` due to bots permanently trying to connect to this port and it causes a lot of trash in security/auth logs. Better to use something else. By default I set `65432`

#### Ansible files

* Put your PUBLIC ssh key into the file `files/authorized_keys`
* `templates/server.conf.j2` - OpenVPN Server config
* `files/crt/` - There are keys and certificates for OpenVPN Server. Please, use `EasyRSA` tool to create your own ca, DH, and server certs and keys. It is not safe to use these sample files from this repo! Use them only for testing purposes.

#### How to run

* `ansible-playbook -i inventory/ playbook.yml --diff --limit vpn --tags basic,auth,vpn --extra-vars='reboot=yes'`
* `--extra-vars='reboot=yes'` - Reboot the host after the playbook will be finished the first time
* `--ask-become-pass` - Ask for sudo password before run
* `ansible-playbook -i inventory/ playbook.yml --diff` - Just normal run without reboot.

* __Or just use the script__: `./playbook.sh`

* If you don't want to reconfigure ssh and user access on your VM, exclude tag auth from ansible command line: `ansible-playbook -i inventory/ playbook.yml --diff --limit vpn --tags basic,vpn --extra-vars='reboot=yes'`

---
### Important !!!

__**fatal: [vpn01]: UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: ssh: connect to host 123.45.67.8 port 22: Connection refused", "unreachable": true}**__

* If you see something like this after the first run, just update the file `inventory/hosts` with data from variables `managerName` and `sshPort` from the file `groups_vars/all`!
```
[vpn]
# OLD
vpn01 ansible_host=vpn01.mydomain.org ansible_user=root ansible_port=22
# NEW
vpn01 ansible_host=vpn01.mydomain.org ansible_user=admin ansible_port=65432
```

### How to manage users and config

* If you correctly set all variables and hosts in `inventory/hosts`, configured and rebooted the server, you can create users and VPN config
* `./user-add.sh vpn01` - __vpn01__ is the name of the server from `inventory/hosts`. Enter the username and password.
* `./user-del.sh vpn01` - Enter a user name, and the user will be deleted.
* `./user-vpn-config.sh vpn01` - Config will be generated and written into the root folder of the project with the name `user-vpn.conf`. Use this config with your OpenVPN client.
* `./ssh.sh vpn01` - Just connect to the VM
* `./playbook-run-example.sh` - Just run ansible with reboot of the VM
