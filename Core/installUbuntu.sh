#!/bin/sh
wget -q https://github.com/PowerShell/PowerShell/releases/download/v7.0.1/powershell-lts_7.0.1-1.ubuntu.18.04_amd64.deb
sudo dpkg -i powershell-lts_7.0.1-1.ubuntu.18.04_amd64.deb
# sudo apt-get install -f