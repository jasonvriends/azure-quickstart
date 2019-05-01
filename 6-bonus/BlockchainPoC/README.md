# 6-bonus/Blockchain PoC

This is a basic Blockchain project that can be used as a base Blockchain framework for a PoC. This particular project deploys Hyperledger Fabric/Compose toolsets on Ubuntu desktop OS and installs all the needed tools for Blockchain development.  Once you have access to the development VM, Please use the <a href="https://raw.githubusercontent.com/jasonvriends/azure-quickstart/master/6-bonus/BlockchainPoC/BlockchainOnCloudWorkshopGuide.pdf">BlockchainOnCloudWorkshopGuide.pdf</a> document to finish off the installation. 

# Table of Contents

-   [Step 1: Prerequisites](#step-1-prerequisites)
-   [Step 2: Provision Azure Services](#step-2-provision-azure-services)
    -   [Azure Portal](#azure-portal)
    -   [Azure PowerShell](#azure-powershell)

# Step 1: Prerequisites

To deploy this quickstart template, you need the following:
* **Azure subscription**. 
  * If you don't have one yet, you can <a href="https://azure.microsoft.com/pricing/member-offers/msdn-benefits-details/">activate your MSDN subscriber benefits</a> or <a href="https://azure.microsoft.com/free">sign up for a free account</a>.
* **Azure Virtual Network**. 
  * If you don't have an Azure Virtual Network, please follow the <a href="https://github.com/jasonvriends/azure-quickstart/tree/master/2-virtual-network">virtual-network</a> quickstart template.

# Step 2: Provision Azure Services

## Azure Portal

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjasonvriends%2Fazure-quickstart%2Fmaster%2F6-bonus%2FBlockchainPoC%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fjasonvriends%2Fazure-quickstart%2Fmaster%2F6-bonus%2FBlockchainPoC%2Fazuredeploy.json"  target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a><br/>

## Azure PowerShell

```powershell

# Azure Subscription Configuration
##################################################################################################################

## Input the Azure Region to deploy the resources to (i.e. canadaeast, canadacentral, eastus, etc.).
$AzureRegion="eastus"

## Input the prefix for your Azure Innovation Lab (i.e. dev, tst, prod, innovation, etc.).
$AzureEnvironment="bonus"

## Input the prefix for the resource group to deploy this quickstart template into.
$ResourceGroupName="dltworkshop"

# Template Parameters
##################################################################################################################

# Input your desired Virtual Machine dns label prefix. Note: a suffix of -vm is appended to the Virtual Machine name."
$dnsLabelPrefix="dltworkshop"

# Input your desired Virtual Machine instance size (e.g. Standard_B1ms).
$size="Standard_E4_v3"

# Input the organization that created the image (e.g. MicrosoftWindowsServer, Canonical).
$osPublisher="Canonical"

# Input the name of a group of related images created by a publisher (e.g. UbuntuServer, WindowsServer, etc.).
$osOffer="UbuntuServer"

# Input the name of An instance of an offer, such as a major release of a distribution (e.g. 16.04-LTS, 2016-Datacenter, etc.).
$osSKU="18.04-LTS"

# Input the version number of an image SKU.
$osVersion="latest"

# Input your desired Virtual Machine instances.
$instances=1

# Input the fileuri to your desired Custom Script Extension. Note: As of 2019-01-24 this has only been tested on Ubuntu Linux.
$extensionUri="https://raw.githubusercontent.com/jasonvriends/azure-quickstart/master/6-bonus/BlockchainPoC/install-ubuntu-desktop-with-blockchainscripts.sh"

# Input the command to execute of your desired Custom Script Extension. Note: As of 2019-01-24 this has only been tested on Ubuntu Linux.
$extensionCommand="./install-ubuntu-desktop.sh"

# Input your desired Virtual Machine administrator username.
$adminUsername="vmadmin"

# Select your desired Virtual Machine authentication type (password or publickey).
$authenticationType="password"

# Input your desired Virtual Machine administrator password or SSH Public Key.
$pwdOrPsk="@Canada2019@"

# Input your desired Virtual Network name.
$vnetName="innovation-vnet"

# Input the name of your Virtual Network subnet.
$vnetSubnetName="desktops-subnet"

# Input the Resource Group where your Virtual Network resides.
$vnetResourceGroup="networking-innovation-rg"

# Select your desired ip address type (private or public).
$ipAddress="private"

# Resource Group Creation
##################################################################################################################

$DeploymentResourceGroup="$ResourceGroupName-$AzureEnvironment-rg"
$pwdOrPskSecureString=ConvertTo-SecureString $pwdOrPsk -AsPlainText -Force
New-AzureRmResourceGroup -Name "$DeploymentResourceGroup" -Location "$AzureRegion"

# Template Deployment to Resource Group
##################################################################################################################

$TemplateUri="https://raw.githubusercontent.com/jasonvriends/azure-quickstart/master/6-bonus/BlockchainPoC/azuredeploy.json"
New-AzResourceGroupDeployment -Name "deploy-dltworkshop" -ResourceGroupName "$DeploymentResourceGroup" -TemplateUri "$TemplateUri" -dnsLabelPrefix "$dnsLabelPrefix" -size "$size" -ospublisher "$osPublisher" -osOffer "$osOffer" -osSKU "$osSKU" -osVersion "$osVersion" -instances $instances -extensionUri "$extensionUri" -extensionCommand "$extensionCommand" -adminUsername "$adminUsername" -authenticationType "$authenticationType" -pwdOrPsk $pwdOrPskSecureString -vnetName "$vnetName" -vnetSubnetName "$vnetSubnetName" -vnetResourceGroup "$vnetResourceGroup" -ipAddress "$ipAddress"


```

## Azure CLI

```shell

# Azure Subscription Configuration
##################################################################################################################

## Input the Azure Region to deploy the resources to (i.e. canadaeast, canadacentral, eastus, etc.).
AzureRegion="eastus"

## Input the prefix for your Azure Innovation Lab (i.e. dev, tst, prod, innovation, etc.).
AzureEnvironment="bonus"

## Input the prefix for the resource group to deploy this quickstart template into.
ResourceGroupName="dltworkshop"

# Template Parameters
##################################################################################################################

# Input your desired Virtual Machine dns label prefix. Note: a suffix of -vm is appended to the Virtual Machine name."
dnsLabelPrefix="dltworkshop"

# Input your desired Virtual Machine instance size (e.g. Standard_B1ms).
size="Standard_E4_v3"

# Input the organization that created the image (e.g. MicrosoftWindowsServer, Canonical).
osPublisher="Canonical"

# Input the name of a group of related images created by a publisher (e.g. UbuntuServer, WindowsServer, etc.).
osOffer="UbuntuServer"

# Input the name of An instance of an offer, such as a major release of a distribution (e.g. 16.04-LTS, 2016-Datacenter, etc.).
osSKU="18.04-LTS"

# Input the version number of an image SKU.
osVersion="latest"

# Input your desired Virtual Machine instances.
instances=1

# Input the fileuri to your desired Custom Script Extension. Note: As of 2019-01-24 this has only been tested on Ubuntu Linux.
extensionUri="https://raw.githubusercontent.com/jasonvriends/azure-quickstart/master/6-bonus/BlockchainPoC/install-ubuntu-desktop-with-blockchainscripts.sh"

# Input the command to execute of your desired Custom Script Extension. Note: As of 2019-01-24 this has only been tested on Ubuntu Linux.
extensionCommand="./install-ubuntu-desktop.sh"

# Input your desired Virtual Machine administrator username.
adminUsername="vmadmin"

# Select your desired Virtual Machine authentication type (password or publickey).
authenticationType="password"

# Input your desired Virtual Machine administrator password or SSH Public Key.
pwdOrPsk="@Canada2019@"

# Input your desired Virtual Network name.
vnetName="innovation-vnet"

# Input the name of your Virtual Network subnet.
vnetSubnetName="desktops-subnet"

# Input the Resource Group where your Virtual Network resides.
vnetResourceGroup="networking-innovation-rg"

# Select your desired ip address type (private or public).
ipAddress="private"

# Resource Group Creation
##################################################################################################################

DeploymentResourceGroup="$ResourceGroupName-$AzureEnvironment-rg"
az group create -n "$DeploymentResourceGroup" -l "$AzureRegion"

# Template Deployment to Resource Group
##################################################################################################################

TemplateUri="https://raw.githubusercontent.com/jasonvriends/azure-quickstart/master/6-bonus/BlockchainPoC/azuredeploy.json"
az group deployment create --name "deploy-dltworkshop" --resource-group "$DeploymentResourceGroup" --template-uri "$TemplateUri" --parameters dnsLabelPrefix="$dnsLabelPrefix" size="$size" osPublisher="$osPublisher" osOffer="$osOffer" osSKU="$osSKU" osVersion="$osVersion" instances=$instances extensionUri="$extensionUri" extensionCommand="$extensionCommand" adminUsername="$adminUsername" authenticationType="$authenticationType" pwdOrPsk="$pwdOrPsk" vnetName="$vnetName" vnetSubnetName="$vnetSubnetName" vnetResourceGroup="$vnetResourceGroup" ipAddress="$ipAddress"


```


