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

In my experience with large Domain-Driven Developed projects or any type of projects who follow some type of "rules", adding new features often becomes a struggle. The effort to get them into production increases because the existing structure, with its self-imposed limits, forces extensive refactoring instead of allowing us to directly solve the problem at hand. This complexity often arises from trying to make one domain serve the diverse needs of all other domains. Since each domain has different requirements, this approach frequently leads to convoluted systems and unnecessary overhead for many teams. Methodologies like Clean Code and Domain-Driven Development often result in layers of abstraction calling other abstractions, when sometimes, duplicating a bit of code and moving on would be far more practical. The biggest reason I see when developers want to start over on a project is because they locked themself into so much rules so the project becomes to complex, so instead of fixing the complexity do they restart, Which also many times creates the same type of written project. And then when the developer start over from scratch do they build the project almost the same way, this is why we say that the same developer shouldn't rebuild a project because it's a big chance they build it the same way. 

Domain-Driven Development is just one of the philosophies I find problematic to work with; I could go on about this topic forever 😊

What I believe is most important about software code, and how we should measure its quality, includes:
1. A new developer can easily ship to production.
2. As a reviewer of a Pull Request, you can look at a piece of code and understand it immediately.
3. We don't slow down as we add new features.
4. I don't become bald when I jump into the project.

If any of these four points aren't being met, it's a strong indicator that the codebase might be veering away from the simplicity I advocate. It could mean that some refactoring is in order—perhaps to choose clearer function or variable names. Or, it might simply mean it's time to step away, clear your head, and return to the problem with a fresh perspective, ensuring the solution remains straightforward and understandable.

## Solving the higher problem first
When I worked at [CarbonCloud](https://carboncloud.com/), I learned a valuable lesson on this exact topic from an old co-worker I asked for feedback. Essentialy the feedback was that instead of solving the higher problem first did I jump into the code and built it. This is a thing I am now thinking of before I start to build bigger projects or features, the tiny straightforward things might not need it but for instance the current bulk API i am building needed some thinking of what we want to solve and how we wanted to solve it before any code was written. By solving the higher problem first did I manage to deliver a way simpler solution which works great. 

It isn't a difficult concept, but it's one that significantly improves the product: solve the *actual* problem before writing any code. Sometimes this is super obvious, and sometimes you need to talk to your teammates before you write any code.

Sometimes, we jump into coding and ship something we *think* solves the problem, rather than what *actually* solves it, simply because we haven't fully understood the requirements.

A good example of this is when you need to add a new queue for asynchronous message handling. One way is to introduce a new system to the stack, like AWS SQS or Kafka. Another way is to add a new table to the existing database and create a worker that polls for jobs every few seconds. One approach is more complicated and potentially requires more people to maintain; the other is simpler and might not.

By focusing on the higher-level problem, you might realize that:
1. The job doesn't need to be processed instantaneously; in fact, a delay of even 10 seconds might be perfectly acceptable.
2. Only one service actually needs the information from these jobs.

However, if speed *were* a critical requirement, then using the existing database might indeed lead to a suboptimal or 'stupid' solution because it wouldn't meet those specific needs.

## Simple systems
What I find interesting is that the developers I personally look up to, who are all way more experienced then I am almost say the same thing when I ask about feedback for my system which is that I should keep it simple, don't add to more then what we really need.

This is also why I would recommend a new company to build a monolith if the developers who build it is not that familiar with distributed systems, because it is more easier to run a monolith and they can grow on it for a long time.

Systems build simple (not stupid simple) are often then once which works the best.

## The End

I decided to write this article after I've worked in enough codebases where developers' opinions on what "clean code" truly means have influenced projects far too much. Hopefully, this article helps you understand my firm belief: many so-called "clean code" ideas are concepts we might have been better off without.

I genuinely love simple and easy-to-understand code. The projects I've maintained that have remained in use for the longest time are precisely these types of projects. Conversely, projects that rigidly adhere to some "clean code" philosophy have often required complete rewrites. This frequently happens because developers' personal preferences for these abstract principles take precedence over the primary goal of shipping a working solution. Their pursuit of an idealized "clean code" state can complicate development, leading to extensive refactoring that, in turn, introduces bugs and devilish complexity.
