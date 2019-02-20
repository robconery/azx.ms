---
title: "A PostgreSQL Hosted Instance"
api: "/api/postgres"
layout: code_page
---

This script will spin up Postgres for you on Azure, and it will also set the the firewall so you and your application can administer the data. You'll need PostgreSQL's binaries installed to get the most out of it, which are really easy to get.

You can install [Postgres.app](http://postgresapp.com) if you're on a Mac, or you can just [download the installer](https://www.postgresql.org/download/) for your platform. This will give you the `psql` utility, which you'll want in order to create a database remotely and run queries.