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

Anywho, The reason why I named this article "We Should All Code Like Steve Jobs" is not because of the code he have written, it's about the he liked when stuff we're simple and easy to understand. You should be able to look at the IPod when it was released and require mininmal brain usage to get a song played in your headphones. And for me is it the same with writing code, you should be able to look at something and quite fast understand what it's all about.

The code should be simple not smart.

Of course this dosn't meant that the code should be written in a way where the tradeoffs on re-writing the code from being smart to simple is making the code stupid, that's just stupidy.

When i've worked in big DDD projects where we are adding new features have the amount work to get a new features out in production increased due to the fact that we have added limits to the code that prevents us from doing stuff in a surtain way which leads to refactor rather then solving the problem. Most of this is because we want a domain to fit all other domains needs but it's hard because the other domains needs the domain differently which many teams leads to complexity and unescary usage of the system. And Clean code, DDD and so on most of the time create abstraction on top of abstraction calling other abstractions which calles abstraction where we instead could have duplicated the code and called it a day.
