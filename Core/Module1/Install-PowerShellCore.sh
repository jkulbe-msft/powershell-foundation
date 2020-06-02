#!/bin/sh
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl -o /etc/apt/sources.list.d/microsoft.list https://packages.microsoft.com/config/ubuntu/16.04/prod.list
apt-get update
apt-get install -y powershell