# 3-virtual-machines

Azure Virtual Machines provides on-demand, high-scale, secure, virtualized infrastructure using your desired operating system choice.

This template deploys one or more Virtual Machine(s) to an existing Virtual Network/Subnet.

## Prerequisites

To deploy this quickstart template, you need the following:
* **Azure subscription**. 
  * If you don't have one yet, you can <a href="https://azure.microsoft.com/pricing/member-offers/msdn-benefits-details/">activate your MSDN subscriber benefits</a> or <a href="https://azure.microsoft.com/free">sign up for a free account</a>.
* **Azure Virtual Network**. 
  * If you don't have an Azure Virtual Network, please follow the <a href="https://github.com/jasonvriends/azure-quickstart/tree/master/2-virtual-network">virtual-network</a> quickstart template.

## Features/Capabilities
* Ability to specify a desired instance size.
* Ability to specify osPublisher, osOffer, osSKU, and osVersion.
* Ability to specify the number of Virtual Machines instances to create.
* Ability to specify a Custom Script Extension/Command for automated installations.
* Ability to specify either password or PSK authentication.
* Ability to specify a Virtual Network and Subnet.
* Ability to specify a public or private ip address.

## Common Windows VM Images

| osPublisher              | osOffer         | osSku                             |
| ------------------------ | --------------- | --------------------------------- | 
| MicrosoftWindowsServer   | WindowsServer   | 2019-Datacenter                   | 
| MicrosoftWindowsServer   | WindowsServer   | 2019-Datacenter-Core              |
| MicrosoftWindowsServer   | WindowsServer   | 2019-Datacenter-with-Containers   |
| MicrosoftWindowsServer   | WindowsServer   | 2016-Datacenter                   |
| MicrosoftWindowsServer   | WindowsServer   | 2016-Datacenter-Server-Core       |
| MicrosoftWindowsServer   | WindowsServer   | 2016-Datacenter-with-Containers   |
| MicrosoftWindowsServer   | WindowsServer   | 2012-R2-Datacenter                |
| MicrosoftWindowsServer   | WindowsServer   | 2012-Datacenter                   |

## Common Linux VM Images

| osPublisher | osOffer       | osSku     |
| ----------- | :------------ | --------- | 
| OpenLogic   | CentOS        | 7.5       |
| CoreOS      | CoreOS        | Stable    |
| credativ    | Debian        | 9         |
| SUSE        | openSUSE-Leap | 42.3      |
| RedHat      | RHEL          | 7-RAW     |
| SUSE        | SLES          | 15        |
| Canonical   | UbuntuServer  | 18.04-LTS |

## Deployment Options

### Azure Portal

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjasonvriends%2Fazure-quickstart%2Fmaster%2F3-virtual-machines%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fjasonvriends%2Fazure-quickstart%2Fmaster%2F3-virtual-machines%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a><br/>

### Azure PowerShell

```powershell

# Azure Subscription Configuration
$AzureRegion="eastus"                         # Input the Azure Region to deploy the resources to (i.e. canadaeast, canadacentral, eastus, etc.).
$AzureEnvironment="innovation"                # Input the prefix for your Azure Innovation Lab (i.e. dev, tst, prod, innovation, etc.).
$ResourceGroupName="desktops"                 # Input the prefix for the resource group to deploy this quickstart template into.

# Template Parameters
$dnsLabelPrefix="winsvr"                      # Input your desired Virtual Machine dns label prefix. Note: a suffix of -vm is appended to the Virtual Machine name."
$size="Standard_D2s_v3"                       # Input your desired Virtual Machine instance size (e.g. Standard_B1ms).
$osPublisher="MicrosoftWindowsServer"         # Input the organization that created the image (e.g. MicrosoftWindowsServer, Canonical).
$osOffer="WindowsServer"                      # Input the name of a group of related images created by a publisher (e.g. UbuntuServer, WindowsServer, etc.).
$osSKU="2019-Datacenter"                      # Input the name of An instance of an offer, such as a major release of a distribution (e.g. 16.04-LTS, 2016-Datacenter, etc.).
$osVersion="latest"                           # Input the version number of an image SKU.
$instances=1                                  # Input your desired Virtual Machine instances.
$extensionUri=""                              # Input the fileuri to your desired Custom Script Extension. Note: As of 2019-01-24 this has only been tested on Ubuntu Linux.
$extensionCommand=""                          # Input the command to execute of your desired Custom Script Extension. Note: As of 2019-01-24 this has only been tested on Ubuntu Linux.
$adminUsername="vmadmin"                      # Input your desired Virtual Machine administrator username.
$authenticationType="password"                # Select your desired Virtual Machine authentication type (password or publickey).
$pwdOrPsk="@Canada2019@"                      # Input your desired Virtual Machine administrator password or SSH Public Key.
$vnetName="innovation-vnet"                   # Input your desired Virtual Network name.
$vnetSubnetName="desktops-subnet"             # Input the name of your Virtual Network subnet.
$vnetResourceGroup="networking-innovation-rg" # Input the Resource Group where your Virtual Network resides.
$ipAddress="private"                          # Select your desired ip address type (private or public).

# Resource Group Creation
$DeploymentResourceGroup="$ResourceGroupName-$AzureEnvironment-rg"
$pwdOrPskSecureString=ConvertTo-SecureString $pwdOrPsk -AsPlainText -Force
New-AzureRmResourceGroup -Name "$DeploymentResourceGroup" -Location "$AzureRegion" -ErrorVariable notCreated -ErrorAction SilentlyContinue

# Template Deployment to Resource Group
$TemplateUri="https://github.com/jasonvriends/azure-quickstart/raw/master/3-virtual-machines/azuredeploy.json"
New-AzResourceGroupDeployment -Name "deploy-$dnsLabelPrefix" -ResourceGroupName "$DeploymentResourceGroup" -TemplateUri "$TemplateUri" -dnsLabelPrefix "$dnsLabelPrefix" -size "$size" -ospublisher "$osPublisher" -osOffer "$osOffer" -osSKU "$osSKU" -osVersion "$osVersion" -instances $instances -extensionUri "$extensionUri" -extensionCommand "$extensionCommand" -adminUsername "$adminUsername" -authenticationType "$authenticationType" -pwdOrPsk $pwdOrPskSecureString -vnetName "$vnetName" -vnetSubnetName "$vnetSubnetName" -vnetResourceGroup "$vnetResourceGroup" -ipAddress "$ipAddress"


```

