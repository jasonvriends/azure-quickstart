# 6-bonus/teXXmo
- - -

# Table of Contents

-   [Introduction](#introduction)
-   [Step 1: Prerequisites](#step-1-prerequisites)
-   [Step 2: Provision Azure Services](#step-2-provision-azure-services)
 -   [Azure Portal](#azure-portal)
 -   [Azure PowerShell](#azure-powershell)
 -   [Azure CLI](#azure-cli)
-   [Step 3: Configure teXXmo Azure IoT Button](#step-3-configure-teXXmo-azure-iot-button)


# Introduction

The teXXmo IoT Button enables direct customer or workforce feedback into Azure. By a click of a button, you can send predefined messages to your cloud. Send information, such as presence of people, material or purchasing demand and react on this from Azure. The IoT button offers instant feedback and integrates directly in all your Azure analysis and response tools.

At a conceptual level, enabling the teXXmo button involves the following steps:

1. Provisioning and registering the device in an Azure IoT Hub.
2. Writing an Azure Function to receive messages from the button when clicked
3. Configuring the button to communicate to the Azure IoT Hub.
4. Binding the button to the Azure Function

# Step 1: Prerequisites

To deploy this quickstart template, you need the following:
* **Azure subscription**. 
  * If you don't have one yet, you can <a href="https://azure.microsoft.com/pricing/member-offers/msdn-benefits-details/">activate your MSDN subscriber benefits</a> or <a href="https://azure.microsoft.com/free">sign up for a free account</a>.
* **teXXmo Azure IoT button**
  * If you don't have one yet, you can purchase one via <a href="https://www.texxmo-shop.de/epages/82740787.sf/en_US/?ObjectPath=/Shops/82740787/Products/TX-IOT-20W-GR">teXXmo</a>.

# Provision Azure Services

## Azure Portal

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjasonvriends%2Fazure-quickstart%2Fmaster%2F2-virtual-network%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fjasonvriends%2Fazure-quickstart%2Fmaster%2F2-virtual-network%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a><br/>

## Azure PowerShell

```powershell

```

## Azure CLI

```shell


```

# Step 2: Configure teXXmo Azure IoT button

1. Hold power button for 5 sec. LED changes from Green Flash to Yellow, then Red flash. When LED flashes in RED, the device is in AP Mode.

1. From any desktop machine, connect to the device via WiFi using the SSID : ESP_<Last 3 digits of MAC Address>.

1. In Visual Studio Code, press **F1** or **Ctrl + Shift + P** in Visual Studio Code and select **Azure IoT Device Workbench: Configure Device Settings...**
![ConfigDevice](media/iot-button-get-started/iot_button_config_device.JPG)
    For teXXmo IoT button, the following commands are provided:

    | Command | Description |
    | --- | --- |
    | `Config WiFi of IoT button`  | Set WiFi SSID and password. |
    | `Config connection of IoT Hub Device` | Set the device connection string into IoT button. |
    | `Config time server of IoT button` | Config time server of IoT button. |
    | `Config JSON data to append to message`  | Append JSON data from `Device\userdata.json` into the message.  |
    | `Shutdown IoT button` | Shutdown IoT button. |

    Please click `Config WiFi of IoT button` and `Config connection of IoT Hub Device` and follow the guide to set the WiFi and device connection string of teXXmo IoT button and then click `Shutdown IoT button`

# Provision Azure Services

You will use the Azure IoT Starter Kit companion App or CLI to configure your device as an Azure IoT device. The App or CLI will connect your device to a wireless network, provision Azure resources for you, and bind the button to an Azure Function.

For step-by-step instructions for the Azure IoT Starter Kit companion app, see https://github.com/Azure-Samples/azure-iot-starterkit-companionapp

For step-by-step instruction for the Azure IoT Starter Kit companion CLI, see https://github.com/Azure-Samples/azure-iot-starterkit-cli

## Writing an Azure Function

For step by step instructions, see https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-first-azure-function

## Additional Resources

teXXmo button product page - https://catalog.azureiotsuite.com/details?title=teXXmo-IoT-Button&source=home-page&kit=teXXmo-IoT-Button-Starter-Kit

teXXmo button project code - https://github.com/teXXmo/TheButtonProject

## temp

https://azure.microsoft.com/en-us/pricing/details/iot-hub/

https://github.com/Microsoft/vscode-iot-workbench/blob/master/docs/iot-button/teXXmo_IoT_button_get_started.md#step-4-configure-the-setting-on-iot-button
