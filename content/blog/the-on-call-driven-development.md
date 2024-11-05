---
title: "The On-Call Driven Development"
date: 2024-11-05T01:00:21+01:00
draft: false
description: "Building reliable systems without relying on on-call duty as a safety net."
type: "blog"
tags: ["on-call"]
toc: false
cover:
  image: "images/postgres.jpg"
---
I've been thinking about this topic for a while now. On-call duty is something we rely on, but also dislike. Many businesses believe it's necessary for reliability in case something goes wrong. My issue isn't with having someone available to respond to alerts, which is always beneficial. My concern is with how on-call duty affects us engineers.

At one of the companies I worked for, I was on-call every six weeks, and sometimes for a few days in between those six-week periods. The extra pay was nice, and we didn't have much to do while on-call, thanks to our automated systems and well-designed processes. The requirements for on-call developers at that company was clear:
If something went down, our job was to get it up and running again, either by restarting a service or applying one of the scripts from the "run-this-scripts-if-prod-is-down" repository. However, we weren't expected to start debugging to find the root cause of the issue; that was left to the team owning the service on the next working day. I thought this approach was reasonable.

My problem with on-call duty isn't the concept itself, but rather how we engineers use it – often due to our own laziness or because we're put in situations that encourage laziness. This is my main pain point: the mindset that develops when we know we have an on-call team with a "fire extinguisher" ready to go when production goes down. The issue I have is that we rely on the on-call team as a safety net to ensure the services we're responsible for are up and running.

I think that when we have on-call as a safety net, we might develop worse systems because less is taken care of, possibly because we know that someone has our back. I think that we should write software so that when it's time to go to bed, we can feel confident that it will continue to run. This includes testing solutions in different ways, such as stress tests and integration tests, and questioning the system, rather than just rushing to get it out there.

There are many reasons why rushing out a change happens, such as bad management creating hard deadlines that put developers under stress, or a bad overall structure of the company. Many companies use sprints, SAFe, or other methodologies that can be misused by bad managers to control developers, where the deadlines are short.

At the job I spoke about earlier, we had some really good fundamentals about how to operate and how to think. We had on-call, but on-call wasn't seen as a safety net that we could rely on. Instead, management enforced a culture where it was better to take one more week to work on something rather than shipping it quickly. This allowed us to take the time to think things through thoroughly and test them out before releasing. As a result of this way of working, we had an extremely well-working solution, and new developers to the company were surprised that we never did any fire-fighting.

I've come up with the term "On-Call driven development" to describe how the presence of on-call support can shape the way developers design and build systems. Essentially, it's about how having a safety net can influence the level of caution and thoroughness developers bring to their work.

To illustrate this, consider rock climbing with a safety rope. With the rope in place, you might feel more at ease taking risks and skipping double-checks, knowing that the rope will catch you if something goes wrong. Similarly, in software development, on-call support can create a similar mindset, where developers might be less inclined to thoroughly test and validate their code, knowing that the on-call team will handle any issues that arise.

This approach can lead to a culture where developers prioritize rapid feature deployment over building robust and reliable systems, knowing that someone else will be responsible for addressing any problems that come up.

## The end
My biggest problem is really not that on-call exists or that we use it, and I totally understand why we use it. My issue is more that we have a team existing to make sure our system works.

I think that some systems could improve how they work by removing on-call when it's not needed.

This one was brief, as I struggled to articulate it without expanding the topic too far beyond its original scope.

By the way, I'm on Bluesky - you can find me at https://bsky.app/profile/priver.dev.
