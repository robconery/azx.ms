---
title: Web App Git Deployment
description: Sets up Git deployment for a webapp
---

#setup deployment
DEPLOY_USER=$APPNAME_$RANDOM
DEPLOY_PASSWORD=$(uuidgen)
az webapp deployment user set --user-name $DEPLOY_USER --password $DEPLOY_PASSWORD

echo "DEPLOY_USER=$DEPLOY_USER" >>.env
echo "DEPLOY_PASSWORD=$DEPLOY_PASSWORD" >>.env

echo "Setting deployment to local git, meaning you can push from your local repo"
az webapp deployment source config-local-git -g $RG -n $APPNAME

echo "Assigning git remote azure"        
git remote add azure https://$DEPLOY_USER@$APPNAME.scm.azurewebsites.net/$APPNAME.git
