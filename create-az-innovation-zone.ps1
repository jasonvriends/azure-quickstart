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
# Verify Parameters not NULL, EMPTY, or have WHITESPACE
##################################################################################################################

if([string]::IsNullOrWhiteSpace($AzureRegion)) {            
    Write-Warning "AzureRegion can't be NULL, EMPTY, or have WHITESPACE."
    Exit 1
}

if([string]::IsNullOrWhiteSpace($AzureEnvironment)) {            
  Write-Warning "AzureEnvironment can't be NULL, EMPTY, or have WHITESPACE."
  Exit 1
}

if([string]::IsNullOrWhiteSpace($PwdOrPsk)) {            
  Write-Warning "PwdOrPsk can't be NULL, EMPTY, or have WHITESPACE."
  Exit 1
}

if([string]::IsNullOrWhiteSpace($MysqlRootPwd)) {            
  Write-Warning "MysqlRootPwd can't be NULL, EMPTY, or have WHITESPACE."
  Exit 1
}

if([string]::IsNullOrWhiteSpace($DbUserPwd)) {            
  Write-Warning "DbUserPwd can't be NULL, EMPTY, or have WHITESPACE."
  Exit 1
}

if([string]::IsNullOrWhiteSpace($ExternalIp)) {            
  Write-Warning "ExternalIp can't be NULL, EMPTY, or have WHITESPACE."
  Exit 1
}

if([string]::IsNullOrWhiteSpace($AzureSubscriptionId)) {            
  Write-Warning "AzureSubscriptionId can't be NULL, EMPTY, or have WHITESPACE."
  Exit 1
}

if([string]::IsNullOrWhiteSpace($PowerManagementTimeZone)) {            
  Write-Warning "PowerManagementTimeZone can't be NULL, EMPTY, or have WHITESPACE."
  Exit 1
}

# Get current script path
$ScriptPath = split-path -parent $MyInvocation.MyCommand.Definition

##################################################################################################################
# Write-Host Parameters
##################################################################################################################

Write-Host "========================================================================="
Write-Host "AzureRegion: $AzureRegion"
Write-Host "AzureEnvironment: $AzureEnvironment"
Write-Host "PwdOrPsk: $PwdOrPsk"
Write-Host "MysqlRootPwd: $MysqlRootPwd"
Write-Host "DbUserPwd: $DbUserPwd"            
Write-Host "ExternalIp: $ExternalIp"
Write-Host "AzureSubscriptionId: $AzureSubscriptionId"
Write-Host "PowerManagementTimeZone: $PowerManagementTimeZone"
Write-Host "ScriptPath: $ScriptPath"
Write-Host "========================================================================="

# Convert passwords to Secure String
$securePwdOrPsk=ConvertTo-SecureString $PwdOrPsk -AsPlainText -Force
$secureMysqlRootPwd=ConvertTo-SecureString $MysqlRootPwd -AsPlainText -Force
$secureDbUserPwd=ConvertTo-SecureString $DbUserPwd -AsPlainText -Force

# Confirm execution
Write-Host -NoNewLine 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

##################################################################################################################
# Select Azure Subscription
##################################################################################################################

Get-AzureRmSubscription -SubscriptionId $AzureSubscriptionId -ErrorVariable notPresent -ErrorAction SilentlyContinue | Select-AzureRmSubscription -ErrorVariable notPresent -ErrorAction SilentlyContinue
if ($notPresent)
{
    Write-Warning "Select-AzureRmSubscription: '$AzureSubscriptionId' not found."
    Exit 1
} else {
    Write-Host "Select-AzureRmSubscription: '$AzureSubscriptionId' successful."
}

##################################################################################################################
# Define Specialized Resource Groups
##################################################################################################################

