---
title: "It's Time to Move on From Nosql"
date: 2025-01-02T11:18:32+01:00
draft: true
---
I started my programming career in the serverless era, right when Kubernetes started to get popular. During this time, many developers wanted to move away from managing their own infrastructure and VMs, and run everything serverless, which was great - we could now focus on features rather than infrastructure.
Everything was serverless: HTTP handlers, scaling to infinity and to zero, and even automation for ordering pizza from Pizza Hut.

When we started to praise serverless as the solution to our badly written NodeJS applications problems, we began to run into issues with our SQL databases. They started having connection problems as our Lambda functions scaled up to 100 concurrent executions due to multiple users querying the API simultaneously. When these problems emerged, we started looking for database solutions that could also "scale infinitely," which led us to NoSQL.

NoSQL is essentially an HTTP layer on top of object storage. I often look at NoSQL as something that allows us to query our local files on the disk and provides an interface doing the lookup for files based on what you're asking for. This is also why NoSQL has suited quite well for "high traffic" sites compared to today's SQL databases, which also have a lot of functionality to aggregate data - something our applications need to do when we use NoSQL. For example, if you want to get the difference between 2 numbers in 2 documents, you need to fetch 2 documents and then make the comparison in your code, compared to a SQL database where you can make a query and get the result back.

But there is 1 issue with NoSQL which is that NoSQL don't scale with your application and it kind of limits the scope of your application. I am speaking of that if you have NoSQL as your main DB for your data and want to change the requirements on the application after some year which would mean that you need to change the way your structure your database and you have a few GBs stored in your db.

