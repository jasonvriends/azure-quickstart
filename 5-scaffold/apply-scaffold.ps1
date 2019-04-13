<#
.Author(s)
    Jason Vriends
    Matthew Schoyen
.Synopsis
    Creates an Azure Automation Account, Run As Account, and Runbooks for Power Management and Tagging.
.Description
    For a detailed description visit https://github.com/jasonvriends/azure-quickstart/tree/master/2-scaffold
.Parameter Region
    The Azure Region to deploy and restrict resources to (i.e. canadaeast, canadacentral, eastus, etc.)
.Parameter AutomationRG
    The Azure Resource Group to deploy the resources to (i.e. automation-innovation-rg)
.Parameter Environment
    The environment for your Azure Automation Account (i.e. dev, tst, prod, innovation)
    Your Azure Automation Account Name will be $Environment-autoacct.
.Parameter SubscriptionId
    The Azure Subscription Id to deploy the resources to (i.e. xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)
.Parameter TimeZone
    The Timezone for the Azure Automation Schedule (i.e. Eastern Standard Time)
.Parameter NetworkingRG
    The Resource Group where Azure Virtual Networks reside (i.e. networking-innovation-rg). It will be excluded from the following Azure Policies:
        Network: Restrict creation of PIPs to authorized RGs
        Network: Restrict creation of vNets to authorized RGs
        Location: Restrict resource group creation to $azRegion
.Inputs
    None
.Outputs
    None
.Link
    https://abcdazure.azurewebsites.net/create-automation-account-with-powershell/
#>

# Parameters
##################################################################################################################
[CmdletBinding()]
[OutputType([bool])]
Param
(
    [parameter(Mandatory=$true)] [String] $Region,                  # The Azure Region to deploy the resources to (i.e. canadaeast, canadacentral, eastus, etc.)
    [parameter(Mandatory=$true)] [String] $AutomationRG,            # The Azure Resource Group to deploy the resources to (i.e. automation-innovation-rg)
    [parameter(Mandatory=$true)] [String] $Environment,             # The environment for your Azure Automation Account (i.e. dev, tst, prod, innovation)
    [parameter(Mandatory=$true)] [String] $SubscriptionId,          # The Azure Subscription Id to deploy the resources to (i.e. xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)
    [parameter(Mandatory=$true)] [String] $TimeZone,                # The Timezone for the Azure Automation Schedule (i.e. Eastern Standard Time)
    [parameter(Mandatory=$true)] [String] $NetworkingRG             # The Resource Group where Azure Virtual Networks reside (i.e. networking-innovation-rg) 
)

# Verify Parameter:Region not NULL, EMPTY, or have WHITESPACE
$azRegion = $Region
if([string]::IsNullOrWhiteSpace($azRegion)) {            
    Write-Host "Region can't be NULL, EMPTY, or have WHITESPACE."
    Exit 1
}   

# Verify Parameter:ResourceGroup not NULL, EMPTY, or have WHITESPACE
$azResourceGroup = $AutomationRG
if([string]::IsNullOrWhiteSpace($azResourceGroup)) {            
    Write-Host "ResourceGroup can't be NULL, EMPTY, or have WHITESPACE."
    Exit 1
} else {
    Get-AzureRmResourceGroup -Name $azResourceGroup -ErrorVariable notPresent -ErrorAction SilentlyContinue
    if ($notPresent)
    {
        Write-Host "$azResourceGroup doesn't exist."
        Exit 1
    }
}

# Verify Parameter:Environment not NULL, EMPTY, or have WHITESPACE
$azEnvironment = $Environment
if([string]::IsNullOrWhiteSpace($azEnvironment)) {            
    Write-Host "Environment can't be NULL, EMPTY, or have WHITESPACE."
    Exit 1
} 

# Verify Parameter:SubscriptionId not NULL, EMPTY, or have WHITESPACE
$azSubscriptionId = $SubscriptionId
if([string]::IsNullOrWhiteSpace($azSubscriptionId)) {            
    Write-Host "SubscriptionId can't be NULL, EMPTY, or have WHITESPACE."
    Exit 1
} 

