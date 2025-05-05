---
title: "Golang container and concurrency"
date: 2025-05-05T19:11:16+02:00
draft: true
---
I recently had this bug where I did see increased CPU usage and random HTTP latency where we spiked from 20/30ms to 300 ms in response time and decided to look into it even more. We're running on Google Cloud Run which is a managed container-as-a-service service. 
