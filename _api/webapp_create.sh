---
title:
description:
---
#The name needs to be unique across Azure and in slug form as it will be part of the host name
APPNAME="your-app-name"
az webapp create --resource-group $RG --plan $PLAN --name $APPNAME

#set the runtime. You can see the runtimes by executing az webapp list-runtimes --linux
#or choose from below:
# RUBY|2.3
# NODE|lts
# NODE|4.4
# NODE|4.5
# NODE|4.8
# NODE|6.2
# NODE|6.6
# NODE|6.9
# NODE|6.10
# NODE|6.11
# NODE|8.0
# NODE|8.1
# NODE|8.2
# NODE|8.8
# NODE|8.9
# NODE|8.11
# NODE|8.12
# NODE|9.4
# NODE|10.1
# NODE|10.10
# PHP|5.6
# PHP|7.0
# PHP|7.2
# DOTNETCORE|1.0
# DOTNETCORE|1.1
# DOTNETCORE|2.0
# DOTNETCORE|2.1
# TOMCAT|8.5-jre8
# TOMCAT|9.0-jre8
# JAVA|8-jre8
# WILDFLY|14-jre8
# PYTHON|3.7
# PYTHON|3.6
# PYTHON|2.7
RUNTIME="PYTHON|3.7"
az webapp config appsettings set --resource-group $RG --name $APPNAME --runtime $RUNTIME

echo "You can now browse your site at http://$APPNAME.azurewebsites.net"

