---
title: "A Multi Container Web App using Docker Compose"
api: "/api/webapp_multi"
layout: code_page
---

This script will take whatever compose YAML file you have and then send it to Azure. As an example, the script will create a Wordpress site along with a database. Be sure to set your compose file as needed.

**You do not need to put the YAML file into the script**. I just did that here as a way of showing how this can work with a single call. The important thing is that the script can reach the YAML file you intend to send.