---
title: Create a Web Application
description: Create a web application with specific runtime. You can list the runtimes using 'azx runtimes'
slug: webapp
required:
 - runtime
 - plan
---

RUNTIME="NODE|10.10"
PLAN=RG #default to the resource group

echo "Creating AppService Plan"
az appservice plan create --name $RG \
                          --resource-group $RG \
                          --sku $PLAN

#The name needs to be unique across Azure and in slug form as it will be part of the host name
az webapp create --resource-group $RG \
                 --plan $PLAN \
                 --name $APPNAME

RUNTIME="{RUNTIME}"
az webapp config appsettings set --resource-group $RG \
                                 --name $APPNAME 
                                 --runtime $RUNTIME

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
echo "alias logs='az webapp log tail -n $APPNAME -g $RG'" >> .env

echo "You can now browse your site at http://$APPNAME.azurewebsites.net"
open http://$APPNAME.azurewebsites.net

