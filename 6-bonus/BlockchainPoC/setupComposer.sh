#!/bin/bash
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Usage:
#
# ./setupComposer.sh
#
# User must then logout and login upon completion of script
#

# Exit on any failure
set -e

sudo chmod 777 /var/run/docker.sock

#Note that you should not use su or sudo for the following npm commands.
#---------------------------------------------------------------------
# Essential CLI tools:
npm install -g composer-cli@0.20

# Utility for running a REST Server on your machine to expose your business networks as RESTful APIs:
npm install -g composer-rest-server@0.20

# Useful utility for generating application assets:
npm install -g generator-hyperledger-composer@0.20

# Yeoman is a tool for generating applications, which utilises generator-hyperledger-composer:
npm install -g yo
#-----------------------------------------------------------------------

#Install Playground
npm install -g composer-playground@0.20

#In a directory of your choice (we will assume ~/fabric-dev-servers), get the .tar.gz file that contains the tools to install Hyperledger Fabric:
mkdir ~/fabric-dev-servers && cd ~/fabric-dev-servers

curl -O https://raw.githubusercontent.com/hyperledger/composer-tools/master/packages/fabric-dev-servers/fabric-dev-servers.tar.gz
tar -xvf fabric-dev-servers.tar.gz

cd ~/fabric-dev-servers
export FABRIC_VERSION=hlfv12
./downloadFabric.sh


cd ~/fabric-dev-servers
export FABRIC_VERSION=hlfv12
./startFabric.sh
./createPeerAdminCard.sh

composer-playground

