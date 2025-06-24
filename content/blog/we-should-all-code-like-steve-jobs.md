---
title: "We Should All Code Like Steve Jobs"
date: 2025-06-23T23:25:15+02:00
draft: true
description: "A critique of complex coding methodologies, advocating for Steve Jobs-inspired simplicity in software development to create understandable and maintainable code."
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

In my experience with large Domain-Driven Development projects, or any project that rigidly follows a set of "rules," adding new features often becomes a struggle. The effort to get them into production increases because the existing structure, with its self-imposed limits, forces extensive refactoring instead of allowing us to directly solve the problem at hand. This complexity often arises from trying to make one domain serve the diverse needs of all other domains. Since each domain has different requirements, this approach frequently leads to convoluted systems and unnecessary overhead. Methodologies like Clean Code and DDD often result in layers of abstraction calling other abstractions, when sometimes, duplicating a bit of code and moving on would be far more practical.

A common reason I see for developers wanting to restart a project is that they've locked themselves into so many rules that the project becomes overly complex. Instead of fixing this inherent complexity, they opt for a restart. Ironically, this often leads to a similarly architected project, especially if the same developers are involved—it's often said that the same developer rebuilding a project is likely to make many of the same choices, leading to a similar outcome.

Domain-Driven Development is just one of the philosophies I find problematic to work with; I could go on about this topic forever 😊

What I believe is most important about software code, and how we should measure its quality, includes:
1. A new developer can easily ship to production.
2. As a reviewer of a Pull Request, you can look at a piece of code and understand it immediately.
3. We don't slow down as we add new features.
4. I don't become bald when I jump into the project.

If any of these four points aren't being met, it's a strong indicator that the codebase might be veering away from the simplicity I advocate. It could mean that some refactoring is in order—perhaps to choose clearer function or variable names. Or, it might simply mean it's time to step away, clear your head, and return to the problem with a fresh perspective, ensuring the solution remains straightforward and understandable.

## Solving the higher problem first
When I worked at [CarbonCloud](https://carboncloud.com/), I learned a valuable lesson about this from an old co-worker I asked for feedback. Essentially, the feedback was that instead of solving the higher-level problem first, I had jumped straight into the code and built something. This is something I now consciously consider before starting larger projects or features. While tiny, straightforward tasks might not need extensive upfront thinking, something like the bulk API I am currently building certainly did. It required careful consideration of what we wanted to solve and how we wanted to solve it *before* any code was written. By focusing on the higher problem first, I managed to deliver a much simpler solution that works great.

It isn't a difficult concept, but it's one that significantly improves the product: solve the *actual* problem before writing any code. Sometimes this is super obvious, and sometimes you need to talk to your teammates before you write any code.

Sometimes, we jump into coding and ship something we *think* solves the problem, rather than what *actually* solves it, simply because we haven't fully understood the requirements.

A good example of this is when you need to add a new queue for asynchronous message handling. One way is to introduce a new system to the stack, like AWS SQS or Kafka. Another way is to add a new table to the existing database and create a worker that polls for jobs every few seconds. One approach is more complicated and potentially requires more people to maintain; the other is simpler and might not.

By focusing on the higher-level problem, you might realize that:
1. The job doesn't need to be processed instantaneously; in fact, a delay of even 10 seconds might be perfectly acceptable.
2. Only one service actually needs the information from these jobs.

However, if speed *were* a critical requirement, then using the existing database might indeed lead to a suboptimal or 'stupid' solution because it wouldn't meet those specific needs.

## Simple systems
What I find interesting is that the developers I personally look up to, who are all far more experienced than I am, almost always say the same thing when I ask for feedback on my systems: keep it simple, and don't add any more than what is truly necessary.

This is also why I would recommend a new company build a monolith if its developers aren't deeply familiar with distributed systems. It's generally easier to run and scale a monolith initially, and they can grow with it for a long time before needing to consider more complex architectures.

Systems built simply (not naively simple, but thoughtfully simple) are often the ones that work the best and last the longest.

## The End

I decided to write this article after I've worked in enough codebases where developers' opinions on what "clean code" truly means have influenced projects far too much. Hopefully, this article helps you understand my firm belief: many so-called "clean code" ideas are concepts we might have been better off without.

I genuinely love simple and easy-to-understand code. The projects I've maintained that have remained in use for the longest time are precisely these types of projects. Conversely, projects that rigidly adhere to some "clean code" philosophy have often required complete rewrites. This frequently happens because developers' personal preferences for these abstract principles take precedence over the primary goal of shipping a working solution. Their pursuit of an idealized "clean code" state can complicate development, leading to extensive refactoring that, in turn, introduces bugs and devilish complexity.
