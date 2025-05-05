---
title: "Golang container and concurrency"
date: 2025-05-05T19:11:16+02:00
draft: true
tags: ["GOMAXPROCS","GO", "Google Cloud", "GCP", "Kubernetes"]
description: "TODO: Article about how you optimize performance for a go container"
type: "blog"
best: true
toc: false
cover:
  image: "images/golang.jpeg"
series:
  - Guides
---
I recently had this bug where I did see increased CPU usage and random HTTP latency where we spiked from 20/30ms to 300 ms in response time and decided to look into it even more. We're running on Google Cloud Run which is a managed container-as-a-service service. 

1. the problem
2. the solution
3. explain the solution
  a. Explain about container metrics(m) vs normal vCPU/CPU
  b. explain scheduler