# Verify Variable:azAutomationAccountName not NULL, EMPTY, or have WHITESPACE
$azAutomationAccountName = "$azEnvironment-autoacct"
if([string]::IsNullOrWhiteSpace($azAutomationAccountName)) {            
    Write-Host "azAutomationAccountName can't be NULL, EMPTY, or have WHITESPACE."
    Exit 1
} 

# Verify Variable:TimeZone not NULL, EMPTY, or have WHITESPACE
$azTimeZone = $TimeZone
if([string]::IsNullOrWhiteSpace($azTimeZone)) {            
    Write-Host "TimeZone can't be NULL, EMPTY, or have WHITESPACE."
    Exit 1
} 

# Verify Variable:NetworkingRG not NULL, EMPTY, or have WHITESPACE
$azNetworkingResourceGroup = $NetworkingRG
if([string]::IsNullOrWhiteSpace($azNetworkingResourceGroup)) {            
    Write-Host "NetworkingResourceGroup can't be NULL, EMPTY, or have WHITESPACE."
    Exit 1
}  else {
    Get-AzureRmResourceGroup -Name $azNetworkingResourceGroup -ErrorVariable notPresent -ErrorAction SilentlyContinue
    if ($notPresent)
    {
        Write-Host "$azNetworkingResourceGroup doesn't exist."
        Exit 1
    }
}

# Get Script Path
$ScriptPath = split-path -parent $MyInvocation.MyCommand.Definition

# Create Azure Automation Account
##################################################################################################################

New-AzureRmAutomationAccount -Location $azRegion -ResourceGroupName $azResourceGroup -Name $azAutomationAccountName

# Create Azure Run As Account
##################################################################################################################

# Set the Azure Subscription to the one specified.
Get-AzureRmSubscription -SubscriptionId $azSubscriptionId | Select-AzureRmSubscription

# Get ObjectId of the current logged in user
$azObjectID = Get-Azureaduser

# Create Azure Key Vault
$azKeyVaultName="$azEnvironment-vault"
$GetKeyVault = Get-AzureRmKeyVault -ResourceGroupName $azResourceGroup | Select-Object -ExpandProperty VaultName
if (!$GetKeyVault) {
    Write-Warning -Message "Azure Key Vault: $azKeyVaultName not found. Creating Azure Key Vault: $azEnvironment-vault"
    $keyValut = New-AzureRmKeyVault -VaultName $azKeyVaultName -ResourceGroupName $azResourceGroup -Location $azRegion
    if (!$keyValut) {
        Write-Error -Message "Azure Key Vault: $azKeyVaultName creation failed."
        Exit 1
    }
    Start-Sleep -s 15     
}

# Grant ObjectId of the current logged in user access to the Key Vault
Set-AzureRmKeyVaultAccessPolicy -ResourceGroupName $azResourceGroup -VaultName $azKeyVaultName -ObjectId $azObjectID.ObjectId -PermissionsToCertificates get,list,delete,create,import,update,managecontacts,getissuers,listissuers,setissuers,deleteissuers,manageissuers,recover,purge,backup,restore -PermissionsToKeys decrypt,encrypt,unwrapKey,wrapKey,verify,sign,get,list,update,create,import,delete,backup,restore,recover,purge -PermissionsToSecrets get,list,set,delete,backup,restore,recover,purge -PermissionsToStorage get,list,delete,set,update,regeneratekey,getsas,listsas,deletesas,setsas,recover,backup,restore,purge

# Generate Self Signed Certificate
[String] $ApplicationDisplayName = $azAutomationAccountName
[String] $SelfSignedCertPlainPassword = [Guid]::NewGuid().ToString().Substring(0, 8) + "!" 
$KeyVaultName = Get-AzureRmKeyVault -ResourceGroupName $azResourceGroup | Select-Object -ExpandProperty VaultName
[int] $NoOfMonthsUntilExpired = 36

$azPsPath=get-location

$CertifcateAssetName = "AzureRunAsCertificate"
$CertificateName = $azAutomationAccountName + $CertifcateAssetName
$PfxCertPathForRunAsAccount = Join-Path $azPsPath ($CertificateName + ".pfx")
$PfxCertPlainPasswordForRunAsAccount = $SelfSignedCertPlainPassword
$CerCertPathForRunAsAccount = Join-Path $azPsPath ($CertificateName + ".cer")

