---
title: "Designing a Platform for a Startup"
date: 2024-07-03T11:37:06+02:00
draft: true
---

I am currently helping a person build a startup and helping them to design the platform and get stuff up and running and this is tweet is how I designed it. My vision is splitted into X parts.

A short description of the project without telling what the project is about is that the platform is a place where the customer can add their content and then the data is distributed to multiple platforms such as Social Media.

This projects is hosted on Google Cloud

Part 1, Get something up and running they can sell:
Part 1 is all about get shit up and running so they can sell something (it don't need to be feature complete but something need to be there). This means that everything should be basic and be able to scale.

A common hard part when it comes to scaling services is the databases and their is some services(planetscale, neon) who solves this in some part but all of them requires us to send data outside of our VPC and we don't want that.

Another issue is that none of the people involved in the project (including me) is a platform person. We're all backend and frontend devs so we're not experts in running kubernetes and so on. And building the platform this way and 

In short what this design looks like atm is:
- The API we use for the dashboard is a Cloud Run docker container written in Go who have it's own database storing content.
- When content is updated do service A build a JSON object which it send to a topic which distribute it to multiple cloud functions.
- All of the cloud functions have different responsibilities with what it do with the data
 


## link: https://excalidraw.com/#json=ZJhzlLiezRxsjAa1xUW4X,VnT0docPYuUiB9MrsHcUiQ
