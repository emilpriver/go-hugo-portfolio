---
title: "About AI"
date: 2025-08-03T10:15:13+02:00
draft: true
type: "blog"
tags: ["ai"]
cover:
  image: "images/gradient.png"
toc: true
description: "About AI"
---

For the last 1.5 years, I have forced myself to work with and learn AI, mostly because the future of software engineering will inevitably have more AI within it. I've focused on optimizing my workflow to understand when AI is a genuinely useful tool versus when it's a hindrance. Now, 1.5 years later, I feel confident enough to say I've learned enough about AI to have some opinions, which is why I'm writing this post.

AI has become a race between countries and companies, mostly due to status. The company that creates an AGI first will win and get the most status. The models provided by USA-based companies are heavy and require a lot of resources to operate, which is why we build data centers of GPUs in the USA and [Norway](https://openai.com/index/introducing-stargate-norway/). At the same time, China delivers models that are almost as good as Claude Opus but need a fraction of the resources to deliver a result.

There's a strange disconnect in the industry. On one hand, [GitHub](https://fortune.com/2024/10/30/googles-code-ai-sundar-pichai/) claims that 20 million users are on Copilot, and [Sundar Pichai](https://techcrunch.com/2025/07/30/github-copilot-crosses-20-million-all-time-users/) says that over 25% of the code at Google is now written by AI. On the other hand, [independent studies](https://www.reuters.com/business/ai-slows-down-some-experienced-software-developers-study-finds-2025-07-10/) show that AI actually makes experienced developers slower. The common thread seems to be that companies selling AI solutions advocate for their efficiency, while independent sources tell a different story. It's also incredibly difficult to measure AI's true efficiency. Most metrics focus on whether we accept an AI's suggestion, not on whether we accept that code, leave it unedited, and ship it to production—mostly because tracking that is a profoundly difficult task.

My experience lands somewhere in the middle. I've learned that AI is phenomenally good at helping me with all the "bullshit code": refactoring, simple tasks that take two minutes to develop, or analyzing a piece of code. But for anything else, AI is mostly in my way, especially when developing something new. The reason is that AI can lure you down a deep rabbit hole of bad abstractions that can take a significant amount of time to fix. I've learned that you must understand in detail how you want to solve a problem to even have a fair shot at AI helping you. When a task is more than just busywork, AI gets in the way. The many times I've let AI do most of the job, I've been left with more bugs and poorly considered details in the implementation. Programming is the type of work where there often is no obvious solution; we need to "feel" the code as we work with it to truly understand the problem.

When I work on something I've never worked on before, AI is a nice tool to get some direction. Sometimes this direction is really good, and sometimes it's horrible and makes me lose a day or two of work. It's a gamble, but the more experienced you become, the easier it is to know when you're going in the wrong direction.

But I am optimistic. I do think we can have a beautiful future where engineers and AI can work side-by-side together and create cool stuff.

I've used IDEs, chat interfaces, web interfaces like Lovable, and CLIs, and it's with CLIs that I've gained the most value. So far, CLIs are the best way to work with AI because you have full control over the context, and you are forced to think through the solution before you hit enter. In contrast, IDEs often suggest code and make changes automatically, sometimes without my full awareness. In a way, CLIs keep me in the loop as an active participant, not a passive observer.

For everything I don't like doing, AI is phenomenally good. Take design, for instance. I've used Lovable and Figma to generate beautiful UIs and then copied the HTML to implement in an Elixir dashboard, and the results have been stunning. I also use AI when I write articles to help with spelling and maintaining a clear narrative thread. It's rare, but sometimes you get lucky and the AI handles a simple task for you perfectly.

## Good Stuff

There are a couple of really nice things about AI that I've learned. I previously mentioned getting rid of the boring bullshit stuff I do in my daily work—this bullshit stuff is about 5% of everything I do on a daily basis. For example, today I managed to one-shot solve a new feature using AI. The feature was adding search to one of our APIs using Generalized Search Tree. I added the migration file with the create index, and the AI added query parameters to the HTTP handler and updated the database function to search on `name` if we have added a search parameter.

But the thing that AI has provided me the most value in my day-to-day work is that instead of bringing a design to a meeting, we can bring a proof of concept. This changes a lot because developers can now easily understand what we want to build, and we can save tons of time on meetings. Building PoCs is also really good when we enter sales meetings, as a common hard problem in sales is understanding what the customer really wants. When we can bring a PoC to the meeting, it's easier to get feedback faster on what the customer wants because they can try it and give direct feedback on something they can press on. This is an absolute game-changer.

Another really nice thing is when we have a design and we ask the AI to take a Figma design into some React code—it can generate the boilerplate and some of the design. It doesn't one-shot it, but it brings some kind of start which saves us some time. The reason why AI works well with frontend is that the hard part about frontend is not writing the code from a design; it's optimizing it for 7 billion people with different minds and thoughts, different devices, internet connections, and different disabilities.

## Vibe Coding

Vibe coding, for those who don't know what it is, is when you prompt your way to write software. You instruct an AI to build something and only look at the result rather than using AI as a pair-programmer to build the software, where you check the code you add. There is a major problem with this, as AI is, for a fact, terrible at writing code and introduces security problems. It also doesn't understand the concept of optimizing code—it just generates a result.

For instance, I asked Claude in a project to fetch all books and then fetch the authors and merge the books and authors into a schema structure where the book includes the author's name. This is a simple task, but Claude preferred to fetch (database query) the Author in a loop instead of fetching all books first, then their authors, and merging them together in a loop. This created an N+1 query. If we have 10,000 products, this would mean 10,001 queries, which is not a smart way of fetching data as this could lead to high usage of the database, making it expensive because we need to fetch so much data.

Vibe coding will pass. I don't think it will stay for much longer, mostly because we require developers to actually understand what we're working with, and vibe coding doesn't teach you—plus vibe coding creates too much slop. Instead, it will be more important to learn how to work with context and instructions to the AI.

But there is one aspect of it which I think is great and dangerous. When you're a new developer, it's really easy to struggle with programming because it takes a lot of time to get feedback on what you're working with. This is why Python or JavaScript are great languages to start with (even if JavaScript is a horrible language) because it's easy to get feedback on what you're building. This is also why it's great to start with frontend when you're new, because the hardest part of building frontends is not the design, and you can get feedback in the UI on all changes you make, which makes you feel more entitled and happy to continue programming. If you don't get the feedback, it's easy to enter a situation where you feel that you're not getting anywhere and you give up.

But with an AI, we can get a lot of help on the way to building a bit more advanced stuff. When you're a new developer, it's not really the most important thing to learn everything—it's to keep going forward and building more stuff as you will learn more after a while. The only problem with vibe coding and learning is that it takes you more time to learn new stuff when you don't do it yourself.

There are some services that claim non-technical people can build SaaS companies using their services, which of course is a lie. For the non-technical people I've talked to regarding this matter, a tool like Replit can be good when what they sell is not a SaaS offering—for example, they are a barber and need a website. When we try to vibe code a SaaS company using a prompt web interface, these "non-technical" founders often throw their money into a lake because what they want to build doesn't work and has tons of bugs and wrongly built solutions.

There is a saying in programming: the last 10% of the solution is 90% of the work. The last 10% is the details, such as how should we handle this amount of messages—should they be an HTTP handler or should we create a message queue? How should my system and the other system communicate? What is a product and what is an ingredient? This is the type of stuff that non-technical people don't understand and what the AI doesn't understand as well—the AI just generates code.

## Tech Debt

AI is fundamentally the biggest tech debt generator I've worked with in my life. Tech debt, for those who don't know what it means, is the trade-off created when we develop software. Tech debt can create situations where the system is too expensive or it becomes too much of a problem to get new features out in production due to limitations in other parts of the system. Every company has some kind of tech debt—some have higher and some have lower. Limiting tech debt is easy: you only need to say no to stuff or don't write any code at all, or you need to focus on building software in a standard and simple way. The more simple (but not stupid), the lower the amount of tech debt.

For example, the problem with choosing PostgreSQL over DynamoDB is that it requires more manual work to scale a PostgreSQL database, while a DynamoDB scales automatically as it's managed. When we get traffic spikes, DynamoDB handles this better, but at the same time, DynamoDB forces us to structure our data in a different way, and you don't really know what you will pay for the usage. It increases memory usage as you need to fetch entire documents and not just some specific fields, which is common for NoSQL databases.

The reason why AI is the biggest tech debt generator I've seen is that it leads us into rabbit holes that can be really hard to get out of. For instance, the AI could suggest you should store data in big JSON blobs in the database due to "flexibility" in a relational database. Another problem is that AI loves complexity, and the problem is that we accept complexity. Complexity creates issues where code becomes harder to maintain and creates bugs. AI often prefers not to reuse code and instead writes the same logic again.

Another issue with AI and tech debt is that AI creates tons of security vulnerabilities as it still doesn't understand security well, and many new developers don't understand it either. For instance, how to prevent SQL injections.

## We Don't Become More Efficient

A general thing that companies who sell AI services claim is that developers become more efficient, and some developers think they are, mostly because the only thing they look at is when they write code and not the part after writing code, such as debugging. For developers who use AI, some parts of their job switch from writing code to debugging, code review, and fixing security vulnerabilities. More experienced developers also feel that they are being held back by AI-generated slop code due to how badly the AI thinks, while more inexperienced developers feel the opposite.

For instance, I a while ago created bulk endpoints to our existing API and asked AI to do the job. I thought I saved some time as most of this was just boilerplate code and some copying. The task was that we should take the existing logic for creating, updating, and deleting objects. I prompted Claude to do updates and creations in parallel due to the logic, so it created channels and goroutines to process the data in parallel.

When I started to test this solution, I quite quickly saw some problems. For example, the AI didn't handle channels correctly—it set a fixed length of the channel, which would create a problem where we create a situation where the code would hang as we're trying to add more data to the channels while we at the same time use `sync.Wait()`. This was an easy fix, but I spent some time debugging this.

When we added deletion of objects, we didn't build a solution where we deleted multiple IDs at once; instead we used goroutines and channels to send multiple delete SQL queries, which created a much slower and more expensive solution. This was also fixed. Instead of logging the error and returning a human-readable error, we returned the actual error code, which could create security vulnerabilities.

After my try at offloading more to the AI, I stopped and went back to writing everything myself as it generally took less time.

It's also a really weird way of measuring efficiency on how much code we accept, especially when most of the code won't even hit production. But I guess they need to sell their software in some way.

## The Gainers of AI Are Not the Developers—It's the People Around Them

So with all these tools built for developers, I realized that the people who gain the most from all these tools are not the developers—it's all the people around who don't write code. It's easier for customers to show what they really want, we can enter sales meetings with a PoC which makes the selling part easier, and product owners can generate a PoC to show the developers how they think and get quicker feedback.

The most gain we get so far is all the easy tasks we repeat on our daily basis.

## The End

I think we will have a bright future with AI and that AI can help us in so many ways—for example, removing stress from our day-to-day tasks that might not even be related to jobs, such as repetitive tasks we do with our family. If an AI can replace these repeated tasks, I could spend more time with my fiancé, family, friends, and dog, which is awesome, and I am looking forward to that.