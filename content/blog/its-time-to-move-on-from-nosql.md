---
title: "It's Time to Move on From Nosql"
date: 2025-01-02T11:18:32+01:00
draft: true
---
I started my programming career in the serverless era, right when Kubernetes started to get popular. During this time, many developers wanted to move away from managing their own infrastructure and VMs, and run everything serverless, which was great - we could now focus on features rather than infrastructure.
Everything was serverless: HTTP handlers, scaling to infinity and to zero, and even automation for ordering pizza from Pizza Hut.

When we started to praise serverless as the solution to all the world's problems, we began to run into issues with our SQL databases. They started having connection problems as our Lambda functions scaled up to 100 concurrent executions due to multiple users querying the API simultaneously. When these problems emerged, we started looking for database solutions that could also "scale infinitely," which led us to NoSQL.

NoSQL is essentially an HTTP layer on top of object storage. For example, you can query JSON files in object storage, which is why it can handle such high traffic. I often look at NoSQL as something that allows us to query our local files on the disk.
