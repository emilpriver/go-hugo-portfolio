---
title: "We Should All Code Like Steve Jobs"
date: 2025-06-23T23:25:15+02:00
draft: true
description: "Change me...."
type: "blog"
tags: ["Steve Jobs"]
toc: false
cover:
  image: "images/steve-jobs.jpeg"
---
I really don't like Test-Driven Development(TDD), Domain-Driven Development(DDD), the Clean Code philosophy or most of the things we have which tell us how we should write code, mostly because they never work in codebases that should last for years, and I am not really a fan of Apple even if the title includes the name of the creator of Apple. As a matter of fact, I am the only one in my big family who moved away from Apple entirely and now uses Linux and Android. Mostly because it brings more peace to my everyday work but also because I really don't get why you want to use an iPhone when the best new thing Apple could come up with was adding opacity 0.8 to all UI.

Anywho, the reason why I named this article "We Should All Code Like Steve Jobs" is not because of the code he had written, it's about how he liked when stuff was simple and easy to understand. You should be able to look at the iPod when it was released and require minimal brain usage to get a song played in your headphones. And for me, it is the same with writing code; you should be able to look at something and quite quickly understand what it's all about.

The code should be simple, not smart.

Of course, this doesn't mean that the code should be written in a way where the trade-offs in rewriting the code from being smart to simple makes the code stupid; that's just stupidity.

When I've worked in big DDD projects where we are adding new features, the amount of work to get new features out in production has increased due to the fact that we have added limits to the code that prevent us from doing stuff in a certain way, which leads to refactoring rather than solving the problem. Most of this is because we want a domain to fit all other domains' needs, but it's hard because the other domains need the domain differently, which, for many teams, leads to complexity and unnecessary usage of the system. And Clean Code, DDD, and so on most of the time create abstraction on top of abstraction calling other abstractions which calls abstraction when we instead could have duplicated the code and called it a day.

Now, DDD is only one of the philosophies I dislike working with, mainly as I could go on forever about this topic :D

What I think is most important about software code, and how we should measure it, is:
1. A new developer can easily ship to prod.
2. As a reviewer in a PR, can you look at a piece of code and understand it immediately?
3. We don't slow down as we add new features.
4. I don't become bald when I jump into the project.

## Solving the higher problem first
When I worked at [CarbonCloud](https://carboncloud.com/), I learned this exact topic by asking an old co-worker for feedback. It isn't a hard topic to learn, but it's something that makes the product way better: solving the higher problem before writing any code. Sometimes this is super obvious, and sometimes you need to talk to your teammates before you write any code.

Sometimes we jump into the code and ships something we think solves the problem and not something which did solve the problem due to that we don't understand the requirements.

A good example on this topic is when you need to add a new queue because you have some messages you want to handle async, 1 way is to add an a new sysem to the stack, e.g AWS SQS or Kafka while another one is to add a new table to the existing database, create a worker which pulls jobs every second. 1 is more complicated and 1 is simpler. 1 requires could require more people to maintain and the other don't require more people.

Solving the higher problem would you might see that:
1. The job don't need to be processed the same second, in mather of fact is it ok if it process it 10 seconds later.
2. It's only 1 service which need the information of the jobs

However, if speed would be a requirement could this mean using the existing database could make us build it in a stupid way because we don't meet the requirements.

## The End
