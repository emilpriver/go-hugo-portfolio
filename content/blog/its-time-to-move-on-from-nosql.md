---
title: "It's Time to Move on From Nosql"
date: 2025-01-02T11:18:32+01:00
draft: true
---
There are a few things and directions we developers have taken that I think were probably not good things, such as NoSQL. Back in 2019 and probably even earlier, many developers looked into Lambda functions because they solved the problems of unexpected traffic spikes for our system, and don't get me wrong, they probably did. But they didn't solve the problem of our wallets not printing money on demand, but that is a different story.

When we started to use Lambda functions even more, we realized that if we use Lambda functions which we don't have a lot of control over, we also need to have a database which can scale up automatically when our traffic scales up too. At the time, the traditional way to use a database was to spin up a MariaDB, MySQL or Postgres database and set up a connection between the application and the database. But the problem when you use Lambda and a normal relational database is that it's hard to control how many connections you spin up because it is possible for the Lambda scheduler to spin up 100 functions which all need connections to the database, and we might not have control over when these connections spin up so the database gets too much work and probably dies. So when we realized this, we probably also realized that we need something which works the same, which became NoSQL.

NoSQL worked as an alternative due to its design. NoSQL is essentially an object-storage system which comes with an interface so we can more easily query the data, but it has no rules or structure on the data. It simply stores it and lets you do basic operations on the data such as where, sum and count. But there is one trade-off - due to its design with files in an object storage, you are now forced to do many queries instead of one to be able to fetch all the data if you need it, and you pay per request you make.

## I't dont scale
Scale in software engineering refers to a system's ability to handle growing demands while maintaining performance and reliability. If you look at NoSQL databases, they indeed handle the increased amount of traffic for services very well; however, there is more to scale than traffic. I also often see the ability to grow over time in terms of database size and how easy it is to maintain as part of scaling, and this is where NoSQL doesn't scale.

I generally believe that in programming, working more strictly makes it easier to maintain software over time, such as using a strictly typed language like Rust. A strictly designed relational database can grow more easily with you over time because you design a schema which your data follows. This is not the case with NoSQL because there is no such thing as a schema in a NoSQL database; sure, the application might have a schema, but not the database. If your product manager comes to you and tells you that the requirements have changed for the application, it can be really hard to achieve this change with a NoSQL database because you might have a big migration job in front of you. If you simply change a type in the application and you don't change the data for all documents, it could mean that when you're requesting a type of string, you get an int, and this can create issues. If you decide to make a big migration job, you will probably need to pull a lot of data and then write it again, which can be pricey, compared to a SQL database where you can change the schema and tell the database how to make a migration if it's needed.


## See into the future
