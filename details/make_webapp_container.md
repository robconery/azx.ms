---
title: "A Makefile for a Simple Web Application Using Docker"
api: "/api/make_web_container"
layout: code_page
---

This Makefile works just like the other scripts here, however it has the added benefit of using `Make` to orchestrate things. This means that you can roll everything back if there's an error, which can be very useful.

To execute this file, simply run:

```
make || make rollback
```

The `rollback` target drops the entire resource group so make sure you're only running it when creating things.