### Azure CLI

```shell

# Azure Subscription Configuration
AzureRegion="eastus"                         # Input the Azure Region to deploy the resources to (i.e. canadaeast, canadacentral, eastus, etc.).
AzureEnvironment="innovation"                # Input the prefix for your Azure Innovation Lab (i.e. dev, tst, prod, innovation, etc.).
ResourceGroupName="desktops"                 # Input the prefix for the resource group to deploy this quickstart template into.

# Template Parameters
dnsLabelPrefix="winsvr"                      # Input your desired Virtual Machine dns label prefix. Note: a suffix of -vm is appended to the Virtual Machine name."
size="Standard_D2s_v3"                       # Input your desired Virtual Machine instance size (e.g. Standard_B1ms).
osPublisher="MicrosoftWindowsServer"         # Input the organization that created the image (e.g. MicrosoftWindowsServer, Canonical).
osOffer="WindowsServer"                      # Input the name of a group of related images created by a publisher (e.g. UbuntuServer, WindowsServer, etc.).
osSKU="2019-Datacenter"                      # Input the name of An instance of an offer, such as a major release of a distribution (e.g. 16.04-LTS, 2016-Datacenter, etc.).
osVersion="latest"                           # Input the version number of an image SKU.
instances=1                                  # Input your desired Virtual Machine instances.
extensionUri=""                              # Input the fileuri to your desired Custom Script Extension. Note: As of 2019-01-24 this has only been tested on Ubuntu Linux.
extensionCommand=""                          # Input the command to execute of your desired Custom Script Extension. Note: As of 2019-01-24 this has only been tested on Ubuntu Linux.
adminUsername="vmadmin"                      # Input your desired Virtual Machine administrator username.
authenticationType="password"                # Select your desired Virtual Machine authentication type (password or publickey).
pwdOrPsk="@Canada2019@"                      # Input your desired Virtual Machine administrator password or SSH Public Key.
vnetName="innovation-vnet"                   # Input your desired Virtual Network name.
vnetSubnetName="desktops-subnet"             # Input the name of your Virtual Network subnet.
vnetResourceGroup="networking-innovation-rg" # Input the Resource Group where your Virtual Network resides.
ipAddress="private"                          # Select your desired ip address type (private or public).

# Resource Group Creation
DeploymentResourceGroup="$ResourceGroupName-$AzureEnvironment-rg"
az group create -n "$DeploymentResourceGroup" -l "$AzureRegion"

# Template Deployment to Resource Group
TemplateUri="https://github.com/jasonvriends/azure-quickstart/raw/master/3-virtual-machines/azuredeploy.json"
az group deployment create --name "deploy-$dnsLabelPrefix" --resource-group "$DeploymentResourceGroup" --template-uri "$TemplateUri" --parameters dnsLabelPrefix="$dnsLabelPrefix" size="$size" osPublisher="$osPublisher" osOffer="$osOffer" osSKU="$osSKU" osVersion="$osVersion" instances=$instances extensionUri="$extensionUri" extensionCommand="$extensionCommand" adminUsername="$adminUsername" authenticationType="$authenticationType" pwdOrPsk="$pwdOrPsk" vnetName="$vnetName" vnetSubnetName="$vnetSubnetName" vnetResourceGroup="$vnetResourceGroup" ipAddress="$ipAddress"


```
