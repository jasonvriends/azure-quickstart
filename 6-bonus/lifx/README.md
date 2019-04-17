# 6-bonus/lifx

LIFX Wi-Fi LED Smart Lights are energy efficient LED lights that you control with your iPhone, Android, or a variety of Apps & Services

This template deploys an <a href="https://azure.microsoft.com/en-us/services/functions/">Azure Function</a> written in NodeJS, enabling you to control your LIFX Wi-Fi LED Smart Lights with a simple GET/POST to a HTTP Trigger.

## Prerequisites

To deploy this quickstart template, you need the following:
* **Azure subscription**. 
  * If you don't have one yet, you can <a href="https://azure.microsoft.com/pricing/member-offers/msdn-benefits-details/">activate your MSDN subscriber benefits</a> or <a href="https://azure.microsoft.com/free">sign up for a free account</a>.
* **LIFX Wi-Fi LED Smart Light**.
  * If you don't have one yet, you can purchase one via <a href="https://www.amazon.ca/l/14003509011">Amazon</a>.
* **LIFX App** for iOS, Android, or Windows 10.
* **LIFX Personal Access Token** obtainable via https://cloud.lifx.com/.

## Features/Capabilities
* Ability to power on/off one or more LIFX Wi-Fi LED Smart Lights
* Ability to adjust the color, brightness, and effect of one or more LIFX Wi-Fi LED Smart Lights

## Documentation References
* <a href="https://api.developer.lifx.com/docs">LIFX HTTP Remote Control API</a>
* <a href="https://github.com/klarstil/lifx-http-api">LIFX HTTP API Node.JS wrapper</a>
* <a href="https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local">Azure Functions Core Tools</a>

## Setup

### Cloud Connecting your LIFX

1. Download the **LIFX App** for iOS, Android, or Windows 10.
2. Plug in one or more LIFX Wi-Fi LED Smart Lights and power them on.
3. Open the **LIFX App**
* If this is your first time opening the LIFX app, tap "Register".
* Enter the email address that you want to use for your account.
* Enter a password to protect your LIFX account.
4. Follow the Step by Step instructions to <a href="http://www.lifx.com/supportcloud">add a light to your LIFX cloud account</a>.

### Obtain a Personal Access Token
1. Visit https://cloud.lifx.com.
2. Sign In or Register for an account.
3. At the top right, select your **email address** then **Settings**.
4. Select Generate New Token, define a friendly name, and copy your token and keep it safe (we will require this later for the Azure Function deployment).

## Deployment Options

### Azure Portal

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjasonvriends%2Fazure-quickstart%2Fmaster%2F6-bonus%2Flifx%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fjasonvriends%2Fazure-quickstart%2Fmaster%2F6-bonus%2Flifx%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a><br/>

### Azure PowerShell

```powershell

# Azure Subscription Configuration
##################################################################################################################

## Input the Azure Region to deploy the resources to (i.e. canadaeast, canadacentral, eastus, etc.).
$AzureRegion="eastus"

## Input the prefix for your Azure Innovation Lab (i.e. dev, tst, prod, innovation, etc.).
$AzureEnvironment="bonus"

## Input the prefix for the resource group to deploy this quickstart template into.
$ResourceGroupName="lifx"
 
# Template Parameters
##################################################################################################################

## Input the name of the function app that you wish to create.
$appNamePrefix="lifx"

## Input your LIFX Personal Access Token from https://cloud.lifx.com
$lifxPersonalAccessToken=""

## The Github URL that contains the Azure Function binaries.
$packageUri="https://raw.githubusercontent.com/jasonvriends/azure-quickstart/master/6-bonus/lifx/lifxProj.zip"  

## Storage Account Type
$storageAccountType="Standard_LRS"

## The language worker runtime to load in the function app.
$runtime="node"

# Resource Group Creation
##################################################################################################################

$DeploymentResourceGroup="$ResourceGroupName-$AzureEnvironment-rg"
New-AzureRmResourceGroup -Name "$DeploymentResourceGroup" -Location "$AzureRegion" -ErrorVariable notCreated -ErrorAction SilentlyContinue

# Template Deployment to Resource Group
##################################################################################################################

$TemplateUri="https://github.com/jasonvriends/azure-quickstart/raw/master/6-bonus/lifx/azuredeploy.json"
New-AzResourceGroupDeployment -Name "deploy-lifx" -ResourceGroupName "$DeploymentResourceGroup" -TemplateUri "$TemplateUri" -appNamePrefix "$appNamePrefix" -lifxPersonalAccessToken "$lifxPersonalAccessToken" -repoURL "$repoURL" -branch "$branch" -storageAccountType "$storageAccountType" -runtime "$runtime" -folderPath "$folderPath"


```

