#!/bin/bash

set -e

echo
echo
echo "!!! Dont forget to add your PUBLIC ssh key into files/authorized_keys !!!"
echo "!!! Otherwise, you will lose access to the host !!!"
echo
echo "!!! Look at README.md before run !!!"
echo
echo "Sleep for 3 sec..."
echo
echo

sleep 3

read -p "Press enter to continue..."

#
# ansible-playbook -i inventory/ playbook.yml --diff --limit vpn --extra-vars='reboot=yes' --tags basic,auth,vpn --ask-become-pass
#
# --extra-vars='reboot=yes'  - reboot after applying
# --ask-become-pass          - ask for sudo password before applying
#

ansible-playbook -i inventory/ playbook.yml --diff --limit vpn --tags basic,auth,vpn --extra-vars='reboot=yes'
