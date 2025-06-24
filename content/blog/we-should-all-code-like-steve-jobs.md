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
I really don't like Test-Driven Development (TDD), Domain-Driven Development (DDD), the Clean Code philosophy, or most of the methodologies that tell us how we should write code. This is mostly because they never seem to work in codebases designed to last for years. And, even though the title includes the name of Apple's creator, I'm not really a fan of Apple. As a matter of fact, I'm the only one in my big family who moved away from Apple entirely and now uses Linux and Android. This is mostly because it brings more peace to my everyday work, but also because I genuinely don't understand the appeal of an iPhone when Apple's latest big innovation was adding 0.8 opacity to all UI elements.

Anyway, the reason I titled this article "We Should All Code Like Steve Jobs" isn't because of any code he wrote; it's about his preference for simplicity and ease of understanding. When the iPod was released, you could look at it and, with minimal mental effort, figure out how to play a song. For me, it's the same with writing code: you should be able to look at a piece of code and quickly grasp what it's doing.

The code should be simple, not smart.

Of course, this doesn't mean sacrificing essential functionality or creating naive solutions in the name of simplicity. The goal isn't to make code 'stupid' by oversimplifying; that would indeed be counterproductive stupidity.

In my experience with large DDD projects, adding new features often becomes a struggle. The effort to get them into production increases because the existing structure, with its self-imposed limits, forces extensive refactoring instead of allowing us to directly solve the problem at hand. This complexity often arises from trying to make one domain serve the diverse needs of all other domains. Since each domain has different requirements, this approach frequently leads to convoluted systems and unnecessary overhead for many teams. Methodologies like Clean Code and DDD often result in layers of abstraction calling other abstractions, when sometimes, duplicating a bit of code and moving on would be far more practical.

Domain-Driven Development is just one of the philosophies I find problematic to work with; I could go on about this topic forever :D

What I believe is most important about software code, and how we should measure its quality, includes:
1. A new developer can easily ship to production.
2. As a reviewer of a Pull Request, you can look at a piece of code and understand it immediately.
3. We don't slow down as we add new features.
4. I don't become bald when I jump into the project.

If some of this 4 points is not fullfilled could it mean that you might need to refactor something to make it easier, maybe you need to create a better function or variable name. Maybe it means that you forgot to take a break in the middle of writing the solution to think of something else and then come back to the solution to have a differnet view on it.

## Solving the higher problem first
When I worked at [CarbonCloud](https://carboncloud.com/), I learned a valuable lesson on this exact topic from an old co-worker I asked for feedback. It isn't a difficult concept, but it's one that significantly improves the product: solve the *actual* problem before writing any code. Sometimes this is super obvious, and sometimes you need to talk to your teammates before you write any code.

Sometimes, we jump into coding and ship something we *think* solves the problem, rather than what *actually* solves it, simply because we haven't fully understood the requirements.

A good example of this is when you need to add a new queue for asynchronous message handling. One way is to introduce a new system to the stack, like AWS SQS or Kafka. Another way is to add a new table to the existing database and create a worker that polls for jobs every few seconds. One approach is more complicated and potentially requires more people to maintain; the other is simpler and might not.

By focusing on the higher-level problem, you might realize that:
1. The job doesn't need to be processed instantaneously; in fact, a delay of even 10 seconds might be perfectly acceptable.
2. Only one service actually needs the information from these jobs.

However, if speed *were* a critical requirement, then using the existing database might indeed lead to a suboptimal or 'stupid' solution because it wouldn't meet those specific needs.

## The End

I decided to write this article after i've been working in enough of codebases where developers opinion on what "clean code" has influenced the project to much and with this article you probably and hopefully understand that I really think any of the "clean code" ideas is mostly something we should never had introduced.

I really love simple and easy code and the projects i've maintained which have been in used for the longest time is this type of projects.  The projects who follow some kind of "clean code" philosophy have often been re-written due tho that developers opinions have mattered more to the developers then shipping a solution just because they want to keep the "clean code" which makes it harder because they need to refactor which implements bugs and devilish.