### Azure CLI

```shell

# Azure Subscription Configuration
##################################################################################################################

## Input the Azure Region to deploy the resources to (i.e. canadaeast, canadacentral, eastus, etc.).
AzureRegion="eastus"

## Input the prefix for your Azure Innovation Lab (i.e. dev, tst, prod, innovation, etc.).
AzureEnvironment="bonus"

## Input the prefix for the resource group to deploy this quickstart template into.
ResourceGroupName="lifx"

# Template Parameters
##################################################################################################################

## Input the name of the function app that you wish to create.
appNamePrefix="lifx"

## Input your LIFX Personal Access Token from https://cloud.lifx.com
lifxPersonalAccessToken=""

## The Github URL that contains the Azure Function binaries.
$packageUri="https://raw.githubusercontent.com/jasonvriends/azure-quickstart/master/6-bonus/lifx/lifxProj.zip"

# Storage Account Type
storageAccountType="Standard_LRS"

## The language worker runtime to load in the function app.
runtime="node"

# Resource Group Creation
##################################################################################################################

DeploymentResourceGroup="$ResourceGroupName-$AzureEnvironment-rg"
az group create -n "$DeploymentResourceGroup" -l "$AzureRegion"

# Template Deployment to Resource Group
##################################################################################################################

TemplateUri="https://github.com/jasonvriends/azure-quickstart/raw/master/6-bonus/lifx/azuredeploy.json"
az group deployment create --name "deploy-lifx" --resource-group "$DeploymentResourceGroup" --template-uri "$TemplateUri" --parameters appNamePrefix="$appNamePrefix" lifxPersonalAccessToken="$lifxPersonalAccessToken" repoURL="$repoURL" branch="$branch" storageAccountType="$storageAccountType" runtime="$runtime" folderPath="$folderPath"


```

## Example Use Case(s)

### Change light color based on DevOps pipline build status.
1. Browse to https://devops.azure.com
2. Sign in to Azure DevOps
3. Create a project
    * Specify a project Name, description, and visibility (public or private).
4. Select **Project settings**
5. Select **Service Hooks**
6. Create a new Service Hook for **Build Succeeded**
    * Service: **Web Hooks**
    * Trigger: **Build Completed**
    * Filters:
        * Build pipeline: **[Any]**
        * Build Status: **Succeeded**
    * Action: **Post via HTTP**
        * Settings
        * URL: https://<**function_url**>/api/httpTriggerFunc?code=**<your_function_code>**&selector=all&power=on&effect=breathe&color=green&persist=true&period=3&cycles=10
7. Create a new Service Hook for **Build Failed**
    * Service: **Web Hooks**
    * Trigger: **Build Completed**
    * Filters:
        * Build pipeline: **[Any]**
        * Build Status: **Failed**
    * Action: **Post via HTTP**
        * Settings
        * URL: https://<**function_url**>/api/httpTriggerFunc?code=**<your_function_code>**&selector=all&power=on&effect=breathe&color=red&persist=true&period=3&cycles=10
8. Create a Pipeline that executes the command
    * docker build -f Dockerfile -t $(imageName) .
9. Create a Dockerfile within the repo that contains
    * FROM alpine:latest

* Any changes to the Docker file that causes the build to **complete** will turn the light **green**, or that causes the build to **fail** will turn the light **red**.