---
title: Create App Service Plan
description: Create an appservice plan in a given resource using the free sku
---
#The sku should be one of:
#F1(Free), D1(Shared), B1(Basic Small), B2(Basic Medium), B3(Basic Large), 
#S1(Standard Small), P1(Premium Small), P1V2(Premium V2 Small), 
#PC2 (Premium Container Small), PC3 (Premium Container Medium), 
#PC4 (Premium Container Large).

#accepted values: B1, B2, B3, D1, F1, FREE, P1, P1V2, P2, P2V2, P3, P3V2, PC2, PC3, PC4, S1, S2, S3, SHARED
PLAN=FREE

az appservice plan create --name $PLAN --resource-group $RG --sku FREE