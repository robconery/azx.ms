---
title: Simple PostgreSQL Setup
description: Setup PostgreSQL with user name and password as well as firewall access.
script:
keywords:
author: Rob Conery
---

#!/bin/bash
#Change the settings below as you need
LOCATION="West US"
RG="change_me"
DATABASE="test"


#Recommend to keep these random, but if you need to change go for it
USER=admin_$RANDOM #set this to whatever you like but it's not something that should be easy
PASS=$(uuidgen) #Again - whatever you like but keep it safe! Better to make it random
DATABASE=DB$RANDOM #No need to have your prod database named a particular name, unless you want to.
SERVERNAME=$RANDOM #this has to be unique across azure


{% include resource_group_create.sh %}

echo "Spinning up PostgreSQL $SERVERNAME in group $RG Admin is $USER"

# Create the PostgreSQL service
az postgres server create --resource-group $RG \
    --name $SERVERNAME  --location $LOCATION --admin-user $USER \
    --admin-password $PASS --sku-name $SKU --version 10.0

echo "Guessing your external IP address from ipinfo.io"
IP=$(curl -s ipinfo.io/ip)
echo "Your IP is $IP"

# Open up the firewall so we can access
echo "Popping a hole in firewall for IP address $IP (that's you)"
az postgres server firewall-rule create --resource-group $RG \
        --server $SERVERNAME --name AllowMyIP \
        --start-ip-address $IP --end-ip-address $IP

echo "Creating database..."
psql "postgres://$USER%40$SERVERNAME:$PASS@$SERVERNAME.postgres.database.azure.com/postgres" -c "CREATE DATABASE $DATABASE;"

echo "You can now connect to the server by entering this command: "
echo "psql postgres://$USER%40$SERVERNAME:$PASS@$SERVERNAME.postgres.database.azure.com/$DATABASE"