Write-Output "Generating the cert using Keyvault..."

$certSubjectName = "cn=" + $certificateName

$Policy = New-AzureKeyVaultCertificatePolicy -SecretContentType "application/x-pkcs12" -SubjectName $certSubjectName  -IssuerName "Self" -ValidityInMonths $noOfMonthsUntilExpired -ReuseKeyOnRenewal
$AddAzureKeyVaultCertificateStatus = Add-AzureKeyVaultCertificate -VaultName $keyVaultName -Name $certificateName -CertificatePolicy $Policy 
  
While ($AddAzureKeyVaultCertificateStatus.Status -eq "inProgress") {
    Start-Sleep -s 10
    $AddAzureKeyVaultCertificateStatus = Get-AzureKeyVaultCertificateOperation -VaultName $keyVaultName -Name $certificateName
}
 
if ($AddAzureKeyVaultCertificateStatus.Status -ne "completed") {
    Write-Error -Message "Key vault cert creation is not sucessfull and its status is: $status.Status" 
}

$secretRetrieved = Get-AzureKeyVaultSecret -VaultName $keyVaultName -Name $certificateName
$pfxBytes = [System.Convert]::FromBase64String($secretRetrieved.SecretValueText)
$certCollection = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection
$certCollection.Import($pfxBytes, $null, [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)
   
# Export  the .pfx file 
$protectedCertificateBytes = $certCollection.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12, $PfxCertPlainPasswordForRunAsAccount)
[System.IO.File]::WriteAllBytes($PfxCertPathForRunAsAccount, $protectedCertificateBytes)

# Export the .cer file 
$cert = Get-AzureKeyVaultCertificate -VaultName $keyVaultName -Name $certificateName
$certBytes = $cert.Certificate.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert)
[System.IO.File]::WriteAllBytes($CerCertPathForRunAsAccount, $certBytes)

# Create Service Principal
Write-Output "Creating service principal..."

$PfxCert = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Certificate2 -ArgumentList @($PfxCertPathForRunAsAccount, $PfxCertPlainPasswordForRunAsAccount)
    
$keyValue = [System.Convert]::ToBase64String($PfxCert.GetRawCertData())
$KeyId = [Guid]::NewGuid() 

$startDate = Get-Date
$endDate = (Get-Date $PfxCert.GetExpirationDateString()).AddDays(-1)

# Use Key credentials and create AAD Application
$Application = New-AzureRmADApplication -DisplayName $ApplicationDisplayName -HomePage ("http://" + $applicationDisplayName) -IdentifierUris ("http://" + $KeyId)
New-AzureRmADAppCredential -ApplicationId $Application.ApplicationId -CertValue $keyValue -StartDate $startDate -EndDate $endDate 
New-AzureRMADServicePrincipal -ApplicationId $Application.ApplicationId 

# Sleep here for a few seconds to allow the service principal application to become active (should only take a couple of seconds normally)
Start-Sleep -s 15

# Grant SPN the Contributor role to the Subscription
New-AzureRMRoleAssignment -RoleDefinitionName Contributor -ServicePrincipalName $Application.ApplicationId -scope ("/subscriptions/" + $subscriptionId) -ErrorAction SilentlyContinue
Start-Sleep -s 10

# Create the automation certificate asset
Write-Output "Creating Certificate in the Asset..."
$CertPassword = ConvertTo-SecureString $PfxCertPlainPasswordForRunAsAccount -AsPlainText -Force   
New-AzureRmAutomationCertificate -ResourceGroupName $azResourceGroup -automationAccountName $azAutomationAccountName -Path $PfxCertPathForRunAsAccount -Name $certifcateAssetName -Password $CertPassword -Exportable  | write-verbose

# Populate the ConnectionFieldValues
$ConnectionTypeName = "AzureServicePrincipal"
$ConnectionAssetName = "AzureRunAsConnection"
$ApplicationId = $Application.ApplicationId 
$SubscriptionInfo = Get-AzureRmSubscription -SubscriptionId $SubscriptionId
$TenantID = $SubscriptionInfo | Select-Object TenantId -First 1
$Thumbprint = $PfxCert.Thumbprint
$ConnectionFieldValues = @{"ApplicationId" = $ApplicationID; "TenantId" = $TenantID.TenantId; "CertificateThumbprint" = $Thumbprint; "SubscriptionId" = $SubscriptionId} 

