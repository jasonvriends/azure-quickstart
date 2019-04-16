# 6-bonus/teXXmo

The teXXmo IoT Button enables direct customer or workforce feedback into Azure. By a click of a button, you can send predefined messages to your cloud. Send information, such as presence of people, material or purchasing demand and react on this from Azure. The IoT button offers instant feedback and integrates directly in all your Azure analysis and response tools.

# Table of Contents

-   [Step 1: Prerequisites](#step-1-prerequisites)
-   [Step 2: Provision Azure Services](#step-2-provision-azure-services)
    -   [Azure Portal](#azure-portal)
    -   [Azure PowerShell](#azure-powershell)
    -   [Azure CLI](#azure-cli)
-   [Step 3: Configure teXXmo Azure IoT Button](#step-3-configure-teXXmo-azure-iot-button)
-   [Step 4: Verify communication between teXXmo Azure IoT button and Azure IoT Hub](#step-4-verify-communication-between-texxmo-azure-iot-button-and-azure-iot-hub)

# Step 1: Prerequisites

To deploy this quickstart template, you need the following:
* **Azure subscription**. 
  * If you don't have one yet, you can <a href="https://azure.microsoft.com/pricing/member-offers/msdn-benefits-details/">activate your MSDN subscriber benefits</a> or <a href="https://azure.microsoft.com/free">sign up for a free account</a>.
* **teXXmo Azure IoT button**
  * If you don't have one yet, you can purchase one via <a href="https://www.texxmo-shop.de/epages/82740787.sf/en_US/?ObjectPath=/Shops/82740787/Products/TX-IOT-20W-GR">teXXmo</a>.

# Step 2: Provision Azure Services

## Azure Portal

### Azure IoT Hub

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjasonvriends%2Fazure-quickstart%2Fmaster%2F6-bonus/teXXmo/%2Fazuredeploy-iothub.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fjasonvriends%2Fazure-quickstart%2Fmaster%2F6-bonus/teXXmo/%2Fazuredeploy-iothub.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a><br/>

Currently, its not possible to register IoT devices via Azure Resource Manager templates. As such, following the Azure Portal deployment:
* Browse to the **Resource Group** containing your **Azure IoT Hub**.
* Select the **Azure IoT Hub**.
* Under **Explorers**, select **IoT devices**.
* Select **Add**
  * Input **teXXmo1** for **Device ID** (or any friendly name that you prefer).
  * Select **Symmetric key** for **Authentication type**.
  * Select **Save** and Primary and Secondary keys will be automatically generated.
* Select **teXXmo**
  * Note the **Primary** and **Secondary** key.
  * Note the **Hostname** under **Connection string (primary key)**.
  * These will be required for [Step 3: Configure teXXmo Azure IoT Button](#step-3-configure-teXXmo-azure-iot-button.

### Azure Function IoT Hub Trigger

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjasonvriends%2Fazure-quickstart%2Fmaster%2F6-bonus/teXXmo/%2Fazuredeploy-function.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fjasonvriends%2Fazure-quickstart%2Fmaster%2F6-bonus/teXXmo/%2Fazuredeploy-function.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a><br/>

## Azure PowerShell

```powershell

```

## Azure CLI

```shell


```

# Step 3: Configure teXXmo Azure IoT button

1. Hold power button for **5 seconds**.
   * The LED will change from **Green**, flash to **Yellow**, then finally flash **Red** which places the device in Access Point Mode, allowing you to connect to the device and configure it.
2. Connect to the device via WiFi using the SSID : **ESP_<Last 3 digits of MAC Address>**.
3. Browse to the device web interface and REST API by accessing http://192.168.4.1 with a web browser.
4. Select **IoT Hub Configuration**.
   * Input the **Azure IoT Hub URL**.
     * This is the **hostname** that you either noted from the **Azure Portal** deployment or that was displayed as part of the **Azure PowerShell** or **Azure CLI** deployment. 
   * Input the **IoT device name**.
     * This is the **device id** that you either noted from the **Azure Portal** deployment or that was displayed as part of the **Azure PowerShell** or **Azure CLI** deployment.    
   * Input the **IoT device secret**.
     * This is the **primary key** that you either noted from the **Azure Portal** deployment or that was displayed as part of the **Azure PowerShell** or **Azure CLI** deployment.    
5. Select **WiFi**
   * Configure the **SSID** and **Password** that the device will connect to.
6. Select **User JSON** 
   * Configure your desired message that should be sent to the Azure IoT Hub when pressed. For example: {"button1":"pressed"}.
7. Select **Shutdown**
   * This will save the configuration to the device.
   
# Step 4: Verify communication between teXXmo Azure IoT button and Azure IoT Hub.

1. Launch <a href="https://shell.azure.com">Azure Cloud Shell</a>.
2. Install the Azure CLI IoT Extension
   * **az extension add --name azure-cli-iot-ext**
3. Monitor device telemetry & messages sent to an Azure IoT hub.
   * **az iot hub monitor-events --hub-name** <hub_name>
4. Press the teXXmo Azure IoT button and confirm the message was received by the Azure IoT hub.

