# 4-apache-guacamole

Apache Guacamole is a clientless remote desktop gateway. It supports standard protocols like SSC, Telnet, VNC, and RDP. It is open source and requires no plugins or client software installed. Thanks to HTML5, once Guacamole is installed on a server, all you need to access your remote desktops and servers is a web browser.

Since Apache Guacamole is accessed via your web browser, you can install Guacamole on a Cloud Service Provider and access Apache Guacamole through your corporate proxy server. This can enable you to remotely access your Cloud hosted virtual machines without having to configure Firewall Rules or establish a Virtual Private Network.

This template deploys Apache Guacamole to an existing Virtual Network/Subnet.

## Prerequisites

To deploy this quickstart template, you need the following:
* **Azure subscription**. 
  * If you don't have one yet, you can <a href="https://azure.microsoft.com/pricing/member-offers/msdn-benefits-details/">activate your MSDN subscriber benefits</a> or <a href="https://azure.microsoft.com/free">sign up for a free account</a>.
* **Azure Virtual Network**. 
  * If you don't have an Azure Virtual Network, please follow the <a href="https://github.com/jasonvriends/azure-quickstart/tree/master/2-virtual-network">virtual-network</a> quickstart template.

## Features/Capabilities
* Deploys Nginx (Reverse Proxy), MySQL, Guacamole Server (Guacd), and Guacamole Client (Tomcat) on the same server.