$AzureNetworkingRG="networking-$azureEnvironment-rg" # Resource Group for Azure Virtual Networks
$AzureAutomationRG="automation-$azureEnvironment-rg" # Resource Group for Azure Automation
$AzureGuacamoleRG="guacamole-$azureEnvironment-rg"   # Resource Group for Apache Guacamole
$AzureDesktopsRG="desktops-$azureEnvironment-rg"     # Resource Group for Cloud Desktops

##################################################################################################################
# Create Resource Groups
##################################################################################################################

$AzureResourceGroups="automation,networking,desktops,guacamole"
$RGs = $AzureResourceGroups.split(",");
ForEach($RG in $RGs) {   

  Get-AzureRmResourceGroup -Name "$RG-$AzureEnvironment-rg" -ErrorVariable notPresent -ErrorAction SilentlyContinue

  if ($notPresent) {

    New-AzureRmResourceGroup -Name "$RG-$AzureEnvironment-rg" -Location $AzureRegion -Tag @{powerManagement="Disabled;18:00"} -ErrorVariable notCreated -ErrorAction SilentlyContinue

    if ($notCreated) {
      Write-Warning "New-AzureRmResourceGroup: '$RG-$AzureEnvironment-rg' failed."
      Exit 1
    } else {
      Write-Host "New-AzureRmResourceGroup: '$RG-$AzureEnvironment-rg.' successful"      
    }

  } else {
    Write-Host "Skipping New-AzureRmResourceGroup: '$RG-$AzureEnvironment-rg' already exists."
  }

}

##################################################################################################################
# Deploy Azure Virtual Network
##################################################################################################################

New-AzResourceGroupDeployment -ErrorVariable deployError -ErrorAction SilentlyContinue -Force -Name "deploy-vnet" -ResourceGroupName "$azureNetworkingRG" -TemplateFile "$ScriptPath/2-virtual-network/azuredeploy.json" -TemplateParameterFile "$ScriptPath/2-virtual-network/azuredeploy.parameters.json" -externalIp $ExternalIp

if ($deployError) {
  Write-Warning "New-AzResourceGroupDeployment: 'deploy-vnet' failed."
  Exit 1
} else {
    Write-Host "New-AzResourceGroupDeployment: 'deploy-vnet' successful."  
}

##################################################################################################################
# Deploy Apache Guacamole
##################################################################################################################

New-AzResourceGroupDeployment -ErrorVariable deployError -ErrorAction SilentlyContinue -Force -Name "deploy-guac" -ResourceGroupName "$azureGuacamoleRG" -TemplateFile "$ScriptPath/4-apache-guacamole/azuredeploy.json" -TemplateParameterFile "$ScriptPath/4-apache-guacamole/azuredeploy.parameters.json" -pwdOrPsk $securepwdOrPsk -mysqlRootPwd $securemysqlRootPwd -dbUserPwd $securedbUserPwd -Size "Standard_D2s_v3"

if ($deployError) {
  Write-Warning "New-AzResourceGroupDeployment: 'deploy-guac' failed."
  Exit 1
} else {
    Write-Host "New-AzResourceGroupDeployment: 'deploy-guac' successful."  
}

##################################################################################################################
# Deploy Cloud Desktop
##################################################################################################################

New-AzResourceGroupDeployment -ErrorVariable deployError -ErrorAction SilentlyContinue -Force -Name "deploy-desktop" -ResourceGroupName "$AzureDesktopsRG" -TemplateFile "$ScriptPath/3-virtual-machines/azuredeploy.json" -TemplateParameterFile "$ScriptPath/3-virtual-machines/azuredeploy.parameters.json" -pwdOrPsk $securepwdOrPsk -dnsLabelPrefix "desktop" -Size "Standard_D2s_v3" -osPublisher "MicrosoftWindowsServer" -osOffer "WindowsServer" -osSKU "2019-Datacenter"

if ($deployError) {
  Write-Warning "New-AzResourceGroupDeployment: 'deploy-desktop' failed."
  Exit 1
} else {
    Write-Host "New-AzResourceGroupDeployment: 'deploy-desktop' successful."  
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
