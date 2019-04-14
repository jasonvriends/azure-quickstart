<#
.Author(s)
    Jason Vriends
.Synopsis
    Creates an Creates an Azure Innovation Lab.
.Description
    For a detailed description visit https://github.com/jasonvriends/azure-quickstart/.
.Parameter AzureRegion
    The Azure Region to deploy the resources to (i.e. canadaeast, canadacentral, eastus, etc.).
.Parameter AzureEnvironment
    The prefix for your Azure Innovation Lab (i.e. dev, tst, prod, innovation).
.Parameter PwdOrPsk
    Your desired password for Apache Guacamole and Desktop Virtual Machines
.Parameter MysqlRootPwd
    Your desired Apache Guacamole MySQL Root Password.
.Parameter DbUserPwd
    Your desired Apache Guacamole database user password.
.Parameter ExternalIp
    Your external ip address to access to the paz-subnet (https://www.whatsmyip.org).
.Parameter AzureSubscriptionId
    The Azure Subscription Id to deploy the resources to (i.e. xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx).
.Parameter PowerManagementTimeZone
    The Time Zone for Power Management (i.e. Eastern Standard Time).
.Inputs
    None
.Outputs
    None
.Link
    https://github.com/jasonvriends/azure-quickstart/
#>

# Parameters
##################################################################################################################

[CmdletBinding()]
[OutputType([bool])]
Param
(
    [parameter(Mandatory=$true)] [String] $AzureRegion,             # The Azure Region to deploy the resources to (i.e. canadaeast, canadacentral, eastus, etc.).
    [parameter(Mandatory=$true)] [String] $AzureEnvironment,        # The prefix for your Azure Innovation Lab (i.e. dev, tst, prod, innovation).
    [parameter(Mandatory=$true)] [String] $PwdOrPsk,                # Your desired password for Apache Guacamole and Desktop Virtual Machines.
    [parameter(Mandatory=$true)] [String] $MysqlRootPwd,            # Your desired Apache Guacamole MySQL Root Password.
    [parameter(Mandatory=$true)] [String] $DbUserPwd,               # Your desired Apache Guacamole database user password.
    [parameter(Mandatory=$true)] [String[]] $ExternalIp,            # Your external ip address to access to the paz-subnet (https://www.whatsmyip.org).
    [parameter(Mandatory=$true)] [String] $AzureSubscriptionId,     # The Azure Subscription Id to deploy the resources to (i.e. xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx).
    [parameter(Mandatory=$true)] [String] $PowerManagementTimeZone  # The Time Zone for Power Management (i.e. Eastern Standard Time).
)

##################################################################################################################
# Import PSWriteColor Module
##################################################################################################################

if (Get-Module -ListAvailable -Name PSWriteColor) {
  Import-Module PSWriteColor
} else {
  Write-Host -Text "PowerShell 'PSWriteColor' module does not exist... installing"
  Install-Module -Name PSWriteColor -Force > $null
}

#Requires -Modules PSWriteColor

##################################################################################################################
# Verify Parameters not NULL, EMPTY, or have WHITESPACE
##################################################################################################################

if([string]::IsNullOrWhiteSpace($AzureRegion)) {            
  Write-Color -Text "AzureRegion can't be NULL, EMPTY, or have WHITESPACE." -Color Red
    Exit 1
}

if([string]::IsNullOrWhiteSpace($AzureEnvironment)) {            
  Write-Color -Text "AzureEnvironment can't be NULL, EMPTY, or have WHITESPACE." -Color Red
  Exit 1
}

if([string]::IsNullOrWhiteSpace($PwdOrPsk)) {            
  Write-Color -Text "PwdOrPsk can't be NULL, EMPTY, or have WHITESPACE." -Color Red
  Exit 1
}

if([string]::IsNullOrWhiteSpace($MysqlRootPwd)) {            
  Write-Color -Text "MysqlRootPwd can't be NULL, EMPTY, or have WHITESPACE." -Color Red
  Exit 1
}

if([string]::IsNullOrWhiteSpace($DbUserPwd)) {            
  Write-Color -Text "DbUserPwd can't be NULL, EMPTY, or have WHITESPACE." -Color Red
  Exit 1
}

if([string]::IsNullOrWhiteSpace($ExternalIp)) {            
  Write-Color -Text "ExternalIp can't be NULL, EMPTY, or have WHITESPACE." -Color Red
  Exit 1
}

if([string]::IsNullOrWhiteSpace($AzureSubscriptionId)) {            
  Write-Color -Text "AzureSubscriptionId can't be NULL, EMPTY, or have WHITESPACE." -Color Red
  Exit 1
}

if([string]::IsNullOrWhiteSpace($PowerManagementTimeZone)) {            
  Write-Color -Text "PowerManagementTimeZone can't be NULL, EMPTY, or have WHITESPACE." -Color Red
  Exit 1
}

# Get current script path
$ScriptPath = split-path -parent $MyInvocation.MyCommand.Definition

##################################################################################################################
# Script Execution Confirmation
##################################################################################################################

Clear-Host

Write-Color -Text "=========================================================================" -Color Gray
Write-Color -Text "Deployment Parameters" -Color Gray
Write-Color -Text "=========================================================================" -Color Gray
Write-Color -Text "AzureRegion: ", "$AzureRegion" -Color Gray, Yellow
Write-Color -Text "AzureEnvironment: ", "$AzureEnvironment" -Color Gray, Yellow
Write-Color -Text "PwdOrPsk: ", "$PwdOrPsk" -Color Gray, Yellow
Write-Color -Text "MysqlRootPwd: ", "$MysqlRootPwd" -Color Gray, Yellow
Write-Color -Text "DbUserPwd: ", "$DbUserPwd" -Color Gray, Yellow
Write-Color -Text "ExternalIp: ", "$ExternalIp" -Color Gray, Yellow
Write-Color -Text "AzureSubscriptionId: ", "$AzureSubscriptionId" -Color Gray, Yellow
Write-Color -Text "PowerManagementTimeZone: ", "$PowerManagementTimeZone" -Color Gray, Yellow
Write-Color -Text "ScriptPath: ", "$ScriptPath" -Color Gray, Yellow
Write-Color -Text "========================================================================="

# Convert passwords to Secure String
$securePwdOrPsk=ConvertTo-SecureString $PwdOrPsk -AsPlainText -Force
$secureMysqlRootPwd=ConvertTo-SecureString $MysqlRootPwd -AsPlainText -Force
$secureDbUserPwd=ConvertTo-SecureString $DbUserPwd -AsPlainText -Force

# Confirm execution
Write-Color -Text 'Press any key to continue...' -Color Yellow
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')

Write-Color -Text "=========================================================================" -Color Gray
Write-Color -Text "" -Color Gray

##################################################################################################################
# Azure Subscription
##################################################################################################################

Write-Color -Text "Azure Subscription" -Color Gray

# Get Azure Subscription

Get-AzureRmSubscription -OutVariable getSubscriptionOutput -ErrorVariable getSubscriptionError -ErrorAction SilentlyContinue -SubscriptionId $AzureSubscriptionId > $null

if ($getSubscriptionError)
{
    Write-Color -Text "-> Get Azure subscription Id: $AzureSubscriptionId"," fail", "." -Color Gray, Red, Gray
    Write-Color -Text "--> $getSubscriptionError" -Color Red
    Exit 1
} else {
    Write-Color -Text "-> Get Azure subscription Id: $AzureSubscriptionId"," pass", "." -Color Gray, Green, Gray
}

# Set Azure Subscription

$getSubscriptionOutput | Select-AzureRmSubscription -OutVariable setSubscriptionOutput -ErrorVariable setSubscriptionError -ErrorAction SilentlyContinue > $null

if ($setSubscriptionError)
{
    Write-Color -Text "-> Set Azure subscription Id: $AzureSubscriptionId"," fail", "." -Color Gray, Red, Gray
    Write-Color -Text "--> $setSubscriptionError" -Color Red
    Exit 1
} else {
    Write-Color -Text "-> Set Azure subscription Id: $AzureSubscriptionId"," pass", "." -Color Gray, Green, Gray
}

##################################################################################################################
# Create Resource Groups
##################################################################################################################

Write-Color -Text " " -Color Gray
Write-Color -Text "Resource Groups" -Color Gray

$AzureAutomationRG="automation-$azureEnvironment-rg" # Resource Group for Azure Automation
$AzureNetworkingRG="networking-$azureEnvironment-rg" # Resource Group for Azure Virtual Networks
$AzureGuacamoleRG="guacamole-$azureEnvironment-rg"   # Resource Group for Apache Guacamole
$AzureDesktopsRG="desktops-$azureEnvironment-rg"     # Resource Group for Cloud Desktops

$AzureResourceGroups="automation,networking,desktops,guacamole"
$RGs = $AzureResourceGroups.split(",");
ForEach($RG in $RGs) {   

  Get-AzureRmResourceGroup -OutVariable getRgOutput -ErrorVariable getRgError -ErrorAction SilentlyContinue -Name "$RG-$AzureEnvironment-rg" > $null

  if ($getRgError) { # Resource Group not found

    # Create Resource Group
    New-AzureRmResourceGroup -OutVariable getNewRgOutput -ErrorVariable getNewRgError -ErrorAction SilentlyContinue `
    -Name "$RG-$AzureEnvironment-rg" -Location $AzureRegion -Tag @{powerManagement="Disabled;18:00"} > $null
  
    if ($getNewRgError)
    { # Error creating Resource Group
        Write-Color -Text "-> Create Resource Group: $RG-$AzureEnvironment-rg"," fail","." -Color Gray, Red, Gray
        Write-Color -Text "--> $getNewRgError" -Color Red
        Exit 1
    } # Successful in creating Resource Group
      else {
        Write-Color -Text "-> Create Resource Group: $RG-$AzureEnvironment-rg"," pass","." -Color Gray, Green, Gray
    }

  } # Resource Group already exists
  else {
    Write-Color -Text "-> Create Resource Group: $RG-$AzureEnvironment-rg"," already exists","." -Color Gray, Yellow, Gray      
  }

}

##################################################################################################################
# Deploy Azure Virtual Network
##################################################################################################################

Write-Color -Text " " -Color Gray
Write-Color -Text "Deploy Azure Virtual Network" -Color Gray
Write-Color -Text "-> Deployment Parameters:" -Color Gray
Write-Color -Text "--> -vnetName ", "$AzureEnvironment-vnet" -Color Gray, Yellow
Write-Color -Text "--> -vnetAddressPrefix ", "10.0.0.0/8" -Color Gray, Yellow
Write-Color -Text "--> -subnet1Name ", "paz" -Color Gray, Yellow
Write-Color -Text "--> -subnet1AddressPrefix ", "10.0.1.0/24" -Color Gray, Yellow
Write-Color -Text "--> -subnet2Name ", "front" -Color Gray, Yellow
Write-Color -Text "--> -subnet2AddressPrefix ", "10.0.2.0/24" -Color Gray, Yellow
Write-Color -Text "--> -subnet3Name ", "back" -Color Gray, Yellow
Write-Color -Text "--> -subnet3AddressPrefix ", "10.0.3.0/24" -Color Gray, Yellow
Write-Color -Text "--> -subnet4Name ", "desktops" -Color Gray, Yellow
Write-Color -Text "--> -subnet4AddressPrefix ", "10.0.4.0/24" -Color Gray, Yellow
Write-Color -Text "--> -externalIp ", "$ExternalIp" -Color Gray, Yellow
Write-Color -Text "-> Deployment Result:" -Color Gray

New-AzResourceGroupDeployment -OutVariable deployVnetOutput -ErrorVariable deployVnetError -ErrorAction SilentlyContinue `
-Name "deploy-vnet" -ResourceGroupName "$azureNetworkingRG" -TemplateFile "$ScriptPath/2-virtual-network/azuredeploy.json" `
-vnetName "$AzureEnvironment-vnet" -vnetAddressPrefix "10.0.0.0/8" -subnet1Name "paz" -subnet1AddressPrefix "10.0.1.0/24" -subnet2Name "front" -subnet2AddressPrefix "10.0.2.0/24" -subnet3Name "back" -subnet3AddressPrefix "10.0.3.0/24" -subnet4Name "desktops" -subnet4AddressPrefix "10.0.4.0/24" -externalIp $ExternalIp > $null

if ($deployVnetError) {
  Write-Color -Text "--> fail" -ForegroundColor Red -NoNewline
  Write-Color -Text "$deployVnetError" -ForegroundColor Red -NoNewline
  Exit 1
} else {
  Write-Color -Text "--> pass" -ForegroundColor Green -NoNewline
}

##################################################################################################################
# Deploy Apache Guacamole
##################################################################################################################

Write-Color -Text " " -Color Gray
Write-Color -Text " " -Color Gray
Write-Color -Text "Deploy Apache Guacamole" -Color Gray
Write-Color -Text "-> Deployment Parameters:" -Color Gray
Write-Color -Text "--> -dnsLabelPrefix ", "guac" -Color Gray, Yellow
Write-Color -Text "--> -size ", "Standard_D2s_v3" -Color Gray, Yellow
Write-Color -Text "--> -adminUsername ", "vmadmin" -Color Gray, Yellow
Write-Color -Text "--> -authenticationType ", "password" -Color Gray, Yellow
Write-Color -Text "--> -pwdOrPsk ", "$pwdOrPsk" -Color Gray, Yellow
Write-Color -Text "--> -vnetName ", "$AzureEnvironment-vnet" -Color Gray, Yellow
Write-Color -Text "--> -vnetSubnetName ", "paz-subnet" -Color Gray, Yellow
Write-Color -Text "--> -vnetResourceGroup ", "$AzureNetworkingRG" -Color Gray, Yellow
Write-Color -Text "--> -ipAddress ", "public" -Color Gray, Yellow
Write-Color -Text "--> -mysqlRootPwd ", "$mysqlRootPwd" -Color Gray, Yellow
Write-Color -Text "--> -dbName ", "guacamole_db" -Color Gray, Yellow
Write-Color -Text "--> -dbUser ", "guacamole_user" -Color Gray, Yellow
Write-Color -Text "--> -dbUserPwd ", "$dbUserPwd" -Color Gray, Yellow
Write-Color -Text "-> Deployment Result:" -Color Gray

New-AzResourceGroupDeployment -OutVariable deployGuacOutput -ErrorVariable deployGuacError -ErrorAction SilentlyContinue `
-Name "deploy-guac" -ResourceGroupName "$azureGuacamoleRG" -TemplateFile "$ScriptPath/4-apache-guacamole/azuredeploy.json" `
-dnsLabelPrefix "guac" -size "Standard_D2s_v3" -adminUsername "vmadmin" -authenticationType "password" -pwdOrPsk $securepwdOrPsk -vnetName "$AzureEnvironment-vnet" -vnetSubnetName "paz-subnet" -vnetResourceGroup "$AzureNetworkingRG" -ipAddress "public" -mysqlRootPwd $securemysqlRootPwd -dbName "guacamole_db" -dbUser "guacamole_user" -dbUserPwd $securedbUserPwd > $null

if ($deployGuacError) {
  Write-Color -Text "--> fail" -ForegroundColor Red -NoNewline
  Write-Color -Text "$deployGuacError" -ForegroundColor Red -NoNewline
  Exit 1
} else {
  Write-Color -Text "--> pass" -ForegroundColor Green -NoNewline
} 

##################################################################################################################
# Deploy Cloud Desktop
##################################################################################################################

Write-Color -Text " " -Color Gray
Write-Color -Text " " -Color Gray
Write-Color -Text "Deploy Cloud Desktop" -Color Gray
Write-Color -Text "-> Deployment Parameters:" -Color Gray
Write-Color -Text "--> -dnsLabelPrefix ", "desktop" -Color Gray, Yellow
Write-Color -Text "--> -size ", "Standard_D2s_v3" -Color Gray, Yellow
Write-Color -Text "--> -osPublisher ", "MicrosoftWindowsServer" -Color Gray, Yellow
Write-Color -Text "--> -osOffer ", "WindowsServer" -Color Gray, Yellow
Write-Color -Text "--> -osSKU ", "2019-Datacenter" -Color Gray, Yellow
Write-Color -Text "--> -osVersion ", "latest" -Color Gray, Yellow
Write-Color -Text "--> -instances ", "1" -Color Gray, Yellow
Write-Color -Text "--> -extensionUri ", "" -Color Gray, Yellow
Write-Color -Text "--> -extensionCommand ", "" -Color Gray, Yellow
Write-Color -Text "--> -adminUsername ", "vmadmin" -Color Gray, Yellow
Write-Color -Text "--> -authenticationType ", "password" -Color Gray, Yellow
Write-Color -Text "--> -pwdOrPsk ", "$pwdOrPsk" -Color Gray, Yellow
Write-Color -Text "--> -vnetName ", "$AzureEnvironment-vnet" -Color Gray, Yellow
Write-Color -Text "--> -vnetSubnetName ", "desktops-subnet" -Color Gray, Yellow
Write-Color -Text "--> -vnetResourceGroup ", "$AzureNetworkingRG" -Color Gray, Yellow
Write-Color -Text "--> -ipAddress ", "private" -Color Gray, Yellow
Write-Color -Text "-> Deployment Result:" -Color Gray

New-AzResourceGroupDeployment -OutVariable deployDesktopOutput -ErrorVariable deployDesktopError -ErrorAction SilentlyContinue `
-Name "deploy-desktop" -ResourceGroupName "$AzureDesktopsRG" -TemplateFile "$ScriptPath/3-virtual-machines/azuredeploy.json" `
-dnsLabelPrefix "desktop" -size "Standard_D2s_v3" -osPublisher "MicrosoftWindowsServer" -osOffer "WindowsServer" -osSKU "2019-Datacenter" -osVersion "latest" -instances 1 -extensionUri "" -extensionCommand "" -adminUsername "vmadmin" -authenticationType "password" -pwdOrPsk $securepwdOrPsk -vnetName "$AzureEnvironment-vnet" -vnetSubnetName "desktops-subnet" -vnetResourceGroup "$AzureNetworkingRG" -ipAddress "private"  > $null

if ($deployDesktopError) {
  Write-Color -Text "--> fail" -ForegroundColor Red -NoNewline
  Write-Color -Text "$deployDesktopError" -ForegroundColor Red -NoNewline
  Exit 1
} else {
  Write-Color -Text "--> pass" -ForegroundColor Green -NoNewline
} 

##################################################################################################################
# Deploy Scaffold
##################################################################################################################

& "$ScriptPath/5-scaffold/apply-scaffold.ps1" -Region "$AzureRegion" -AutomationRG "$AzureAutomationRG" -Environment "$AzureEnvironment" -SubscriptionId "$AzureSubscriptionId" -TimeZone "$PowerManagementTimeZone" -NetworkingRG "$AzureNetworkingRG"

## Grant PIP policy exception to $azureGuacamoleRG
$ExcludedResourceGroup = Get-AzureRmResourceGroup -Name $azureGuacamoleRG
$PolicyAssignment = Get-AzureRmPolicyAssignment -Name 'Network: Restrict creation of PIPs to authorized RGs' -Scope "/subscriptions/$AzureSubscriptionId"
$arrExcludedResourceGroups = $PolicyAssignment.Properties.notScopes
$arrExcludedResourceGroups += $ExcludedResourceGroup.ResourceId
Set-AzureRmPolicyAssignment -Id $PolicyAssignment.ResourceId -NotScope $arrExcludedResourceGroups
