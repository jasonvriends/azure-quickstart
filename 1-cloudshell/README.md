# 1-cloud-shell

<a href="https://docs.microsoft.com/en-us/azure/cloud-shell/overview">Azure Cloud Shell</a> is an interactive, browser-accessible shell for managing Azure resources. It provides the flexibility of choosing the shell experience that best suits the way you work. Linux users can opt for a Bash experience, while Windows users can opt for PowerShell.

## Prerequisites

To deploy this quickstart template, you need the following:
* **Azure subscription**. 
  * If you don't have one yet, you can <a href="https://azure.microsoft.com/pricing/member-offers/msdn-benefits-details/">activate your MSDN subscriber benefits</a> or <a href="https://azure.microsoft.com/free">sign up for a free account</a>.

## Canadian Region Support

If you would like to see **Canadian Region Support** for Azure Cloud Shell, please submit your feedback <a href="https://feedback.azure.com/forums/598699-azure-cloud-shell/suggestions/35069854-canadia-region-support-for-storage-account">here.</a>

## Security/Design Considerations
* Storage accounts within Microsoft Azure are <a href="https://docs.microsoft.com/en-us/azure/azure-subscription-service-limits#storage-limits">limited</a> to **250** per **region** per **subscription**.
* Following the Microsoft recommendation (storage account **per Cloud Shell user**), you will quickly reach this limitation.
* As such, if you are only using Azure Cloud Shell for provisioning (**not storing files**), I suggest the following:
  * Create an Azure AD group dedicated to Cloud Shell (i.e. accessCloudShell).
  * Create a Resource Group dedicated to Cloud Shell (i.e. cloudshell-innovation-rg).
  * Grant the Azure AD group contributor access to this Resource Group.
  * Provision a single storage account within this Resource Group (i.e. cloudshell<uniquestring>).
  * Create a File Share within this storage account called (i.e. cloudshell).
  * Create folders within this File Share for each user that requires access to cloud shell.

## Deployment Options

I have not yet found a fully automated method to enable Azure Cloud Shell to users. It's possible to automate the creation of the Resource Group, Storage Account, and even a File Share with the magic of Azure Container Instances. However, the user still need to finish the job.

1. Launch https://shell.azure.com.
2. Select your desired **Subscription**.
3. Select your desired **Cloud Shell region**.
4. Create a **Resource Group** specifically for Cloud Shell (i.e. cloudshell-innovation-rg).
5. Create a **Storage Account** with a globally unique name (i.e. cloudshell<timestamp>).
6. Create a **File Share** within the Storage Account (i.e. firstname-lastname).

If following the approach under the **Security/Design Considerations** section, new users simply have to select all of the existing items and create another File Share.