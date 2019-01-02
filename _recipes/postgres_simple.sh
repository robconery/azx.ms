---
title: Simple PostgreSQL Setup
description: Setup PostgreSQL with user name and password as well as firewall access.
script:
keywords:
author: Rob Conery
---

#!/bin/bash
#Change the settings below as you need
{% include resource_group_create.sh %}

{% include postgres_create.sh %}