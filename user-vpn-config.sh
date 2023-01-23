#!/bin/bash

set -e

invFile="inventory/hosts"
caCert="files/crt/ca.crt"
template="user-vpn-config.template"

if [ "$1" == "" ];
then
    echo "./$0 <name of the server from inventory file ${invFile}>"
    echo "./$0 vpn01"
    exit 1
else
    vHost=${1}
fi

ip=$(cat ${invFile} | grep -E "^${vHost}.*ansible_host" | cut -d " " -f 2 | cut -d "=" -f 2)

cat ${template} | sed 's/{{SERVER_ADDR}}/'$ip'/g' > user-vpn.conf
echo >> user-vpn.conf
echo "<ca>" >> user-vpn.conf
cat ${caCert} >> user-vpn.conf
echo "</ca>" >> user-vpn.conf
echo >> user-vpn.conf
