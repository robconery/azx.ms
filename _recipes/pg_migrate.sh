---
title: Migrate a PostgreSQL Database
description: "Migrate an existing PostgreSQL database to Azure's SQL Database for PostgreSQL"
author: Rob Conery
---
#!/bin/bash

#SET THIS - it needs to be a URL
#The format of a DB URL is postgres://user:password@servername:port/dbname
#you can leave off the port if you're using a standard one
FROMDB="postgres://localhost/postgres"

#this should be in your .env if you created a PostgreSQL database using the script in our recipes
TODB=$AZURE_DATABASE_URL 

#Dump the existing database to a SQL file
pg_dump $FROMDB --no-owner --no-privileges > tmp.sql

#drop everything on the destination. Assuming a single, public schema. If that's not the case, update this to drop all schemas.
psql $TODB -c "drop schema if exists public;"

#send up the new db
psql $TODB < tmp.sql