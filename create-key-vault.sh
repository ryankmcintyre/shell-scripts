#!/bin/bash

usage()
{
	printf "usage: create-key-vault [[[-g resource group name ] [-n name ] [-efd] [-l location ]] | [-h]]\n"
}

resourcegroup=
kvname=
efd=
location=

while [ "$1" != "" ]; do
	case $1 in
		-g | --resource-group )			shift
							resourcegroup=$1
							;;
		-n | --name )				shift
							kvname=$1
							;;
		-efd | --enabled-for-deployment ) 	efd="yes"
							;;
		-l | --location )			shift
							location=$1
							;;
		-h | --help )				usage
							exit
							;;
		* )					usage
							exit 1
	esac
	shift
done

az group create -n "$resourcegroup" -l "$location" > /dev/null

# Create the vault, checking for -efd
if [ -z $efd ]
then
	vault_output=`az keyvault create -n "$kvname" -g "$resourcegroup" -l "$location" --output json | jq '. | {vaultUri: .properties.vaultUri, enabledForDeployment: .properties.enabledForDeployment}'`
else
	vault_output=`az keyvault create -n "$kvname" -g "$resourcegroup" -l "$location" --enabled-for-deployment --output json | jq '. | {vaultUri: .properties.vaultUri, enabledForDeployment: .properties.enabledForDeployment}'`
fi

printf "Key Vault created with properties:\n $vault_output\n"
