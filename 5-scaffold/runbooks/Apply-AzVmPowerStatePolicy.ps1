<#
.Author
    Matthew Schoyen
.Synopsis
    This Azure Automation PowerShell Workflow type Runbook Starts/Stops Azure VMs in parallel on a schedule based a VM tag (powerManagement).
.Description
		For a detailed description visit https://github.com/jasonvriends/azure-quickstart/tree/master/2-scaffold		
.Inputs
    None
.Outputs
    None
.Link 
	The original source https://ps1code.com/category/powershell/azure/
#>

Workflow Apply-AzVmPowerStatePolicy
{
	Param (
		#[System.TimeZoneInfo]::GetSystemTimeZones() |ft -au
		[Parameter(Mandatory = $false, Position = 1)]
		[string]$AzureVmTimeZone = 'Eastern Standard Time'
		 ,
		[Parameter(Mandatory = $false, Position = 2)]
		[string]$DefaultStartTime = 'Disabled'
		 ,
		[Parameter(Mandatory = $false, Position = 3)]
		[string]$DefaultStopTime = '18:00'
		 ,
		[Parameter(Mandatory = $false, Position = 4)]
		[string]$ListOfDaysToStartVms = 'Mon,Tue,Wed,Thu,Fri'
		,
		[Parameter(Mandatory = $false, Position = 5)]
		[boolean]$WhatIf = $true
	)

	$ErrorActionPreference = 'Stop'

	# Authenticate to Azure using the AzureRunAsConnection
	$connectionName = "AzureRunAsConnection"
	try
	{
		$servicePrincipalConnection=Get-AutomationConnection -Name $connectionName

		"Logging in to Azure..."
		$null = Add-AzureRmAccount `
				-ServicePrincipal `
				-TenantId $servicePrincipalConnection.TenantId `
				-ApplicationId $servicePrincipalConnection.ApplicationId `
				-CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint
	}
	catch
	{
		if (!$servicePrincipalConnection)
		{
			$ErrorMessage = "Connection $connectionName not found."
			throw $ErrorMessage
		}
		else
		{
			Write-Error -Message $_.Exception
			throw $_.Exception
		}
	}

	$AzVms = Get-AzureRmVm |
	Select-Object Name, Tags, ResourceGroupName, @{ N = 'PowerState'; E = { (Get-AzureRmVM -Name $_.Name -ResourceGroupName $_.ResourceGroupName -Status |
	Select-Object -expand Statuses | Where-Object { $_.Code -match 'PowerState/' } |
	Select-Object @{ N = 'PowerState'; E = { $_.Code.Split('/')[1] } }).PowerState } } | Sort-Object Name

	$azTime = [datetime]::Now
	$TimeVmLong = [System.TimeZoneInfo]::ConvertTimeFromUtc($azTime.ToString(), [System.TimeZoneInfo]::FindSystemTimeZoneById($AzureVmTimeZone))
	$TimeVm = $TimeVmLong.ToString('HHmm')
	
	$ArrayOfDaysToStartVms = $ListOfDaysToStartVms -split ','
	$DayVm = $TimeVmLong.ToString('ddd')

	Foreach -Parallel ($AzVm in $AzVms)
	{
		$TagString = $AzVm.Tags.powerManagement -split ';'
		if ($TagString)
		{
			$StartTime = $TagString[0]
			$StopTime = $TagString[1]
		}
		else
		{
			$TagString = (Get-AzureRmResourceGroup -Name $AzVm.ResourceGroupName).Tags.powerManagement -split ';'
			if ($TagString)
			{
				$StartTime = $TagString[0]
				$StopTime = $TagString[1]
			}
			else
			{
				$StartTime = $DefaultStartTime
				$StopTime = $DefaultStopTime
			}
		}
		
		Try
		{
			### Running VM ###
			if ($AzVm.PowerState -eq 'running')
			{
				### Flag to NOT Stop VM ###
				if ($StopTime -ne 'Disabled')
				{
					### Check that the StartTime is not Disabled before doing time comparisons ###
					if ($StartTime -ne 'Disabled')
					{
						### 00:00---On+++Off---00:00 ###
						if ($StartTime -lt $StopTime)
						{
							if ($TimeVm -gt $StopTime -or $TimeVm -lt $StartTime)
							{
								if ($WhatIf) { $Status = 'Simulation' }
								else
								{
									$Status = (Stop-AzureRmVm -Name $AzVm.Name -ResourceGroupName $AzVm.ResourceGroupName -Force).StatusCode
								}
								$Execution = 'Stopped'
							}
							else { $Execution = 'NotRequired' }

						### 00:00+++Off---On+++00:00 ###
						}
						else
						{
							if ($TimeVm -gt $StopTime -and $TimeVm -lt $StartTime)
							{
								if ($WhatIf) { $Status = 'Simulation' }
								else
								{
									$Status = (Stop-AzureRmVm -Name $AzVm.Name -ResourceGroupName $AzVm.ResourceGroupName -Force).StatusCode
								}
								$Execution = 'Stopped'
							}
							else { $Execution = 'NotRequired' }
						}
					}
					### If StartTime is Disabled, stop the VM after the StopTime ###
					else
					{
						if ($TimeVm -gt $StopTime)
						{
							if ($WhatIf) { $Status = 'Simulation' }
							else
							{
								$Status = (Stop-AzureRmVm -Name $AzVm.Name -ResourceGroupName $AzVm.ResourceGroupName -Force).StatusCode
							}
							$Execution = 'Stopped'
						}
						else { $Execution = 'NotRequired' }
					}
				}
				else { $Execution = 'NotRequired' }
			}
			### Not running VM (stopped/deallocated/suspended etc.) ###
			else
			{
				### Flag to NOT Start VM ###
				if ($StartTime -ne 'Disabled' -and $DayVm -in $ArrayOfDaysToStartVms)
				{
					### Check that the StopTime is not Disabled before doing time comparisons ###
					if ($StopTime -ne 'Disabled')
					{
						### 00:00---On+++Off---00:00 ###
						if ($StartTime -lt $StopTime)
						{
							if ($TimeVm -gt $StartTime -and $TimeVm -lt $StopTime)
							{
								if ($WhatIf) { $Status = 'Simulation' }
								else
								{
									$Status = (Start-AzureRmVm -Name $AzVm.Name -ResourceGroupName $AzVm.ResourceGroupName).StatusCode
								}
								$Execution = 'Started'
							}
							else { $Execution = 'NotRequired' }

						}
						### 00:00+++Off---On+++00:00 ###
						else
						{
							if ($TimeVm -gt $StartTime -or $TimeVm -lt $StopTime)
							{
								if ($WhatIf) { $Status = 'Simulation' }
								else
								{
									$Status = (Start-AzureRmVm -Name $AzVm.Name -ResourceGroupName $AzVm.ResourceGroupName).StatusCode
								}
								$Execution = 'Started'
							}
							else { $Execution = 'NotRequired' }
						}
					}
					### If StopTime is Disabled, start the VM after the StartTime ###
					else
					{
						if ($TimeVm -gt $StartTime)
						{
							if ($WhatIf) { $Status = 'Simulation' }
							else
							{
								$Status = (Start-AzureRmVm -Name $AzVm.Name -ResourceGroupName $AzVm.ResourceGroupName).StatusCode
							}
							$Execution = 'Started'
						}
						else { $Execution = 'NotRequired' }
					}
				}
				else { $Execution = 'NotRequired' }
			}
			$Prop = [ordered]@{
				AzureVM       = $AzVm.Name
				ResourceGroup = $AzVm.ResourceGroupName
				PowerState    = (Get-Culture).TextInfo.ToTitleCase($AzVm.PowerState)
				StartDays	  = $ListOfDaysToStartVms
				StartTime     = $StartTime
				StopTime      = $StopTime
				StateChange   = $Execution
				StatusCode    = $Status
				TimeStamp     = $TimeVmLong
			}
		}
		Catch
		{
			$Prop = [ordered]@{
				AzureVM       = $AzVm.Name
				ResourceGroup = $AzVm.ResourceGroupName
				PowerState    = (Get-Culture).TextInfo.ToTitleCase($AzVm.PowerState)
				StartDays	  = $ListOfDaysToStartVms
				StartTime     = $StartTime
				StopTime      = $StopTime
				StateChange   = 'Unknown'
				StatusCode    = 'Error'
				TimeStamp     = $TimeVmLong
			}
		}
		Finally
		{
			$Obj = New-Object PSObject -Property $Prop
			Write-Output -InputObject $Obj
		}
	}
} #End Workflow Apply-AzVmPowerStatePolicy
