#!/bin/bash

# ===================================================================
# Purpose:           To automate the install of the Visual Studio Code
# Parameters:        None
# Author:            Jason Vriends
# Notes:             Tested against Ubuntu 18.04-LTS on Microsoft Azure as a Linux Custom Script Extension.
# ===================================================================

# Add Microsoft repository
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

# Update the package cache
sudo apt-get install apt-transport-https -y
sudo apt-get update
sudo apt-get install code -y
