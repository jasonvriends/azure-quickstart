# 6-bonus/teXXmo

The teXXmo IoT Button enables direct customer or workforce feedback into Azure. By a click of a button, you can send predefined messages to your cloud. Send information, such as presence of people, material or purchasing demand and react on this from Azure. The IoT button offers instant feedback and integrates directly in all your Azure analysis and response tools.

# Table of Contents

-   [Step 1: Prerequisites](#step-1-prerequisites)
-   [Step 2: Provision Azure Services](#step-2-provision-azure-services)
    -   [Azure Portal](#azure-portal)
    -   [Azure PowerShell](#azure-powershell)
    -   [Azure CLI](#azure-cli)
-   [Step 3: Register the teXXmo Azure IoT button within the Azure IoT hub](#step-3-register-the-teXXmo-azure-iot-button-within-Azure-IoT-hub)
-   [Step 4: Configure teXXmo Azure IoT Button](#step-4-configure-teXXmo-azure-iot-button)
-   [Step 5: Verify communication between teXXmo Azure IoT button and Azure IoT Hub](#step-5-verify-communication-between-texxmo-azure-iot-button-and-azure-iot-hub)
-   [.Step 6: Modify the Azure IoT Hub Function App as desired](#step-6-modify-the-azure-iot-hub-function-app-as-desired).

# Step 1: Prerequisites

To deploy this quickstart template, you need the following:
* **Azure subscription**. 
  * If you don't have one yet, you can <a href="https://azure.microsoft.com/pricing/member-offers/msdn-benefits-details/">activate your MSDN subscriber benefits</a> or <a href="https://azure.microsoft.com/free">sign up for a free account</a>.
* **teXXmo Azure IoT button**
  * If you don't have one yet, you can purchase one via <a href="https://www.texxmo-shop.de/epages/82740787.sf/en_US/?ObjectPath=/Shops/82740787/Products/TX-IOT-20W-GR">teXXmo</a>.

# Step 2: Provision Azure Services

## Azure Portal

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjasonvriends%2Fazure-quickstart%2Fmaster%2F6-bonus%2FteXXmo%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fjasonvriends%2Fazure-quickstart%2Fmaster%2F6-bonus%2FteXXmo%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a><br/>

## Azure PowerShell

```powershell

# Azure Subscription Configuration
##################################################################################################################

## Input the Azure Region to deploy the resources to (i.e. canadaeast, canadacentral, eastus, etc.).
$AzureRegion="eastus"

## Input the prefix for your Azure Innovation Lab (i.e. dev, tst, prod, innovation, etc.).
$AzureEnvironment="bonus"

## Input the prefix for the resource group to deploy this quickstart template into.
$ResourceGroupName="texxmo"

# Template Parameters
##################################################################################################################

## Input the prefix of the Azure IoT hub that you wish to create.
$iotHubNamePrefix="iot"

## Input the pricing tier of the Azure IoT hub.
$iotHubSkuName="F1"

## Input the pricing tier and the capacity determine the maximum daily quota of messages that you can send.
$iotHubSkuCapacity=1

## Input how long the IoT hub will maintain device-to-cloud events.
$iotHubMessageRetentionInDays=1

## Input the number of partitions relates the device-to-cloud messages to the number of simultaneous readers of these messages.
$iotHubPartitionCount=2

## Input the prefix of the Azure Function App that you wish to create.
$functionAppPrefix="texxmo"

## The Github URL that contains the Azure Function binaries.
$functionPackageUri="https://raw.githubusercontent.com/jasonvriends/azure-quickstart/master/6-bonus/teXXmo/teXXmoProj.zip"

## Storage Account Type
$functionStorageAccountType="Standard_LRS"

## The language worker runtime to load in the function app.
$functionRuntime="node"

# Resource Group Creation
##################################################################################################################

$DeploymentResourceGroup="$ResourceGroupName-$AzureEnvironment-rg"
New-AzureRmResourceGroup -Name "$DeploymentResourceGroup" -Location "$AzureRegion"

# Template Deployment to Resource Group
##################################################################################################################

$TemplateUri="https://raw.githubusercontent.com/jasonvriends/azure-quickstart/master/6-bonus/teXXmo/azuredeploy.json"
New-AzResourceGroupDeployment -Name "deploy-teXXmo-bonus" -ResourceGroupName "$DeploymentResourceGroup" -TemplateUri "$TemplateUri"  -iotHubNamePrefix $iotHubNamePrefix -iotHubSkuName $iotHubSkuName -iotHubSkuCapacity $iotHubSkuCapacity -iotHubMessageRetentionInDays $iotHubMessageRetentionInDays -iotHubPartitionCount $iotHubPartitionCount -functionAppPrefix $functionAppPrefix -functionPackageUri $functionPackageUri -functionStorageAccountType $functionStorageAccountType -functionRuntime $functionRuntime


```

## Azure CLI

```shell

# Azure Subscription Configuration
##################################################################################################################

## Input the Azure Region to deploy the resources to (i.e. canadaeast, canadacentral, eastus, etc.).
AzureRegion="eastus"

## Input the prefix for your Azure Innovation Lab (i.e. dev, tst, prod, innovation, etc.).
AzureEnvironment="bonus"

## Input the prefix for the resource group to deploy this quickstart template into.
ResourceGroupName="texxmo"

# Template Parameters
##################################################################################################################

## Input the prefix of the Azure IoT hub that you wish to create.
iotHubNamePrefix="iot"

## Input the pricing tier of the Azure IoT hub.
iotHubSkuName="F1"

## Input the pricing tier and the capacity determine the maximum daily quota of messages that you can send.
iotHubSkuCapacity=1

## Input how long the IoT hub will maintain device-to-cloud events.
iotHubMessageRetentionInDays=1

## Input the number of partitions relates the device-to-cloud messages to the number of simultaneous readers of these messages.
iotHubPartitionCount=2

## Input the prefix of the Azure Function App that you wish to create.
functionAppPrefix="texxmo"

## The Github URL that contains the Azure Function binaries.
functionPackageUri="https://raw.githubusercontent.com/jasonvriends/azure-quickstart/master/6-bonus/teXXmo/teXXmoProj.zip"

## Storage Account Type
functionStorageAccountType="Standard_LRS"

## The language worker runtime to load in the function app.
functionRuntime="node"

# Resource Group Creation
##################################################################################################################

DeploymentResourceGroup="$ResourceGroupName-$AzureEnvironment-rg"
az group create -n "$DeploymentResourceGroup" -l "$AzureRegion"

# Template Deployment to Resource Group
##################################################################################################################

TemplateUri="https://raw.githubusercontent.com/jasonvriends/azure-quickstart/master/6-bonus/teXXmo/azuredeploy.json"
az group deployment create --name "deploy-teXXmo-bonus" --resource-group "$DeploymentResourceGroup" --template-uri "$TemplateUri" --parameters iotHubNamePrefix=$iotHubNamePrefix iotHubSkuName=$iotHubSkuName iotHubSkuCapacity=$iotHubSkuCapacity iotHubMessageRetentionInDays=$iotHubMessageRetentionInDays iotHubPartitionCount=$iotHubPartitionCount functionAppPrefix=$functionAppPrefix functionPackageUri=$functionPackageUri functionStorageAccountType=$functionStorageAccountType functionRuntime=$functionRuntime


```

# Step 3: Register the teXXmo Azure IoT button within Azure IoT hub

1. Browse to the **Resource Group** containing your **Azure IoT Hub**.
2. Select the **Azure IoT Hub**.
3. Under **Explorers**, select **IoT devices**.
4. Select **Add**
  * Input **teXXmo1** for **Device ID** (or any friendly name that you prefer).
  * Select **Symmetric key** for **Authentication type**.
  * Select **Save** and Primary and Secondary keys will be automatically generated.
5 Select **teXXmo1**
  * Note the following:
    * **Primary** and **Secondary** keys.
    * **Hostname** under **Connection string (primary key)**.
    * These will be required for [Step 4: Configure teXXmo Azure IoT Button](#step-4-configure-teXXmo-azure-iot-button).

# Step 4: Configure teXXmo Azure IoT button

1. Hold power button for **5 seconds**.
   * The LED will change from **Green**, flash to **Yellow**, then finally flash **Red** which places the device in Access Point Mode, allowing you to connect to the device and configure it.
2. Connect to the device via WiFi using the SSID : **ESP_<Last 3 digits of MAC Address>**.
3. Browse to the device web interface and REST API by accessing http://192.168.4.1 with a web browser.
4. Select **IoT Hub Configuration**.
   * Input the **Azure IoT Hub URL**.
     * This is the **hostname** that you either noted from [Step 3: Register the teXXmo Azure IoT button within the Azure IoT hub](#step-3-register-the-teXXmo-azure-iot-button-within-Azure-IoT-hub).
   * Input the **IoT device name**.
     * This is the **device id** that you either noted from  [Step 3: Register the teXXmo Azure IoT button within the Azure IoT hub](#step-3-register-the-teXXmo-azure-iot-button-within-Azure-IoT-hub).
   * Input the **IoT device secret**.
     * This is the **primary key** that you either noted from  [Step 3: Register the teXXmo Azure IoT button within the Azure IoT hub](#step-3-register-the-teXXmo-azure-iot-button-within-Azure-IoT-hub).
5. Select **WiFi**
   * Configure the **SSID** and **Password** that the device will connect to.
6. Select **User JSON** 
   * Configure your desired message that should be sent to the Azure IoT Hub when pressed. For example: {"button1":"pressed"}.
7. Select **Shutdown**
   * This will save the configuration to the device.
   
# Step 5: Verify communication between teXXmo Azure IoT button and Azure IoT Hub.

1. Launch <a href="https://shell.azure.com">Azure Cloud Shell</a>.
2. Install the Azure CLI IoT Extension
   * **az extension add --name azure-cli-iot-ext**
3. Monitor device telemetry & messages sent to an Azure IoT hub.
   * **az iot hub monitor-events --hub-name** <hub_name>
4. Press the teXXmo Azure IoT button and confirm the message was received by the Azure IoT hub.

# Step 6: Modify the Azure IoT Hub Function App as desired.

1. Browse to the **Resource Group** containing your **Azure IoT Hub**.
2. Select the **texxmo** App Service.
3. Select the function **IoTHub_EventHub1**.
4. Modify the code as required to take your desired action for when the teXXmo Azure IoT button is trigger.

