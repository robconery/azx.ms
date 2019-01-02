---
title: WebApp With PostgreSQL Setup
description: Create a web application backed by PostgreSQL.
script:
keywords:
author: Rob Conery
---

#create the postgres DB
{% include postgres_create.sh %}

#create the webapp
{% include webapp_create.sh %}

{% include webapp_git_deployment.sh %}

echo "Attaching database"
az webapp config appsettings set -g $RG -n $APPNAME --settings DATABASE_URL=$AZURE_DATABASE_URL

{% include webapp_logs.sh %}