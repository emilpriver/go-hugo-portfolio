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

Anywho, The reason why I named this article "We Should All Code Like Steve Jobs" is not because of the code he had written, it's about how he liked when stuff was simple and easy to understand. You should be able to look at the iPod when it was released and require minimal brain usage to get a song played in your headphones. And for me, it is the same with writing code; you should be able to look at something and quite quickly understand what it's all about.

The code should be simple, not smart.

Of course, this doesn't mean that the code should be written in a way where the trade-offs in rewriting the code from being smart to simple makes the code stupid; that's just stupidity.

When I've worked in big DDD projects where we are adding new features, the amount of work to get new features out in production has increased due to the fact that we have added limits to the code that prevent us from doing stuff in a certain way, which leads to refactoring rather than solving the problem. Most of this is because we want a domain to fit all other domains' needs, but it's hard because the other domains need the domain differently, which, for many teams, leads to complexity and unnecessary usage of the system. And Clean Code, DDD, and so on most of the time create abstraction on top of abstraction calling other abstractions which calls abstraction when we instead could have duplicated the code and called it a day. 

Now, DDD is only 1 of the philosophies I dislike working with mainly as I could go on for ever about this topic :D

What I think is the most important with software code is when and how we should measure it is:
1. A new developer can easily ship to prod
2. As a reviewer in a PR, can you look at piece of code and understand it immediatly
3. We're not slowing down when we're increasing new features
4. I don't become bald when I jump into the project

## Solving the higher problem first
When I worked at [CarbonCloud](https://carboncloud.com/) did I learn this exact topic by asking an old co-worker on feedback, which isn't a hard topic to learn but something which makes the product way better which is to solve the higher problem before we write any code. Sometimes this is super obviouse and sometimes you need to talk to your teammates before you write any code.

An good example on this topic is if your goal is to add AI to your product because some shareholder is asking for it should you define what AI for your product is, how it should be used instead of jumping into the code building the "super smart solution"
