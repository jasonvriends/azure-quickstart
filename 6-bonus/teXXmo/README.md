# 6-bonus/teXXmo

The teXXmo IoT Button enables direct customer or workforce feedback into Azure. By a click of a button, you can send predefined messages to your cloud. Send information, such as presence of people, material or purchasing demand and react on this from Azure. The IoT button offers instant feedback and integrates directly in all your Azure analysis and response tools.

## Prerequisites

To deploy this quickstart template, you need the following:
* **Azure subscription**. 
  * If you don't have one yet, you can <a href="https://azure.microsoft.com/pricing/member-offers/msdn-benefits-details/">activate your MSDN subscriber benefits</a> or <a href="https://azure.microsoft.com/free">sign up for a free account</a>.
* **teXXmo Azure IoT button**
  * If you don't have one yet, you can purchase one via <a href="https://www.texxmo-shop.de/epages/82740787.sf/en_US/?ObjectPath=/Shops/82740787/Products/TX-IOT-20W-GR">teXXmo</a>.

## Concepts

At a conceptual level, enabling the teXXmo button involves the following steps:

1. Configuring the button
2. Provisioning and registering the device in an Azure IoT Hub. When you register a device, you will get a connection string for it.
3. Writing an Azure Function to receive messages from the button when clicked
4. Binding the button to the Azure Function

## Configuring the teXXmo button

You will use the Azure IoT Starter Kit companion App or CLI to configure your device as an Azure IoT device. The App or CLI will connect your device to a wireless network, provision Azure resources for you, and bind the button to an Azure Function.

For step-by-step instructions for the Azure IoT Starter Kit companion app, see https://github.com/Azure-Samples/azure-iot-starterkit-companionapp

For step-by-step instruction for the Azure IoT Starter Kit companion CLI, see https://github.com/Azure-Samples/azure-iot-starterkit-cli

## Writing an Azure Function

For step by step instructions, see https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-first-azure-function

## Additional Resources

teXXmo button product page - https://catalog.azureiotsuite.com/details?title=teXXmo-IoT-Button&source=home-page&kit=teXXmo-IoT-Button-Starter-Kit

teXXmo button project code - https://github.com/teXXmo/TheButtonProject
