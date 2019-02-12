---
title: Deploying PostgreSQL
description: Pushing Azure Database for PostgreSQL to Azure.
group: Database
slug: postgres
---

#!/bin/bash

#Recommend to keep these random, but if you need to change go for it
USER=admin_$RANDOM #set this to whatever you like but it's not something that should be easy
PASS=$(uuidgen) #Again - whatever you like but keep it safe! Better to make it random
DATABASE=${DATABASE:-DB$RANDOM} #Will get set to a random value unless already set.
SERVERNAME=$RANDOM #this has to be unique across azure
#RG = "Your Resource Group - set this in your .env file or here"

echo "Spinning up PostgreSQL $SERVERNAME in group $RG Admin is $USER"

# Create the PostgreSQL service
az postgres server create --resource-group $RG \
    --name $SERVERNAME --admin-user $USER \
    --admin-password $PASS --sku-name $SKU --version 10.0

echo "Guessing your external IP address from ipinfo.io"
IP=$(curl -s ipinfo.io/ip)
echo "Your IP is $IP"

# Open up the firewall so we can access
echo "Popping a hole in firewall for IP address $IP (that's you)"
az postgres server firewall-rule create --resource-group $RG \
        --server $SERVERNAME --name AllowMyIP \
        --start-ip-address $IP --end-ip-address $IP

PG_URL = "postgres://$USER%40$SERVERNAME:$PASS@$SERVERNAME.postgres.database.azure.com"
echo "Creating database..."
psql "$PG_URL/postgres" -c "CREATE DATABASE $DATABASE;"

AZURE_DATABASE_URL="$PG_URL/$DATABASE"
echo "$AZURE_DATABASE_URL" >> .env
echo "Azure database URL added to your .env file. You can now connect to the server by entering this command: "
echo "psql $AZURE_DATABASE_URL"