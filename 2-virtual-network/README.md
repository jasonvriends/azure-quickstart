# 2-virtual-network

An Azure Virtual Network (VNet) is a representation of your own network in the cloud. It is a logical isolation of the Azure cloud dedicated to your subscription. You can use VNets to provision and manage virtual private networks (VPNs) in Azure and, optionally, link the VNets with other VNets in Azure, or with your on-premises IT infrastructure to create hybrid or cross-premises solutions. Each VNet you create has its own CIDR block, and can be linked to other VNets and on-premises networks as long as the CIDR blocks do not overlap. You also have control of DNS server settings for VNets, and segmentation of the VNet into subnets.

This template deploys a Virtual Network as per the following:

## Prerequisites

To deploy this quickstart template, you need the following:
* **Azure subscription**. 
  * If you don't have one yet, you can <a href="https://azure.microsoft.com/pricing/member-offers/msdn-benefits-details/">activate your MSDN subscriber benefits</a> or <a href="https://azure.microsoft.com/free">sign up for a free account</a>.

## Default Deployment

### Address Prefix
10.0.0.0/8

### Subnets

| Subnet Name     | Address Prefix | Description               | Network Zoning           |
| --------------- | :------------: | ------------------------- | ------------------------ |
| paz-subnet      | 10.0.1.0/24    | Entrypoint into your vnet | Public Access Zone (PAZ) |
| front-subnet    | 10.0.2.0/24    | Application tier servers  | Operational Zone (OZ)    |
| back-subnet     | 10.0.3.0/24    | Data tier servers         | Restricted Zone (RZ)     |
| desktops-subnet | 10.0.4.0/24    | Cloud Desktops            | Operational Zone (OZ)    |

### Network Security Groups
* paz-nsg
  * allows incoming **ssh**, **rdp**, **web**, and **secure web** from your specified **ip address**. 
* front-nsg
  * allows incoming **ssh** and **rdp** from **paz-subnet** [10.0.1.0/24].
  * allows incoming **all** from **back-subnet** [10.0.3.0/24] and **desktops-subnet** [10.0.4.0/24].
* back-nsg
  * allows incoming **ssh** and **rdp** from **paz-subnet** [10.0.1.0/24].
  * allows incoming **all** from **front-subnet** [10.0.2.0/24] and **desktops-subnet** [10.0.4.0/24].
* desktops-nsg
  * allows incoming **ssh** and **rdp** from **paz-subnet** [10.0.1.0/24].

## Deployment Options

### Azure Portal

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjasonvriends%2Fazure-quickstart%2Fmaster%2F2-virtual-network%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fjasonvriends%2Fazure-quickstart%2Fmaster%2F2-virtual-network%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a><br/>

### Azure PowerShell

