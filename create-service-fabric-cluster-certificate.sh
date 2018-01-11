#!/bin/bash

usage()
{
	printf "usage: create-service-fabric-cluster-certificate.sh [[[-kvn key vault name ] [-n secret name ] [-f policy file ]] | [-h]]\n"
}

key_vault_name=
key_vault_secret_name=
policy_file=mypolicy.json

while [ "$1" != "" ]; do
	case $1 in
		-kvn | --vault-name )			shift
							key_vault_name=$1
							;;
		-n | --name )				shift
							key_vault_secret_name=$1
							;;
		-f | --policy-file )			shift
							policy_file=$1
							;;
		-h | --help )				usage
							exit
							;;
		* )					usage
							exit 1
	esac
	shift
done

if [ ! -f $policy_file ]; then
	echo "File doesn't exist: $policy_file"
	exit 1
fi

az keyvault certificate create --vault-name $key_vault_name -n $key_vault_secret_name -p @$policy_file > /dev/null

secret_url=`az keyvault secret show -n $key_vault_secret_name --vault-name $key_vault_name | jq '. | .id'`
thumbprint=`az keyvault certificate show -n $key_vault_secret_name --vault-name $key_vault_name | jq '. | .x509ThumbprintHex'`
key_vault_id=`az keyvault show -n $key_vault_name | jq '. | .id'`

printf "Certificate created\n Source Vault Resource Id: $key_vault_id\n Certificate URL: $secret_url\n Certificate Thumbprint: $thumbprint\n\n"

printf "To download the certificate as .pfx run the following:\naz keyvault secret download --vault-name $key_vault_name -n $key_vault_secret_name -e base64 -f $key_vault_secret_name.pfx\n\n"

printf "For Linux, convert to .pem (password here is blank, use a password in production):\nopenssl pkcs12 -in $key_vault_secret_name.pfx -out output.pem -nodes\n\n"

printf "To import the pfx in Windows using PowerShell:\nImport-PfxCertificate .\\$key_vault_secret_name.pfx -CertStoreLocation Cert:\\CurrentUser\\My\\"