## Security/Design Considerations
* This template deployment was designed for **ease of use** vs **security**.
* If you are seeking a **secure installation** typical of a **large enterprise**:
  * Install a reverse proxy (i.e. Nginx) with SSL certificates (i.e. Let's Encrypt) in your Public Access Zone (i.e. paz-subnet).
  * Install Apache Guacamole Client (Tomcat) and Apache Guacamole Server (Guacd) components in your Operational Zone (i.e. front-subnet).
  * Install MySQL or Azure Databases for MySQL in your Restricted Zone (i.e. back-subnet).
  * Configure Apache Guacamole to leverage MySQL database and OpenID authentication (i.e. Azure Active Directory) for Single Sign On (SSO).
  * Leverage Docker containers along with an orchestrator (i.e. Kubernetes).
  * **Refer to <a href="https://github.com/jasonvriends/apache-guacamole">apache-guacamole</a> for secure installation design patterns as described above**.

## Deployment Options

### Azure Portal

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjasonvriends%2Fazure-quickstart%2Fmaster%2F4-apache-guacamole%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fjasonvriends%2Fazure-quickstart%2Fmaster%2F4-apache-guacamole%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a><br/>

### Azure PowerShell

```powershell

# Azure Subscription Configuration
$AzureRegion="eastus"                         # Input the Azure Region to deploy the resources to (i.e. canadaeast, canadacentral, eastus, etc.).
$AzureEnvironment="innovation"                # Input the prefix for your Azure Innovation Lab (i.e. dev, tst, prod, innovation, etc.).
$ResourceGroupName="guacamole"                # Input the prefix for the resource group to deploy this quickstart template into.

# Template Parameters
$dnsLabelPrefix="guac"                        # Input your desired Virtual Machine dns label prefix. Note: a suffix of -vm is appended to the Virtual Machine name."
$size="Standard_D2s_v3"                       # Input your desired Virtual Machine instance size (e.g. Standard_B1ms).
$adminUsername="vmadmin"                      # Input your desired Virtual Machine administrator username.
$authenticationType="password"                # Select your desired Virtual Machine authentication type (password or publickey).
$pwdOrPsk="@Canada2019@"                      # Input your desired Virtual Machine administrator password or SSH Public Key.
$vnetName="innovation-vnet"                   # Input your desired Virtual Network name.
$vnetSubnetName="paz-subnet"                  # Input the name of your Virtual Network subnet.
$vnetResourceGroup="networking-innovation-rg" # Input the Resource Group where your Virtual Network resides.
$ipAddress="public"                           # Select your desired ip address type (private or public).
$mysqlRootPwd="@Canada2019@"                  # Input the MySQL root database password.
$dbName="guacamole_db"                        # Input the name of the Apache Guacamole database.
$dbUser="guacamole_user"                      # Input the name of the user to be granted access to the Apache Guacamole database.
$dbUserPwd="@Canada2019@"                     # Input the password for the user to be granted access to the Apache Guacamole database.

# Resource Group Creation
$DeploymentResourceGroup="$ResourceGroupName-$AzureEnvironment-rg"
$pwdOrPskSecureString=ConvertTo-SecureString $pwdOrPsk -AsPlainText -Force
$mysqlRootPwdSecureString=ConvertTo-SecureString $mysqlRootPwd -AsPlainText -Force
$dbUserPwdSecureString=ConvertTo-SecureString $dbUserPwd -AsPlainText -Force
New-AzureRmResourceGroup -Name "$DeploymentResourceGroup" -Location "$AzureRegion" -ErrorVariable notCreated -ErrorAction SilentlyContinue

# Template Deployment to Resource Group
$TemplateUri="https://github.com/jasonvriends/azure-quickstart/raw/master/4-apache-guacamole/azuredeploy.json"
New-AzResourceGroupDeployment -Name "deploy-guacamole" -ResourceGroupName "$DeploymentResourceGroup" -TemplateUri "$TemplateUri" -dnsLabelPrefix "$dnsLabelPrefix" -size "$size" -adminUsername "$adminUsername" -authenticationType "$authenticationType" -pwdOrPsk $pwdOrPskSecureString -vnetName "$vnetName" -vnetSubnetName "$vnetSubnetName" -vnetResourceGroup "$vnetResourceGroup" -ipAddress "$ipAddress" -mysqlRootPwd $mysqlRootPwdSecureString -dbName "$dbName" -dbUser "$dbUser" -dbUserPwd $dbUserPwdSecureString


```

### Azure CLI

```shell

# Azure Subscription Configuration
AzureRegion="eastus"                         # Input the Azure Region to deploy the resources to (i.e. canadaeast, canadacentral, eastus, etc.).
AzureEnvironment="innovation"                # Input the prefix for your Azure Innovation Lab (i.e. dev, tst, prod, innovation, etc.).
ResourceGroupName="guacamole"                # Input the prefix for the resource group to deploy this quickstart template into. 

# Template Parameters
dnsLabelPrefix="guac"                        # Input your desired Virtual Machine dns label prefix. Note: a suffix of -vm is appended to the Virtual Machine name."
size="Standard_D2s_v3"                       # Input your desired Virtual Machine instance size (e.g. Standard_B1ms).
adminUsername="vmadmin"                      # Input your desired Virtual Machine administrator username.
authenticationType="password"                # Select your desired Virtual Machine authentication type (password or publickey).
pwdOrPsk="@Canada2019@"                      # Input your desired Virtual Machine administrator password or SSH Public Key.
vnetName="innovation-vnet"                   # Input your desired Virtual Network name.
vnetSubnetName="paz-subnet"                  # Input the name of your Virtual Network subnet.
vnetResourceGroup="networking-innovation-rg" # Input the Resource Group where your Virtual Network resides.
ipAddress="public"                           # Select your desired ip address type (private or public).
mysqlRootPwd="@Canada2019@"                  # Input the MySQL root database password.
dbName="guacamole_db"                        # Input the name of the Apache Guacamole database.
dbUser="guacamole_user"                      # Input the name of the user to be granted access to the Apache Guacamole database.
dbUserPwd="@Canada2019@"                     # Input the password for the user to be granted access to the Apache Guacamole database.

# Resource Group Creation
DeploymentResourceGroup="$ResourceGroupName-$AzureEnvironment-rg"
az group create -n "$DeploymentResourceGroup" -l "$AzureRegion"

# Template Deployment to Resource Group
TemplateUri="https://github.com/jasonvriends/azure-quickstart/raw/master/4-apache-guacamole/azuredeploy.json"
az group deployment create --name "deploy-guacamole" --resource-group "$DeploymentResourceGroup" --template-uri "$TemplateUri" --parameters dnsLabelPrefix="$dnsLabelPrefix" size="$size" adminUsername="$adminUsername" authenticationType="$authenticationType" pwdOrPsk="$pwdOrPsk" vnetName="$vnetName" vnetSubnetName="$vnetSubnetName" vnetResourceGroup="$vnetResourceGroup" ipAddress="$ipAddress" mysqlRootPwd="$mysqlRootPwd" dbName="$dbName" dbUser="$dbUser" dbUserPwd="$dbUserPwd"


```

## Post Deployment

* Visit http://your.guacamole.ip.address
* Username: guacadmin
* Password: guacadmin

**Remember to change your password once you login!**

