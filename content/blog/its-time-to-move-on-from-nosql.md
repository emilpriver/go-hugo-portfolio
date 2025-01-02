---
title: "It's Time to Move on From Nosql"
date: 2025-01-02T11:18:32+01:00
draft: true
---
I started my programming career in the serverless era, right when Kubernetes started to get popular. During this time, many developers wanted to move away from managing their own infrastructure and VMs, and run everything serverless, which was great - we could now focus on features rather than infrastructure.
Everything was serverless: HTTP handlers, scaling to infinity and to zero, and even automation for ordering pizza from Pizza Hut.

During this change, many developers looked into alternative ways of storing data since we had limited control over database connections. When running an API using serverless functions, you need to think serverless all the way. For example, if you get 100 users at the same second and the scheduler schedules poorly, it could spin up the function 100 times. For a SQL database, this could mean 100 active connections, which could lead to problems. Therefore, you need a database that also runs serverless. This is essentially why people looked into using NoSQL as the database because it allowed scaling to infinity and down to 0 when we didn't need it anymore. Quite handy.

NoSQL is essentially an HTTP layer on top of object storage. I often look at NoSQL as something that allows us to query our local files on the disk and provides an interface doing the lookup for files based on what you're asking for. This is also why NoSQL has suited quite well for "high traffic" sites compared to today's SQL databases, which also have a lot of functionality to aggregate data - something our applications need to do when we use NoSQL. For example, if you want to get the difference between 2 numbers in 2 documents, you need to fetch 2 documents and then make the comparison in your code, compared to a SQL database where you can make a query and get the result back.

But there is one issue with NoSQL: it doesn't really scale. Sure, it scales with the amount of traffic, but it doesn't scale with your application when requirements change because it doesn't put any requirements on the data - it simply stores it. The scaling problem hits when you get new requirements for the application and want to change the data structure into a new structure that better suits the new requirements. With a SQL database, this means we change the schema, but with NoSQL, we need to change every document in the collection, and this job can be heavy, really heavy. Another issue is that we also need to think about how we structure the data so it's easier to fetch, for example by specific fields in the JSON structure which store values that you might need to filter documents with. 

The biggest problem, however, is that we can't put any requirements on the data; e.g., the same key in the document can be both a string and an int.

