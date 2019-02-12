---
title: Create a resource group
description: Creates a resource group with the given name
---
#list locations if needed
#az appservice list-locations --sku FREE

#Or just choose one from below
# Central US
# North Europe
# West Europe
# Southeast Asia
# East Asia
# West US
# East US
# Japan West
# Japan East
# East US 2
# North Central US
# South Central US
# Brazil South
# Australia East
# Australia Southeast
# Central India
# West India
# South India
# Canada Central
# Canada East
# West Central US
# West US 2
# UK West
# UK South
# Korea South
# Korea Central
# France South
# France Central

#Reset this as needed
LOCATION="West US"
RG="Test Resource Group"
az group create --name $RG --location $LOCATION