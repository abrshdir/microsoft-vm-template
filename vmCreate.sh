#!/bin/bash
# Ask for the wizard info
red=`tput setaf 1`
green=`tput setaf 2`
blue=`tput setaf 4`
reset=`tput sgr0`
# echo "${red}red text ${green}green text${reset}"

echo 'I will make easy setup for your azure virtual machine deployments. Give me some info' 
echo "${blue}info: resource group holds your resources. Give it a name.${reset}"
read -p "${green}Resource Group: ${reset}" resourceGroup
echo 'choose and type one location from below. Which one is near you?'
echo "${blue}westus2 southcentralus centralus eastus westeurope southeastasia japaneast brazilsouth australiasoutheast centralindia${reset}"
read -p "${green}Location: ${reset}" Location
# read -sp 'Password: ' passvar
# read -sp 'User name: ' passvar
az group create --name $resourceGroup --location $Location

echo
echo "${blue}Thank you I have created your resource group named $resourceGroup.${reset}"
echo
echo "Now please enter a username for your vm"
read -p "${green}Username: ${reset}" Username
# echo "Please enter password for $Username"
# read -sp "${green}Password: ${reset}" PASSWORD
PASSWORD="$(openssl rand -base64 32)"
echo "created random password ${green} $PASSWORD ${reset}"
DNS_LABEL_PREFIX=mydeployment-$RANDOM
echo "I created a random dns label prefix called ${green} $DNS_LABEL_PREFIX ${reset}"
echo "${blue} Next I will validate and run a template on your local filesystem.${reset}"
az deployment group validate \
  --resource-group $resourceGroup \
  --template-uri "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-vm-simple-windows/azuredeploy.json" \
  --parameters adminUsername=$Username \
  --parameters adminPassword=$PASSWORD \
  --parameters dnsLabelPrefix=$DNS_LABEL_PREFIX

echo
echo "${blue} Validated. Now I will create a deployment. This might take a few minutes ${reset}"
az deployment group create \
  --name MyDeployment \
  --resource-group $resourceGroup \
  --template-uri "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-vm-simple-windows/azuredeploy.json" \
  --parameters adminUsername=$Username \
  --parameters adminPassword=$PASSWORD \
  --parameters dnsLabelPrefix=$DNS_LABEL_PREFIX

echo
echo "Summary"
az vm list \
  --resource-group $resourceGroup \
  --output table

echo "${blue}The template names the VM "simple-vm". Here you see that this VM exists in your resource group.${reset}"