# Create a Automation connection asset named AzureRunAsConnection in the Automation account. This connection uses the service principal.
Write-Output "Creating Connection in the Asset..."
New-AzureRmAutomationConnection -ResourceGroupName $azResourceGroup -automationAccountName $azAutomationAccountName -Name $connectionAssetName -ConnectionTypeName $connectionTypeName -ConnectionFieldValues $connectionFieldValues 

# Remove exported certificates
Write-Output "Remove exported certificates"
Remove-Item $PfxCertPathForRunAsAccount
Remove-Item $CerCertPathForRunAsAccount

Write-Output "RunAsAccount Creation Completed..."

# Create Azure Policies
##################################################################################################################

# Restrict creation of new objects to $azRegion Datacentre using a built-in policy
$Subscription = Get-AzureRmSubscription -SubscriptionId $azSubscriptionId
$Policy = Get-AzureRmPolicyDefinition -BuiltIn | Where-Object {$_.Properties.DisplayName -eq 'Allowed locations'}
$AllowedLocations = @{'listOfAllowedLocations'=@($azRegion)}
New-AzureRmPolicyAssignment `
    -Name "Location: Restrict resource creation to $azRegion" `
    -PolicyDefinition $Policy `
    -Scope "/subscriptions/$Subscription" `
    -PolicyParameterObject $AllowedLocations

# Restrict creation of new resources groups to $azRegion Datacentre using a built-in policy
$Subscription = Get-AzureRmSubscription -SubscriptionId $azSubscriptionId
$Policy = Get-AzureRmPolicyDefinition -BuiltIn | Where-Object {$_.Properties.DisplayName -eq 'Allowed locations for resource groups'}
$AllowedLocations = @{'listOfAllowedLocations'=@($azRegion)}
$ExcludedResourceGroup = Get-AzureRmResourceGroup -ResourceGroupName $azNetworkingResourceGroup
New-AzureRmPolicyAssignment `
    -Name "Location: Restrict resource group creation to $azRegion" `
    -PolicyDefinition $Policy `
    -Scope "/subscriptions/$Subscription" `
    -NotScope $ExcludedResourceGroup.ResourceId `
    -PolicyParameterObject $AllowedLocations

# Restrict the creation of vnets using a built-in policy
$Subscription = Get-AzureRmSubscription -SubscriptionId $azSubscriptionId
$Policy = Get-AzureRmPolicyDefinition -BuiltIn | Where-Object {$_.Properties.DisplayName -eq 'Not allowed resource types'}
$NotAllowedResourceTypes = @{'listOfResourceTypesNotAllowed'=@('Microsoft.Network/virtualNetworks')}
$ExcludedResourceGroup = Get-AzureRmResourceGroup -ResourceGroupName $azNetworkingResourceGroup
New-AzureRmPolicyAssignment `
    -Name "Network: Restrict creation of vNets to authorized RGs" `
    -PolicyDefinition $Policy `
    -Scope "/subscriptions/$Subscription" `
    -NotScope $ExcludedResourceGroup.ResourceId `
    -PolicyParameterObject $NotAllowedResourceTypes

# Restrict the creation of PIPs using a built-in policy
$Subscription = Get-AzureRmSubscription -SubscriptionId $azSubscriptionId
$Policy = Get-AzureRmPolicyDefinition -BuiltIn | Where-Object {$_.Properties.DisplayName -eq 'Not allowed resource types'}
$NotAllowedResourceTypes = @{'listOfResourceTypesNotAllowed'=@('Microsoft.Network/publicIPAddresses')}
$ExcludedResourceGroup = Get-AzureRmResourceGroup -ResourceGroupName $azNetworkingResourceGroup
New-AzureRmPolicyAssignment `
    -Name "Network: Restrict creation of PIPs to authorized RGs" `
    -PolicyDefinition $Policy `
    -Scope "/subscriptions/$Subscription" `
    -NotScope $ExcludedResourceGroup.ResourceId `
    -PolicyParameterObject $NotAllowedResourceTypes

# Enforce creation of VMs with managed disks using a custom policy
$Subscription = Get-AzureRmSubscription -SubscriptionId $azSubscriptionId
$definition = New-AzureRmPolicyDefinition -Name "use-managed-disk-vm" -DisplayName "Create VM using Managed Disk" -description "Create VM using Managed Disk" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/use-managed-disk-vm/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/use-managed-disk-vm/azurepolicy.parameters.json' -Mode All
New-AzureRMPolicyAssignment `
    -Name "VM: Enforce creation of VMs with managed disks" `
    -PolicyDefinition $definition `
    -Scope "/subscriptions/$Subscription"

