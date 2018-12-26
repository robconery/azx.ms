---
title: Deploying PostgreSQL
description: Pushing Azure Database for PostgreSQL to Azure.
group: Database
tags:
  - postgres
  - data
---

#!/bin/bash

#Change the settings below as you need

USER=admin_$RANDOM #set this to whatever you like but it's not something that should be easy
PASS=$(uuidgen) #Again - whatever you like but keep it safe! Better to make it random
LOCATION=westus
SERVERNAME=$RANDOM #this has to be unique across azure

#CHANGE THESE
RG="change_me"
DATABASE="test"

echo "Guessing your external IP address from ipinfo.io"
IP=$(curl -s ipinfo.io/ip)
echo "Your IP is $IP"

az group create -n $RG -l $LOCATION

#The sku-name parameter value follows the convention {pricing tier}_{compute generation}_{vCores} as in the examples below:
# --sku-name B_Gen4_2 maps to Basic, Gen 4, and 2 vCores.
# --sku-name GP_Gen5_32 maps to General Purpose, Gen 5, and 32 vCores.
# --sku-name MO_Gen5_2 maps to Memory Optimized, Gen 5, and 2 vCores.
SKU=B_Gen4_1 #this is the cheapest one


echo "Spinning up PostgreSQL $SERVERNAME in group $RG Admin is $USER"

# Create the PostgreSQL service
az postgres server create --resource-group $RG \
    --name $SERVERNAME  --location $LOCATION --admin-user $USER \
    --admin-password $PASS --sku-name $SKU --version 10.0

# Open up the firewall so we can access
echo "Popping a hole in firewall for IP address $IP (that's you)"
az postgres server firewall-rule create --resource-group $RG \
        --server $SERVERNAME --name AllowMyIP \
        --start-ip-address $IP --end-ip-address $IP

echo "Your connection string is postgres://$USER@$SERVERNAME:$PASS@$SERVERNAME.postgres.database.azure.com/postgres"
echo "Creating the Tailwind database..."
psql "postgres://$USER%40$SERVERNAME:$PASS@$SERVERNAME.postgres.database.azure.com/postgres" -c "CREATE DATABASE $DATABASE;"

echo "You can now connect to the server by entering this command: "
echo "psql postgres://$USER%40$SERVERNAME:$PASS@$SERVERNAME.postgres.database.azure.com/$DATABASE"