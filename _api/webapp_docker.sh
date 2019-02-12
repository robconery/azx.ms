---
title: Web App for Containers
description: Create a Web App using a container
slug: webapp-container
required:
  - image
  - plan
---

echo "Creating AppService Plan"
az appservice plan create --name $RG \
                          --resource-group $RG \
                          --sku $PLAN

echo "Creating Web app"
az webapp create --resource-group $RG \
                  --plan $PLAN --name $APPNAME \
                  --deployment-container-image-name $IMAGE
