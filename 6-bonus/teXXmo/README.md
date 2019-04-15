# 6-bonus/teXXmo

The teXXmo IoT Button enables direct customer or workforce feedback into Azure. By a click of a button, you can send predefined messages to your cloud. Send information, such as presence of people, material or purchasing demand and react on this from Azure. The IoT button offers instant feedback and integrates directly in all your Azure analysis and response tools.

At a conceptual level, enabling the teXXmo button involves the following steps:

1. Provisioning and registering the device in an Azure IoT Hub.
2. Writing an Azure Function to receive messages from the button when clicked.
3. Configuring the button to communicate to the Azure IoT Hub.
4. Binding the button to the Azure Function.

# Table of Contents

-   [Step 1: Prerequisites](#step-1-prerequisites)
-   [Step 2: Provision Azure Services](#step-2-provision-azure-services)
    -   [Azure Portal](#azure-portal)
    -   [Azure PowerShell](#azure-powershell)
    -   [Azure CLI](#azure-cli)
-   [Step 3: Configure teXXmo Azure IoT Button](#step-3-configure-teXXmo-azure-iot-button)

# Step 1: Prerequisites

To deploy this quickstart template, you need the following:
* **Azure subscription**. 
  * If you don't have one yet, you can <a href="https://azure.microsoft.com/pricing/member-offers/msdn-benefits-details/">activate your MSDN subscriber benefits</a> or <a href="https://azure.microsoft.com/free">sign up for a free account</a>.
* **teXXmo Azure IoT button**
  * If you don't have one yet, you can purchase one via <a href="https://www.texxmo-shop.de/epages/82740787.sf/en_US/?ObjectPath=/Shops/82740787/Products/TX-IOT-20W-GR">teXXmo</a>.

# Step 2: Provision Azure Services

## Azure Portal

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjasonvriends%2Fazure-quickstart%2Fmaster%2F6-bonus/teXXmo/%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fjasonvriends%2Fazure-quickstart%2Fmaster%2F6-bonus/teXXmo/%2Fazuredeploy.json" target="_blank">
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
   * Input the **IoT device name**.
   * Input the **IoT device secret**.
5. Select **WiFi**
   * Configure the **SSID** and **Password** that the device will connect to.
6. Select **User JSON** 
   * Configure your desired message that should be sent to the Azure IoT Hub when pressed. For example: {"message":"on"}.
7. Select **Shutdown**
   * This will save the configuration to the device.