```powershell

# Azure Subscription Configuration
$AzureRegion="eastus"              # Input the Azure Region to deploy the resources to (i.e. canadaeast, canadacentral, eastus, etc.).
$AzureEnvironment="innovation"     # Input the prefix for your Azure Innovation Lab (i.e. dev, tst, prod, innovation, etc.).
$ResourceGroupName="networking"    # Input the prefix for the resource group to deploy this quickstart template into.

# Template Parameters
$vnetName="innovation-vnet"         # Input the name of the Virtual Network.
$vnetAddressPrefix="10.0.0.0/8"     # Input the address prefix for the Virtual Network.
$subnet1Name="paz"                  # Input the name of your Public Access Zone subnet.
$subnet1AddressPrefix="10.0.1.0/24" # Input the address prefix for your Public Access Zone subnet.
$subnet2Name="front"                # Input the name of your application tier subnet.
$subnet2AddressPrefix="10.0.2.0/24" # Input the address prefix for your application tier subnet.
$subnet3Name="back"                 # Input the name of your data tier subnet.
$subnet3AddressPrefix="10.0.3.0/24" # Input the address prefix for your data tier subnet.
$subnet4Name="desktops"             # Input the name of your desktops subnet.
$subnet4AddressPrefix="10.0.4.0/24" # Input the address prefix for your desktops subnet.
$externalIp="0.0.0.0"               # Input the external IP address(s). Note: This will allow incoming traffic to the Public Access Zone from this IP address.

# Resource Group Creation
$DeploymentResourceGroup="$ResourceGroupName-$AzureEnvironment-rg"
New-AzureRmResourceGroup -Name "$DeploymentResourceGroup" -Location "$AzureRegion" -ErrorVariable notCreated -ErrorAction SilentlyContinue

# Template Deployment to Resource Group
$TemplateUri="https://github.com/jasonvriends/azure-quickstart/raw/master/2-virtual-network/azuredeploy.json"
New-AzResourceGroupDeployment -Name "deploy-vnet" -ResourceGroupName $DeploymentResourceGroup -TemplateUri $TemplateUri -vnetName "$vnetName" -vnetAddressPrefix "$vnetAddressPrefix" -subnet1Name "$subnet1Name" -subnet1AddressPrefix "$subnet1AddressPrefix" -subnet2Name "$subnet2Name" -subnet2AddressPrefix "$subnet2AddressPrefix" -subnet3Name "$subnet3Name" -subnet3AddressPrefix "$subnet3AddressPrefix" -subnet4Name "$subnet4Name" -subnet4AddressPrefix "$subnet4AddressPrefix" -externalIp $externalIp


```

### Azure CLI

```shell

# Azure Subscription Configuration
AzureRegion="eastus"           # Input the Azure Region to deploy the resources to (i.e. canadaeast, canadacentral, eastus, etc.).
AzureEnvironment="innovation"  # Input the prefix for your Azure Innovation Lab (i.e. dev, tst, prod, innovation, etc.).
ResourceGroupName="networking" # Input the prefix for the resource group to deploy this quickstart template into.

# Template Configuration
vnetName="innovation-vnet"         # Input the name of the Virtual Network.
vnetAddressPrefix="10.0.0.0/8"     # Input the address prefix for the Virtual Network.
subnet1Name="paz"                  # Input the name of your Public Access Zone subnet.
subnet1AddressPrefix="10.0.1.0/24" # Input the address prefix for your Public Access Zone subnet.
subnet2Name="front"                # Input the name of your application tier subnet.
subnet2AddressPrefix="10.0.2.0/24" # Input the address prefix for your application tier subnet.
subnet3Name="back"                 # Input the name of your data tier subnet.
subnet3AddressPrefix="10.0.3.0/24" # Input the address prefix for your data tier subnet.
subnet4Name="desktops"             # Input the name of your desktops subnet.
subnet4AddressPrefix="10.0.4.0/24" # Input the address prefix for your desktops subnet.
externalIp=[\"0.0.0.0\"]           # Input the external IP address(s). Note: This will allow incoming traffic to the Public Access Zone from this IP address.

# Resource Group Creation
DeploymentResourceGroup="$ResourceGroupName-$AzureEnvironment-rg"
az group create -n "$DeploymentResourceGroup" -l "$AzureRegion"

# Template Deployment to Resource Group
TemplateUri="https://github.com/jasonvriends/azure-quickstart/raw/master/2-virtual-network/azuredeploy.json"
az group deployment create --name "deploy-vnet" --resource-group "$DeploymentResourceGroup" --template-uri "$TemplateUri" --parameters vnetName="$vnetName" vnetAddressPrefix="$vnetAddressPrefix" subnet1Name="$subnet1Name" subnet1AddressPrefix="$subnet1AddressPrefix" subnet2Name="$subnet2Name" subnet2AddressPrefix="$subnet2AddressPrefix" subnet3Name="$subnet3Name" subnet3AddressPrefix="$subnet3AddressPrefix" subnet4Name="$subnet4Name" subnet4AddressPrefix="$subnet4AddressPrefix" externalIp="$externalIp"


```

