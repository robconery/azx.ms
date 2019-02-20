---
title: "A Simple Web Application Using Docker"
api: "/api/webapp_container"
layout: code_page
---

This script creates a web application within Azure using a DockerHub image. It's very easy to setup - you just need to deploy your application into a container and push to DockerHub.

The one trick to this script is if you have a private container registry. In that case you'll need to be sure you uncomment the section which sets the container information.