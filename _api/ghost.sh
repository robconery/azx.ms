---
title: Set Up Ghost on Azure
slug: ghost
description: Create a super scalable Ghost blog on Azure using Web Apps for Containers and hosted MySQL
keywords: "ghost blog mysql"
author: Rob Conery
---
#!/bin/bash

RG="azxg"
APPNAME=$RG-ghost
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

#The SKU below is good for a Ghost blog, but if you're going to host something more, consider more RAM/Cores
#The nice thing about Ghost is Node - it's quite performant on lesser hardware
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
echo "Popping a hole in firewall for Azure services"
az mysql server firewall-rule create --resource-group $RG \
        --server $SERVERNAME --name AllowAzureIP \
        --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0

echo "Creating Ghost Database"
mysql --host=$SERVERNAME.mysql.database.azure.com \
      --user=$USER@$SERVERNAME --password=$PASS \
      -e 'create database ghost;' mysql

echo "Setting ENV variables locally"
MYSQL_SERVER=$SERVERNAME.mysql.database.azure.com
MYSQL_USER=$USER@$SERVERNAME
MYSQL_PASSWORD=$PASS
MYSQL_PORT=3306
MYSQL_DB=$DATABASE
echo "MYSQL_SERVER=$MYSQL_SERVER\nMYSQL_USER=$USER\nMYSQL_PASSWORD=$PASS\nMYSQL_PORT=3306" >> .env
echo "alias prod=\"mysql --host=$SERVERNAME.mysql.database.azure.com --user=$USER@$SERVERNAME --password=$PASS\" ghost" >> .env
echo "MySQL ENV vars added to .env. You can printenv to see them, or cat .env."
echo "To access your MySQL Instance just run `prod` as an alias. You can rename this in .env."


echo "Creating AppService Plan"
az appservice plan create --name $RG \
                          --resource-group $RG \
                          --sku $PLAN \
                          --is-linux

echo "Creating Web app"
az webapp create --resource-group $RG \
                  --plan $RG --name $APPNAME \
                  --deployment-container-image-name ghost

echo "Adding app settings"
#add the settings for the new MYSQL bits
az webapp config appsettings set --name $APPNAME \
                                 --resource-group $RG \
                                 --settings \
                                 database__client=mysql \
                                 database__connection__database=ghost \
                                 database__connection__host=$MYSQL_SERVER \
                                 database__connection__user=$MYSQL_USER \
                                 database__connection__password=$MYSQL_PASSWORD \
                                 WEBSITES_PORT=2368 \
                                 WEBSITES_ENABLE_APP_SERVICE_STORAGE=true
#turn on logging
echo "Setting up logging"
#setup logging and monitoring
az webapp log config --application-logging true \
                    --detailed-error-messages true \
                    --web-server-logging filesystem \
                    --level information \
                    --name $APPNAME \
                    --resource-group $RG
                    
echo "Adding logs alias to .env. Invoking this will allow you to see the application logs realtime-ish."

#set an alias for convenience - add to .env
alias logs="az webapp log tail --name $APPNAME --resource-group $RG"
echo "alias logs='az webapp log tail -n $APPNAME -g $RG'" >> .env

echo "Opening site admin and viewing logs. This might 502 initially - just give it a minute to start."
echo "When it does start, head to https://$APPNAME.azurewebsites.net/ghost to set it up."
open https://$APPNAME.azurewebsites.net/
source .env
logs