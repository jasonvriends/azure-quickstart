# 5-scaffold

When creating a building, scaffolding is used to create the basis of a structure. The scaffold guides the general outline and provides anchor points for more permanent systems to be mounted. An Azure scaffold is the same: a set of flexible controls and Azure capabilities that provide structure to the environment, and anchors for services built on the public cloud. It provides the builders (IT and business groups) a foundation to create and attach new services keeping speed of delivery in mind. This template deploys a **basic scaffold** (automation & policies) to get you started with Microsoft Azure.

## Prerequisites

To deploy this quickstart template, you need the following:
* **Azure subscription**. 
  * If you don't have one yet, you can <a href="https://azure.microsoft.com/pricing/member-offers/msdn-benefits-details/">activate your MSDN subscriber benefits</a> or <a href="https://azure.microsoft.com/free">sign up for a free account</a>.
* **Azure Cloud Shell**. 
  * If you have not setup Azure Cloud Shell, please follow the <a href="https://github.com/jasonvriends/azure-quickstart/tree/master/1-cloudshell">cloudshell</a> quickstart template.
* **Azure Virtual Network**. 
  * If you don't have an Azure Virtual Network, please follow the <a href="https://github.com/jasonvriends/azure-quickstart/tree/master/2-virtual-network">virtual-network</a> quickstart template.

## Features/Capabilities

* Creates an **Azure Automation account**. An Automation Account is a container for your Azure Automation resources. It provides a way to separate your environments or further organize your Automation workflows and resources. 
* Creates an **Azure Run As account**. Run As accounts in Azure Automation are used to provide authentication for managing resources in Azure with the Azure cmdlets.
* Creates an **Azure Key Vault**. Azure Key Vault safeguards cryptographic keys and other secrets used by cloud apps and services. It will be used to generate the Self Signed certificate that will be used to authenticate the Azure Run As account.
* Creates the following **Azure Automation Runbooks**:
  * **Apply-AzTagPolicy**: non-destructively copies all tags on a Resource Group to the objects contained in that Resource Group.
  * **Apply-AzVmPowerStatePolicy**: Starts/Stops Azure VMs in parallel on a schedule based a VM tag (powerManagement).
  * **Update-AutomationAzureModulesForAccount**: Updates all Azure modules in your Automation Account.
* Creates the following **Azure Subscription Policies**:
  * Restrict creation of new objects to one or more Azure Regions.
  * Restrict creation of new resources groups to one or more Azure Regions.
  * Restrict the creation of Virtual Networks to specific Resource Groups.
  * Restrict the creation of Public IPs to specific Resource Groups.
  * Enforce the creation of Virtual Machines with managed disks.

## Power Management
* Script Execution Frequency: **Hourly**
* Apply a **powerManagement** tag to a Resource Group to effect all Virtual Machines in that Resource Group.
* Apply a **powerManagement** tag to a Virtual Machine to override the Resource Group powerManagement tag.
* All Virtual Machines **without** a **powerManagement** tag are powered off at **6 PM EST**.

### Examples
* powerManagement = disabled;disabled (don't power on/off)
* powerManagement = disabled;20:00 (don't power on/power off at 20:00)
* powerManagement = 6:00;18:00 (power on at 6:00/power off at 18:00)

## Deployment Options

1. Launch https://shell.azure.com.
2. Select **PowerShell** as the shell.

```powershell

# Azure Subscription Configuration
$AzureRegion="eastus"                                  # Input the Azure Region to deploy the resources to (i.e. canadaeast, canadacentral, eastus, etc.).
$AzureEnvironment="innovation"                         # Input the prefix for your Azure Innovation Lab (i.e. dev, tst, prod, innovation, etc.).
$ResourceGroupName="automation"                        # Input the prefix for the resource group to deploy this quickstart template into.

# Template Parameters
$SubscriptionId="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" # Input the Azure Subscription ID to apply this quickstart template to.
$TimeZone="Eastern Standard Time"                      # Input the Time Zone to use for Power Management.
$NetworkingRG="networking-innovation-rg"               # Input the Resource Group where the Virtual Network resides.

# Resource Group Creation
$DeploymentResourceGroup="$ResourceGroupName-$AzureEnvironment-rg"
New-AzureRmResourceGroup -Name "$DeploymentResourceGroup" -Location "$AzureRegion" -ErrorVariable notCreated -ErrorAction SilentlyContinue

# Template Deployment to Resource Group
git clone https://github.com/jasonvriends/azure-quickstart.git

# Execute the apply-scaffold.ps1 PowerShell script with the required parameters
./azure-quickstart/5-scaffold/apply-scaffold.ps1 -Region "$AzureRegion" -AutomationRG "$DeploymentResourceGroup" -Environment "$AzureEnvironment" -SubscriptionId "$SubscriptionId" -TimeZone "$TimeZone" -NetworkingRG "$NetworkingRG"


```

## How to add Azure Policy exclusions post deployment?

In the following example, we are allowing the creation of **Public IPs** in the **guacamole-innovation-rg** Resource Group. However, you can customize this by changing the variable **$RG** to your desired **Resource Group** name and **$PolicyName** to your desired **Azure Policy**.

```powershell

$RG="guacamole-innovation-rg"                                      # Resource Group to exclude from the policy
$PolicyName="Network: Restrict creation of PIPs to authorized RGs" # Name of the policy to add the exclusion to
$AzureSubscriptionId="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"        # Azure Subscription ID to apply this policy to.

$ExcludedResourceGroup = Get-AzureRmResourceGroup -Name $RG
$PolicyAssignment = Get-AzureRmPolicyAssignment -Name $PolicyName -Scope "/subscriptions/$AzureSubscriptionId"
$arrExcludedResourceGroups = $PolicyAssignment.Properties.notScopes
$arrExcludedResourceGroups += $ExcludedResourceGroup.ResourceId
Set-AzureRmPolicyAssignment -Id $PolicyAssignment.ResourceId -NotScope $arrExcludedResourceGroups


```