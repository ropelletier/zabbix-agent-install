#!/bin/bash
source .env

wget https://repo.zabbix.com/zabbix/7.2/release/debian/pool/main/z/zabbix-release/zabbix-release_latest_7.2+debian12_all.deb
sudo dpkg -i zabbix-release_latest_7.2+debian12_all.deb
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


