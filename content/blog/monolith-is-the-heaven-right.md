---
title: "Monolith Is the Heaven, Right?"
date: 2024-11-06T11:18:23+01:00
draft: false
description: "Monolith vs Microservices: Why Companies Choose Complexity Over Simplicity, and How to Make it Work for Your Team"
type: "blog"
tags: ["microservices", "monolith"]
toc: false
cover:
  image: "images/mad-man-cover.webp"
---
How many times have we, as developers, discussed the Monolith vs Microservices debate, and every time we talk about it, the conversation revolves around how much easier it is to host a monolith and how developers often over-engineer today? Believe it or not, I totally agree with you.

Monoliths are indeed easier to host.

Monoliths are cheaper to host.

Microservices increase the complexity of the system.

However, companies such as [DoorDash](https://blog.neetcode.io/p/doordash-robust-microservices) still adopt Microservices. Why? Because the problem isn't about hosting or the cost, or that the system is over-engineered and becomes more complicated. The issue is that developers have differing opinions, and this prevents organizations from shipping because we create blockers for each other. 

When Microservices was introduced was one of the selling points that it allows us to scale apps differently depending on the traffic and that we can work with more languages then 1 to run an application and both this arguments made sense, in 2012 -> 2017. 

And then, a few years ago, COVID happened, and hardware skyrocketed to a new level of speed and stability. Today's chips are so fast that the language can be a bottleneck. Some time ago, the problem was often that the CPUs weren't fast enough to process the code, and we could write slow, inefficient code and deploy it, and still be okay with it. Today, the problem is often that we write slow, inefficient code that doesn't utilize the full capacity of the server. 

With the improvements in hardware that we have today, we've finally seen that running a monolith isn't as difficult as it was earlier, thanks to how much better the CPUs are. Just look at DHH, who walked away from the cloud and went into self-hosting a monolith on bare-metal servers, and how well it works for them.


## Microservices "Microservices"

Microservices are considered harder to host because when we move out of the context of a single service, we drastically increase the amount of things we need to think about. We're moving from calling a function to either making an HTTP call or creating a new event in the system. Just imagine that you're cutting down a tree. When the context is just you, it's easier because you don't need to communicate with anyone. But when another person joins you, you need to communicate that you're cutting the tree, and this is similar to what happens between services. For example, what happens if one service returns a 500 error or the human doesn't respond when you yell "TIMBER"?

But I do understand why we often say that microservices are harder to host, and it's not just because of what I said in the previous sentence. 

I started my career as a system engineer back in 2019, and I wanted to learn more about the history of system engineering, mainly because I thought that I could learn some valuable lessons from the "older" days, and I did. I read many horror stories that took the term "microservices" a bit too far, creating tiny services that did very little and then creating their own Function-as-a-Service type of architecture, where they treated different services as functions by switching the code from invoking a function into an HTTP call, and then creating a chain of microservices calling each other just because the type of product differed between two services. And this is where I think we went terribly wrong with microservices.

## But my opinion is the correct one??

When it comes to developers, we all have different ways of thinking about systems and code. Some ideas are better than others, but it's often the details where the most issues arise for developers. For example, do you return a pointer or not return a pointer in Go? How do you define clean code and how do you write it? Ask these questions to a group of developers where the number of developers is more than 10. Which answer is correct? You might understand that everyone has different opinions on the subject, and this is also why you might have gotten a lot of different answers, and you might question whether these developers are really smart or not.

In a real-world example, we also encounter situations where we want to build the same solution, but we think differently, which is normal. We are humans, not robots. When we build big monoliths, it's quite easy to get stuck in a loop of feedback where a group of developers can't decide on how to build the solution, creating blockers for the developers because we spend more time discussing than writing code. This is something that easily happens when there are more than 10-15-20 developers working on the same monolith, especially if we're stubborn.

So when this happens and management notices it, they probably think about creating smaller teams. Fewer developers equals fewer opinions. More code shipped, problem solved.

But that's not how it works if we don't create good boundaries between the teams. What we do is start to split the monolith into parts, so each team owns different parts. But (always a but) the problem now is that we start to write different types of code. Some teams want to change the database because it makes sense to them, but it doesn't make sense to the other teams, and we're back to square one, where we now have discussions and less shipping again.

So at this point, it's time to split the service into apps in a microservices architecture, so we don't encounter these problems again.

I also don't think we should start talking about the horror stories about the hours of testing that some monoliths require due to the large amount of code they have.

So, microservices are not just about technical architecture, but also about organizational structure. Teams can now ship independently without blocking each other as often as they would in a monolith. Discussions are more about the communication between teams, such as API design, and not really about how the code looks or how it operates.

So, for many companies, the trade-offs from a monolith to microservices are better than staying with a monolith, even if it's more expensive to host and harder to run.

## How I think we should develop

After hearing all these horror stories, I still would start a project with a microservices architecture in mind, mainly because if we have more developers in the future, it would be easier. However, I would relax a lot on the "splitting the service" part. What I mean by this is that we would have a microservices architecture hosting not big monoliths, but rather monoliths where the requirements of the service are more than just a few things.

Let me give you an example.

A while ago, a couple of friends and I had a hobby project where the idea was to build something that integrated with Discord, Twitch, YouTube, and so on, and then sent data to different places. Imagine it as an analytics service.

When we started, we created three services, all named after Super Mario Bros: Nabbit (holding all the content data), Magikoopa (auth and users), and Toadsworth (listening to events and sending data further to other systems). However, after a while, we questioned ourselves and thought, "Why are Nabbit and Magikoopa split?" Because we thought that it made sense because they did different things, but we realized that this was not the case. So, we merged them, which left us running only two services.

Running Nabbit and Toadsworth as two microservices just made life so much easier for us.

So, the problem we now solved is that two of us (we're four friends developing this) own Nabbit, and two own Toadsworth. We have clear boundaries between each of the "teams," and we ship fast.

## The end

All system requirements are different, and all of this was just my thoughts on this subject. I've been working on big monoliths, over-engineered microservices, a mix of both, and running entire services in cloud functions. If I were to write about cloud functions and why they are often misused, I would probably hold the world record for the longest article.

Anyway, have a good one.

I talk about this type of thing every now and then on X and Bluesky. Follow me! :D

- https://x.com/emil_priver
- https://bsky.app/profile/priver.dev
