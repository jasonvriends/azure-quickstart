<#
.Author
    Matthew Schoyen
.Synopsis
    This Azure Automation PowerShell Runbook non-destructively copies all tags on a Resource Group to the objects contained in that Resource Group.
.Description
		For a detailed description visit https://github.com/jasonvriends/azure-quickstart/tree/master/2-scaffold		
.Inputs
    None
.Outputs
    None
#>

Param (
	[Parameter(Mandatory = $false, Position = 1)]
	[string]$ExcludedTags = 'powerManagement'
	,
	[Parameter(Mandatory = $false, Position = 2)]
	[boolean]$WhatIf = $true
)

# Generic Service Principal authentication block for runbooks.
$connectionName = "AzureRunAsConnection"
try	{
	$servicePrincipalConnection=Get-AutomationConnection -Name $connectionName
		"Logging in to Azure..."
	$null = Add-AzureRmAccount `
		-ServicePrincipal `
		-TenantId $servicePrincipalConnection.TenantId `
		-ApplicationId $servicePrincipalConnection.ApplicationId `
		-CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint
} catch {
	if (!$servicePrincipalConnection) {
		$ErrorMessage = "Connection $connectionName not found."
		throw $ErrorMessage;
	} else {
		Write-Error -Message $_.Exception
		throw $_.Exception
	}
}

# Begin custom PowerShell script.
$ExcludedTagsArray = $ExcludedTags -split ','
$Objlist = @()

foreach ($Resource in (Get-AzureRmResource)) { 
	Try	{
		$Group = Get-AzureRmResourceGroup -Name $Resource.ResourceGroupName
		$GroupTags = $Group.Tags
		$ResourceTags = $Resource.Tags
		$NewTags = @{}
 
		# Build the list of tags to copy. Remove excluded tags and tags already on the resource.
		if ($GroupTags.Count -gt 0) {
			if ($ResourceTags.Count -gt 0) {
				foreach ($Key in $GroupTags.Keys) {
					if ((-not($ResourceTags.Keys -contains $Key)) -and (-not($ExcludedTagsArray -contains $Key))) {
						$NewTags.Add($Key, $GroupTags[$Key])
						$ResourceTags.Add($Key, $GroupTags[$Key])
					}
				}					
			} else {
				$ResourceTags = @{}
				foreach ($Key in $GroupTags.Keys) {
					if (-not($ExcludedTagsArray -contains $Key)) {
						$NewTags.Add($Key, $GroupTags[$Key])
						$ResourceTags.Add($Key, $GroupTags[$Key])
					}
				}
			}
		}

        # Write the tags to the resource.
		if ($WhatIf) { 
			if ($NewTags.Count -gt 0) {
				$Status = 'Simulated - Tags Updated' 		
			} else {
				$Status = 'Simulated - No Change'
			}	
		} else {
			if ($NewTags.Count -gt 0) {
				$Status = 'Tags Updated'
				Set-AzureRmResource -Tag $ResourceTags -ResourceId $Resource.ResourceId -Force | Out-Null
			} else {
				$Status = 'No Change'
			}
		}
		
		# Create a log entry for the changes made to the resource.
		$Prop = [ordered]@{
			ResourceGroup = $Resource.ResourceGroupName
			Resource 	  = $Resource.Name
			Status		  = $Status
			NewTags 	  = $NewTags
		}

		
	} Catch {
		# Create a log entry if there's an error.
		# Note: This will fire if object does not support tags (such as Solutions & PaaS objects)
		$Prop = [ordered]@{
			ResourceGroup = $Resource.ResourceGroupName
			Resource 	  = $Resource.Name
			Status		  = $Status
			NewTags 	  = "Error"
		}
	} Finally {
		# Write the log entry to the console.
		$Obj = New-Object PSObject -Property $Prop
		$Objlist += $Obj
	}
}
Write-Output -InputObject $Objlist | Format-Table -AutoSize
