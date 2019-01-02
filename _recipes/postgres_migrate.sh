---
title: Migrate PostgreSQL to Azure
description: Move one PostgreSQL database completely to Azure.
script:
keywords: postgres migrate
author: Rob Conery
---

#SET THIS
FROMDB="postgres://localhost/bigmachine"

{% include postgres_create.sh %}

#Dump the existing database to a SQL file
pg_dump $FROMDB --no-owner --no-privileges > tmp.sql

#drop everything on the destination. Assuming a single, public schema. If that's not the case, update this to drop all schemas.
psql $AZURE_DATABASE_URL -c "drop schema if exists public;"

#send up the new db
psql $AZURE_DATABASE_URL < tmp.sql

echo "ALL DONE"



