---
title: "The On-Call Driven Development"
date: 2024-11-03T21:38:21+01:00
draft: true
---
I've been thinking about this topic for a while now. On-call duty is something we rely on, but also dislike. Many businesses believe it's necessary for reliability in case something goes wrong. My issue isn't with having someone available to respond to alerts, which is always beneficial. My concern is with how on-call duty affects us engineers.

At one of the companies I worked for, I was on-call every six weeks, and sometimes for a few days in between those six-week periods. The extra pay was nice, and we didn't have much to do while on-call, thanks to our automated systems and well-designed processes. The requirements for on-call developers at that company was clear:
If something went down, our job was to get it up and running again, either by restarting a service or applying one of the scripts from the "run-this-scripts-if-prod-is-down" repository. However, we weren't expected to start debugging to find the root cause of the issue; that was left to the team owning the service on the next working day. I thought this approach was reasonable.

My problem with on-call duty isn't the concept itself, but rather how we engineers use it – often due to our own laziness or because we're put in situations that encourage laziness. This is my main pain point: the mindset that develops when we know we have an on-call team with a "fire extinguisher" ready to go when production goes down. The issue I have is that we rely on the on-call team as a safety net to ensure the services we're responsible for are up and running.

I think this happens for a couple of reasons, but I believe the two biggest factors are bad management and laziness.

## The management


## The Lazy Dev
Developers may sometimes be lazy and take shortcuts that they shouldn't, but in the long run, it can make a project seem too overwhelming. However, developers have a responsibility to ensure that the work they create functions properly. They should be able to complete their work for the day and still feel confident in the code they have written, allowing them to sleep well at night.

When we have on-call support, it can be easy to rely on it too much, leading to the release of software that has not been thoroughly tested. What I am referring to is the possibility that we may not write tests that ensure we can recover from errors effectively or that 1 edge-case we might know about but we don't handle. As we know we have someone covering our backs.

## The end
My biggest problem is really not that on-call exists or that we use it, and I totally understand why we use it. My issues is how we use it
