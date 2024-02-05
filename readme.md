# Deploy Azure Bastion via Terraform

## What is Bastion?

Azure service that lets you securely connect to virtual machines via private IP address without having to expose the VM to the internet

![bastion-architecture](https://learn.microsoft.com/en-us/azure/bastion/media/bastion-overview/architecture.png)

Source: https://learn.microsoft.com/en-us/azure/bastion/bastion-overview

## Project Components

### Resource Group: Logical container for all your resources

This needs to be deployed first so that terraform can register other resources unto it

    terraform apply -target azurerm_resource_group.azure-bastion-rg

### Private Network and Subnets:
One private network, two subnets. One subnet for your VM. The other subnet for Azure Bastion host

### Network Security Groups:
Two NSGs - one for your VM subnet, the other for your Azure Bastion subnet

For Bastion NSG, follow the bastion nsg guide: https://learn.microsoft.com/en-us/azure/bastion/bastion-nsg

The configuration should look something like this:

![bastion-inbound](./pics/bastion%20inbound.png)

![bastion-outbound](./pics/bastion%20outbound.png)

For VM NSG, allow RDP/SSH inbound from Bastion host:

![vm-inbound](./pics/vm%20inbound.png)

### Bastion Host and VM:
These two resources can be deployed simultaneously. Bastion host will need a public IP. VM will need a way for Bastion host to authenticate into. In my case, I used username and password option.

    terraform apply --auto-approve

## Using Bastion

After all resources have deployed successfully, go into your Azure portal, click on your VM, choose Bastion option under Connect, enter authentication, and connect to the VM

![using-bastion](./pics/using%20bastion.png)

A new browser with open with the terminal to your VM

![success-bastion](./pics/success%20bastion.png)

## Connect to your VM from your computer

Other than using portal to access your Bastion host's session into your VM, you can directly ssh into your VM

Here's a good place to read about how it works:
https://learn.microsoft.com/en-us/azure/bastion/connect-vm-native-client-windows#connect-to-a-vm---tunnel-command

    az network bastion tunnel --name "bastion-host" --resource-group "azure-bastion-rg" --target-resource-id "your-target-id" --resource-port "22" --port "6969"

Then ssh into your vm

    ssh anguyen@127.0.0.1 -p 6969

Note: The IP is literally 127.0.0.1, do not use your private or public ip

![ssh-success](./pics/ssh%20success.png)

# DONE!