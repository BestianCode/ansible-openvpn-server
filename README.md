### Install Ansible

* You have to know how to do it on your OS or you can look at the google.com :)

### Prepare your virtual server

* Buy __Debian Linux__ VM in *DigitalOcean*, *Amazon* or somewhere else...
* Configure access to the server with __ssh key__
* Add your host or hosts into `inventory/hosts`
```
[vpn]
vpn01 ansible_host=vpn01.mydomain.org ansible_user=admin ansible_port=22
vpn02 ansible_host=12.243.116.23 ansible_user=admin ansible_port=22

[lnx:children]
vpn
```
* Keep the group `lnx` with member `vpn`, because it used for macro variables for __Linux OS__
