---
title: Deploying MySQL
description: Pushing Azure Database for MySQL to Azure.
group: Database
tags:
  - mysql
  - data
---
RG={$RG:-"AZX-$RANDOM"}
LOCATION="Central US"

#Recommend to keep these random, but if you need to change go for it
USER=admin_$RANDOM #set this to whatever you like but it's not something that should be easy
PASS=$(uuidgen) #Again - whatever you like but keep it safe! Better to make it random
SERVERNAME=server$RANDOM #this has to be unique across azure

#accepted values for the service plan: B1, B2, B3, D1, F1, FREE, P1, P1V2, P2, P2V2, P3, P3V2, PC2, PC3, PC4, S1, S2, S3, SHARED
#B2 is good for getting started - read up on the different levels and their associated cost.
PLAN=B2

#Kick it off by creating the Resource Group
echo "Creating resource group"
az group create -n $RG -l $LOCATION

#The sku-name parameter value follows the convention {pricing tier}_{compute generation}_{vCores} as in the examples below:
# --sku-name B_Gen5_2 maps to Basic, Gen 5, and 2 vCores.
# --sku-name GP_Gen5_32 maps to General Purpose, Gen 5, and 32 vCores.
# --sku-name MO_Gen5_2 maps to Memory Optimized, Gen 5, and 2 vCores.
#WARNING - this might error out if your region doesn't support the SKU you set here. If it does, execute:
#az group delete -g [resource group] to drop everything and try again
#The SKU below is reasonable for a WP blog, but if you're going to host something more, consider more RAM/Cores
SKU=B_Gen5_1 #this is the cheapest one

echo "Spinning up MySQL $SERVERNAME in group $RG Admin is $USER"

# Create the MySQL service
az mysql server create --resource-group $RG \
    --name $SERVERNAME --admin-user $USER \
    --admin-password $PASS --sku-name $SKU \
    --ssl-enforcement Disabled \
    --location $LOCATION

echo "Guessing your external IP address from ipinfo.io"
IP=$(curl -s ipinfo.io/ip)
echo "Your IP is $IP"

# Open up the firewall so we can access
echo "Popping a hole in firewall for IP address $IP (that's you)"
az mysql server firewall-rule create --resource-group $RG \
        --server $SERVERNAME --name AllowMyIP \
        --start-ip-address $IP --end-ip-address $IP

# Open up the firewall so wordpress can access - this is internal IP only
echo "Popping a hole in firewall for IP address $IP (that's you)"
az mysql server firewall-rule create --resource-group $RG \
        --server $SERVERNAME --name AllowAzureIP \
        --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0

echo "Setting ENV variables locally"
MYSQL_SERVER=$SERVERNAME.mysql.database.azure.com
MYSQL_USER=$USER
MYSQL_PASSWORD=$PASS
MYSQL_PORT=3306

echo "MYSQL_SERVER=$MYSQL_SERVER\nMYSQL_USER=$USER\nMYSQL_PASSWORD=$PASS\nMYSQL_PORT=3306" >> .env
echo "MySQL ENV vars added to .env. You can printenv to see them, or cat .env."
echo "To create a database, use mysql -u $USER@$SERVERNAME -p $PASS -h $SERVERNAME.mysql.database.azure.com -p 3306 -D mysql -e 'create database $DATABASE;'"
echo "Adding connector shortcut to .env"
echo "alias db_connect=\"mysql -u $USER@$SERVERNAME -p $PASS -h $SERVERNAME.mysql.database.azure.com -p 3306 -D mysql\"" >> .env
source .env
db_connect