# azure-quickstart

This public repository contains templates to assist with your Public Cloud Adoption with Microsoft Azure.

## <a href="https://github.com/jasonvriends/azure-quickstart/tree/master/1-cloudshell">1-cloudshell</a>

<a href="https://docs.microsoft.com/en-us/azure/cloud-shell/overview">Azure Cloud Shell</a> is an interactive, browser-accessible shell for managing Azure resources. It provides the flexibility of choosing the shell experience that best suits the way you work. Linux users can opt for a Bash experience, while Windows users can opt for PowerShell.

## <a href="https://github.com/jasonvriends/azure-quickstart/tree/master/2-virtual-network">2-virtual-network</a>

An Azure Virtual Network (VNet) is a representation of your own network in the cloud. It is a logical isolation of the Azure cloud dedicated to your subscription. You can use VNets to provision and manage virtual private networks (VPNs) in Azure and, optionally, link the VNets with other VNets in Azure, or with your on-premises IT infrastructure to create hybrid or cross-premises solutions. Each VNet you create has its own CIDR block, and can be linked to other VNets and on-premises networks as long as the CIDR blocks do not overlap. You also have control of DNS server settings for VNets, and segmentation of the VNet into subnets.

## <a href="https://github.com/jasonvriends/azure-quickstart/tree/master/3-virtual-machines">3-virtual-machines</a>

Azure Virtual Machines provides on-demand, high-scale, secure, virtualized infrastructure using your desired operating system choice.

## <a href="https://github.com/jasonvriends/azure-quickstart/tree/master/4-apache-guacamole">4-apache-guacamole</a>

Apache Guacamole is a clientless remote desktop gateway. It supports standard protocols like SSC, Telnet, VNC, and RDP. It is open source and requires no plugins or client software installed. Thanks to HTML5, once Guacamole is installed on a server, all you need to access your remote desktops and servers is a web browser. Since Apache Guacamole is accessed via your web browser, you can install Guacamole on a Cloud Service Provider and access Apache Guacamole through your corporate proxy server. This can enable you to remotely access your Cloud hosted virtual machines without having to configure Firewall Rules or establish a Virtual Private Network.

## <a href="https://github.com/jasonvriends/azure-quickstart/tree/master/5-scaffold">5-scaffold</a>

When creating a building, scaffolding is used to create the basis of a structure. The scaffold guides the general outline and provides anchor points for more permanent systems to be mounted. An Azure scaffold is the same: a set of flexible controls and Azure capabilities that provide structure to the environment, and anchors for services built on the public cloud. It provides the builders (IT and business groups) a foundation to create and attach new services keeping speed of delivery in mind.

## <a href="https://github.com/jasonvriends/azure-quickstart/tree/master/6-bonus">6-bonus</a>

Now that you have your Azure Innovation Zone, its time to have some fun with it!

## Are you ready to establish an Azure Innovation Zone?

While you could deploy each of the above teampltes individually, below you find a 1-click deployment to quickly establish an Azure Innovation Zone.

### Deployment Options

#### Azure CLI

* Launch <a href="https://shell.azure.com">Azure Cloud Shell</a>.
  * If this is your first time launching Azure Cloud Shell, visit <a href="https://github.com/jasonvriends/azure-quickstart/tree/master/1-cloudshell.">1-cloudshell</a>.
* From the dropdown list, select **PowerShell** as your shell.
* Execute the **code block** below, and answer the questions when prompted.

```bash
git clone https://github.com/jasonvriends/azure-quickstart.git
./azure-quickstart/create-innovation-zone.ps1
```
