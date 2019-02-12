---
title: Logging for Azure Web Apps
description: "Setup logging for Azure Web Apps and stick a shortcut in .env"
slug: logs
---
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
source .env
