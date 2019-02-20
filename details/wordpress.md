---
title: "A Highly Scalable Wordpress Site"
api: "/api/wordpress"
layout: code_page
---

I [wrote about this process in detail here](https://rob.conery.io/2019/01/09/creating-a-massively-scalable-wordpress-site-on-azures-hosted-bits/), but in summary form this script builds a Wordpress site using App Services for Containers to host Wordpress with Azure Sql Database for MySQL. 

It's straightforward to setup, but be sure to review the pricing. I've found that a standard `S1` App Service Plan works well.