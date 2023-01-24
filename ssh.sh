#!/bin/bash

set -e

invFile="inventory/hosts"

if [ "$1" == "" ];
then
    echo "./$0 <name of the server from inventory file ${invFile}>"
    echo "./$0 vpn01"
    exit 1
else
    vHost=${1}
fi

ip=$(cat ${invFile} | grep -E "^${vHost}.*ansible_host" | cut -d " " -f 2 | cut -d "=" -f 2)
login=$(cat ${invFile} | grep -E "^${vHost}.*ansible_host" | cut -d " " -f 3 | cut -d "=" -f 2)
port=$(cat ${invFile} | grep -E "^${vHost}.*ansible_host" | cut -d " " -f 4 | cut -d "=" -f 2)

ssh -p ${port} ${login}@${ip}
