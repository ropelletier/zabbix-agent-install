#!/bin/bash
### A hacked together script to install zabbix agent on debian or ubuntu ditros #####
source .env
if [ -f /etc/os-release ]; then
    . /etc/os-release
    NAME="${NAME,,}"
    NAME=${NAME//' gnu/linux'}
    echo "Distributor: $NAME"
    echo "Version: $VERSION_ID"
elif command -v lsb_release &> /dev/null; then
    NAME=$(lsb_release -i -s)
    NAME="${NAME,,}"
    NAME=${NAME//' gnu/linux'}
    VERSION_ID=$(lsb_release -r -s)
    echo "Distributor: $NAME"
    echo "Version: $VERSION_ID"
else
    echo "Could not determine OS version using standard methods."
    cat /etc/issue
fi

rm -Rf zabbix-release_latest*
wget https://repo.zabbix.com/zabbix/${Zabbix_Version}/release/$NAME/pool/main/z/zabbix-release/zabbix-release_latest_${Zabbix_Version}+$NAME${VERSION_ID}_all.deb
sudo dpkg -i zabbix-release_latest_${Zabbix_Version}+$NAME${VERSION_ID}_all.deb
sudo apt update
sudo apt install zabbix-agent -y
source .env

# Create Conf File
echo "PidFile=$PidFile
LogFile=$LogFile
LogFileSize=$LogFileSize
# DebugLevel=3
LogRemoteCommands=$LogRemoteCommands
Server=$Server
ServerActive=$ServerActive
HostnameItem=$HostnameItem
HostMetadata=$HostMetadata
HostMetadataItem=$HostMetadataItem
Include=$Include" | sudo tee /etc/zabbix/zabbix_agentd.conf

sudo systemctl restart zabbix-agent
sudo systemctl enable zabbix-agent


