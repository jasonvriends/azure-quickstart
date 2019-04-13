# 9-bonus/lifx

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

## Example Use Cases
* Change light color based on DevOps pipline build status.
* Change light color based on SonarQube code quality.

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

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjasonvriends%2Fazure-quickstart%2Fmaster%2F9-bonus/lifx%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fjasonvriends%2Fazure-quickstart%2Fmaster%2F9-bonus/lifx%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a><br/>

- - -

### Azure PowerShell

```

# Parameters (modifications required)
$appName="lifxdemo"
$lifxPersonalAccessToken="" # insert your LIFX personal access token
$repoURL="https://github.com/jasonvriends/azure-quickstart.git"
$branch="master"
$storageAccountType="Standard_LRS"
$runtime="node"
$AzureEnvironment="innovation"
$AzureRegion="eastus"
$ResourceGroupName="lifxdemo"

# Deployment (no modifications required)
$DeploymentResourceGroup="$ResourceGroupName-$AzureEnvironment-rg"
$TemplateUri="https://github.com/jasonvriends/azure-quickstart/raw/master/9-bonus/lifx/azuredeploy.json"

# Create Resource Group (no modifications required)
New-AzureRmResourceGroup -Name "$DeploymentResourceGroup" -Location "$AzureRegion" -ErrorVariable notCreated -ErrorAction SilentlyContinue

# Deploy to Resource Group (no modifications required)
New-AzResourceGroupDeployment -Name "deploy-lifxdemo" -ResourceGroupName "$DeploymentResourceGroup" -TemplateUri $TemplateUri -appName "$appName" -lifxPersonalAccessToken "$lifxPersonalAccessToken" -repoURL "$repoURL" -branch "$branch" -storageAccountType "$storageAccountType" -location "$AzureRegion" -runtime "$runtime"

```

- - -

### Azure CLI

```

# Parameters (modifications required)
appName="lifxdemo"
lifxPersonalAccessToken="c68e939a9961a530b9ce37e4fc5446fae46cfd42f115d1d068982d12553f2c4b" # insert your LIFX personal access token
repoURL="https://github.com/jasonvriends/azure-quickstart.git"
branch="master"
storageAccountType="Standard_LRS"
runtime="node"
AzureEnvironment="innovation"
AzureRegion="eastus"
ResourceGroupName="lifxdemo"

# Deployment (no modifications required)
DeploymentResourceGroup="$ResourceGroupName-$AzureEnvironment-rg"
TemplateUri="https://github.com/jasonvriends/azure-quickstart/raw/master/9-bonus/lifx/azuredeploy.json"

# Create Resource Group (no modifications required)
az group create -n "$DeploymentResourceGroup" -l "$AzureRegion"

# Deploy to Resource Group (no modifications required)
az group deployment create --name "deploy-lifxdemo" --resource-group "$DeploymentResourceGroup" --template-uri "$TemplateUri" --parameters appName="$appName" lifxPersonalAccessToken="$lifxPersonalAccessToken" repoURL="$repoURL" branch="$branch" storageAccountType="$storageAccountType" runtime="$runtime"

```