Write-Output "Azure Policies Creation Completed..."

# Create Azure Automation Runbooks (Last to provide time for the Run As Account creation)
##################################################################################################################

# Remove Tutorial Templates
(Get-AzureRmAutomationRunbook -ResourceGroupName $azResourceGroup -AutomationAccountName $azAutomationAccountName | Where-Object {$_.Name -like "AzureAutomationTutorial*"}) | Remove-AzureRmAutomationRunbook -force

# Import and Publish Update Automation Azure Modules Runbook
$runbookName = "Update-AutomationAzureModulesForAccount"
$runbookType = "PowerShell"
Import-AzureRMAutomationRunbook -Name $runbookName -Path "$ScriptPath/runbooks/Update-AutomationAzureModulesForAccount.ps1" -ResourceGroupName $azResourceGroup -AutomationAccountName $azAutomationAccountName -Type $runbookType | Publish-AzureRmAutomationRunbook
$runbookParms = @{"AutomationAccountName"=$azAutomationAccountName; "ResourceGroupName"=$azResourceGroup}
Start-AzureRmAutomationRunbook -AutomationAccountName $azAutomationAccountName -Name $runbookName -ResourceGroupName $azResourceGroup -Parameters $runbookParms # Update Azure Automation PowerShell Modules

# Import and Publish Power Management Runbook
$runbookName = "Apply-AzVmPowerStatePolicy"
$runbookType = "PowerShellWorkflow"
Import-AzureRMAutomationRunbook -Name $runbookName -Path "$ScriptPath/runbooks/Apply-AzVmPowerStatePolicy.ps1" -ResourceGroupName $azResourceGroup -AutomationAccountName $azAutomationAccountName -Type $runbookType | Publish-AzureRmAutomationRunbook

$StartTime = Get-Date
$StartTime = $StartTime.AddHours(2)
$StartTime = ($StartTime.AddMinutes(- $StartTime.Minute % 60)).AddSeconds(- $StartTime.Second % 60)
$Schedule = (New-AzureRmAutomationSchedule -AutomationAccountName $azAutomationAccountName -Name "Schedule-AzVmPowerStatePolicy" -StartTime $StartTime -HourInterval 1 -ResourceGroupName $azResourceGroup).Name

Register-AzureRmAutomationScheduledRunbook -AutomationAccountName $azAutomationAccountName -Name $runbookName -ScheduleName $Schedule -ResourceGroupName $azResourceGroup -Parameters @{
    AzureVmTimeZone=$azTimeZone
    DefaultStartTime="Disabled"
    DefaultStopTime="18:00"
    ListOfDaysToStartVms="Mon,Tue,Wed,Thu,Fri"
    WhatIf=$False
}

# Import and Publish Tagging Runbook
$runbookName = "Apply-AzTagPolicy"
$runbookType = "PowerShell"

Import-AzureRMAutomationRunbook -Name $runbookName -Path "$ScriptPath/runbooks/Apply-AzTagPolicy.ps1" -ResourceGroupName $azResourceGroup -AutomationAccountName $azAutomationAccountName -Type $runbookType | Publish-AzureRmAutomationRunbook

$StartTime = Get-Date "23:00:00"
$Schedule = (New-AzureRmAutomationSchedule -AutomationAccountName $azAutomationAccountName -Name "Schedule-AzTagPolicy" -StartTime $StartTime -DayInterval 1 -ResourceGroupName $azResourceGroup).Name

Register-AzureRmAutomationScheduledRunbook -AutomationAccountName $azAutomationAccountName -Name $runbookName -ScheduleName $Schedule -ResourceGroupName $azResourceGroup -Parameters @{
    ExcludedTags='powerManagement'
    WhatIf=$False
}
