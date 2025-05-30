---
title: "It's Time to Move on From Nosql"
date: 2025-01-04T11:18:32+01:00
description: "Lets move on from NoSQL"
draft: false
type: "blog"
tags: ["nosql"]
toc: false
cover:
  image: "images/postgres.jpg"
---
There are a few things and directions we developers have taken that I think were probably not good things, such as NoSQL or thinking that edge runtime will make our websites faster. Back in 2019 and probably even earlier, many developers looked into Lambda functions because they solved the problems of unexpected traffic spikes for our system - and don't get me wrong, they probably did. But they didn't solve the problem of our wallets not printing money on demand, but that's a different story.

When we started to use Lambda functions even more, we realized that if we use Lambda functions which we don't have a lot of control over, we also need to have a database which can scale up automatically when our traffic scales up too. At the time, the traditional way to use a database was to spin up a MariaDB, MySQL, or Postgres database and set up a connection between the application and the database. But the problem when you use Lambda and a normal relational database is that it's hard to control how many connections you spin up. It's possible for the Lambda scheduler to spin up 100 functions which all need connections to the database, and we might not have control over when these connections spin up, so the database gets too much work and probably dies. When we realized this, we probably also realized that we need something which can handle unexpected connections, which became NoSQL.

NoSQL worked as an alternative due to its design. NoSQL is essentially an object-storage system that comes with an interface so we can more easily query the data, but it has no rules or structure for the data. It simply stores it and lets you do basic operations on the data such as where, sum, and count. But there is one trade-off - due to its design with files in object storage, you are now forced to do many queries instead of one to fetch all the data you need, and you pay per request you make, and there is no way to control which data you get back; you simply fetch all of the data.

The idea of spinning up a database without requirements on our data to use as our main database is, for me, an interesting idea and a weird move we do.


## Maintaining
Scale in software engineering refers to a system's ability to handle growing demands while maintaining performance and reliability. If you look at NoSQL databases, they indeed handle the increased amount of traffic for services very well; however, there is more to scale than traffic. I also often see the ability to grow over time in terms of database size and how easy it is to maintain that data as part of scaling, and this is where NoSQL doesn't scale.

I generally believe that in programming, working more strictly makes it easier to maintain software over time, such as using a strictly typed language like Rust. A strictly designed relational database can grow more easily with you over time because you design a schema which your data follows. This is not the case with NoSQL because there is no such thing as a schema in a NoSQL database; sure, the application might have a schema, but not the database. If your product manager comes to you and tells you that the requirements have changed for the application, it can be really hard to achieve a good change with a NoSQL database because you might have a big migration job in front of you. If you simply change a type in the application and you don't change the data for all documents, it could mean that when you're requesting a type of string and you get an int, and this can create issues. If you decide to make a big migration job, you will probably need to pull a lot of data and then write it again, which can be pricey, compared to a SQL database where you can change the schema and tell the database how to make a migration if it's needed.

And this is my biggest problem with NoSQL: the amount of work you need to do if you want to maintain a NoSQL database over a period of time and keep it in a good state, especially when the amount of data you store increases. A NoSQL database might solve your needs, but the problem isn't when things are working fine - it's when things are not working fine, as it's much easier to break a good state of a system where there are no rules to follow.

## Let's build a good model
Another thing with NoSQL is that we can't treat a NoSQL database as a relational database, which is obvious. But what I mean is that it will be more expensive if you treat your NoSQL database as a relational database by splitting up the collections (tables) into many and then making many queries to get all the data you need. This is why you need to think of how you build your data model so it's more easier to fetch data. For instance, if you want to build an API which shows products and want the category information to be on a single product's model, it is probably better to instead of updating a single category in the category collection, update all products with that category as well because it reduces the amount of documents we need to read in order to get the data we need.

However, it's a massive job to update all these products if we want to update the value for products which have that category.

And this is one of the biggest differences I realized when I was working with NoSQL: with NoSQL, you need to prepare the data before you make the request to keep it in a good state and prevent unnecessary costs for your database.

## What should we have done

Now this question is probably tied a lot to preference in how we work, but I think that from the beginning we shouldn't have used NoSQL for the cause of handling traffic; I think the problem has always been with the tech stack. But I definitely also think we shouldn't use NoSQL as our main DB. Either we should have used it as a persistent cache to our relational DB for the service which we expect to have heavy load, or we should have treated it as an alternative database to our relational database when we can't describe how to store the data so we simply just dump it somewhere, and then a data engineer or someone could use that "dumped" data to do their job.

But I also think we should have looked into other options which could be good candidates in the serverless lambda functions world, such as LibSQL. LibSQL is a SQLite fork by the company named Turso. It gives us an HTTP interface we can use to query the data from a lambda function. Something I didn't mention earlier is that when SSDs improved even more, NoSQL databases also improved in terms of speed, as did LibSQL. LibSQL allows us to achieve the same type of speed and scale as NoSQL but it also comes with requirements on our data.

