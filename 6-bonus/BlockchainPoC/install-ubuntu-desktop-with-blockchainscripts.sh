#!/bin/bash

# ===================================================================
# Purpose:           To automate the install of xRDP and GNOM and download latest Blockchain/Hyperledger
#                    Fabric setup scripts.
# Parameters:        None
# Author:            Niruban Kandasamy
# Notes:             Tested against Ubuntu 18.04-LTS on Microsoft Azure as a Linux Custom Script Extension.
# ===================================================================

# Update package list
apt-get update

# Install GNOME
apt-get install -y ubuntu-gnome-desktop

# Install XRDP
apt-get install -y xrdp

# Disable newcursors because black background around cursor is displayed if using Xorg as session type.
sed -e 's/^new_cursors=true/new_cursors=false/g' -i /etc/xrdp/xrdp.ini
systemctl restart xrdp

# Create ~/.xsessionrc Create ~/.xsessionrc which will export the environment variable for customized settings for Ubuntu.
D=/usr/share/ubuntu:/usr/local/share:/usr/share:/var/lib/snapd/desktop
cat <<EOF > ~/.xsessionrc
export GNOME_SHELL_SESSION_MODE=ubuntu
export XDG_CURRENT_DESKTOP=ubuntu:GNOME
export XDG_DATA_DIRS=${D}
export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg
EOF

# Authentication Required Dialog If using Xorg as session type, Authentication Required dialog will be displayed after creating session.
cat <<EOF | tee /etc/polkit-1/localauthority/50-local.d/xrdp-color-manager.pkla
[Netowrkmanager]
Identity=unix-user:*
Action=org.freedesktop.color-manager.create-device
ResultAny=no
ResultInactive=no
ResultActive=yes
EOF

sudo systemctl restart polkit

# Install GNOME Extensions

## Download Taskbar
wget -O /tmp/taskbar.zip "https://extensions.gnome.org/review/download/8043.shell-extension.zip"

## Extract TaskBar
sudo mkdir -p /usr/share/gnome-shell/extensions/TaskBar@zpydr/
sudo unzip /tmp/taskbar.zip -d /usr/share/gnome-shell/extensions/TaskBar@zpydr/

## Enable TaskBar
gsettings get org.gnome.shell enabled-extensions
gsettings set org.gnome.shell enabled-extensions "['netspeed@hedayaty.gmail.com', 'weather-extension@xeked.com', 'TaskBar@zpydr']"

cd /home/vmadmin/

## Download and set chmod 755 to Hyperledger composer prereqs script
curl -O https://hyperledger.github.io/composer/latest/prereqs-ubuntu.sh
chmod a+x prereqs-ubuntu.sh

## Download and set chmod 755 to Hyperledger composer setup script
wget https://raw.githubusercontent.com/nirubank/azure-virtualmachine-extensions/master/setupComposer.sh
chmod a+x setupComposer.sh

## Download and set chmod 755 to Visual studio code setup script
wget https://raw.githubusercontent.com/nirubank/azure-virtualmachine-extensions/master/install-vscode.sh
chmod a+x install-vscode.sh

wget https://raw.githubusercontent.com/nirubank/dltWorkshop/master/BlockchainOnCloudLabGuide.docx
