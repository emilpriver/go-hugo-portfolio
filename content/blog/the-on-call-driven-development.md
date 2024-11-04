---
title: "The On-Call Driven Development"
date: 2024-11-04T11:38:21+01:00
draft: true
---
I've been thinking about this topic for a while now. On-call duty is something we rely on, but also dislike. Many businesses believe it's necessary for reliability in case something goes wrong. My issue isn't with having someone available to respond to alerts, which is always beneficial. My concern is with how on-call duty affects us engineers.

At one of the companies I worked for, I was on-call every six weeks, and sometimes for a few days in between those six-week periods. The extra pay was nice, and we didn't have much to do while on-call, thanks to our automated systems and well-designed processes. The requirements for on-call developers at that company was clear:
If something went down, our job was to get it up and running again, either by restarting a service or applying one of the scripts from the "run-this-scripts-if-prod-is-down" repository. However, we weren't expected to start debugging to find the root cause of the issue; that was left to the team owning the service on the next working day. I thought this approach was reasonable.

My problem with on-call duty isn't the concept itself, but rather how we engineers use it – often due to our own laziness or because we're put in situations that encourage laziness. This is my main pain point: the mindset that develops when we know we have an on-call team with a "fire extinguisher" ready to go when production goes down. The issue I have is that we rely on the on-call team as a safety net to ensure the services we're responsible for are up and running.

I think this happens for a couple of reasons, but I believe the two biggest factors are bad management and laziness.

## Bad management

Most devs have deadlines, and stuff needs to be done in time, otherwise customers might churn. And no one wants that. It's bad for our businesses. But what I think happens many times is that the dev is put in a position where we need to be on-call because they have a too-short deadline to build a proper solution. For example, not just a solution that does the thing we need it to do, but also a solution with tests to make sure it actually works. Bad managers don't understand how important these tests are, so they are upset when the dev says, "Hey, I need to write some more tests for this," and then no more tests are written because the devs don't get the time to do it.

But the bigger problem here is the stress that is created. We're humans, and when we're put under stress, we miss stuff - details that can be quite important. For instance, what does the container do when it gets a `SIGTERM` or `SIGKILL` notification from Kubernetes? Just aborting and killing the pod could create issues because the message wasn't finished yet, or the pod is killed. Do we handle a `panic` in the code? This is some of the stuff we can miss, which can create a need for an on-call team when the real problem is that the dev was put in a position when they we're unable to test it.

This is also why I dislike sprints, SAFe and these stuff we normally work with in our day-to-day life mainly as it can put us in a position where we stress-build something.

## The Lazy Dev


## The end
My biggest problem is really not that on-call exists or that we use it, and I totally understand why we use it. My issues is how we use it
