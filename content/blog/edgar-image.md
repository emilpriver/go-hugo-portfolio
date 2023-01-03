---
title: "Edgar Image - self-hosted image transformation system"
date: 2022-08-21T22:12:48+02:00
draft: false
description: Edgar image, the self-hosted image transformation services.
type: "blog"
tags: ["projects", "Edgar Image"]
series:
- Edgar Image
images:
  - /og-images/edgar.jpg
cover: "images/edgar-image/cover.jpg"
toc: true
---

## Intro

Edgar Image is an image transformation service whose goal is to make it easy for you to host and run. The goal of the service is not to be a CDN, but rather a point in a whole series of services.There are many of these types of services that cost a lot but are also hard to work with or require you to upload all the images onto their platforms, But there is none(as for what I've found) where you can host and own all the images yourself. 

I got the idea when I worked at an agency company. We were working a lot with Next.JS next/image which is great, but sometimes a little bit slow and I wanted to develop something that could work for all customers, which is faster than next/image but also cheaper and with more CDN locations. This can be solved by using Cloudflare as a CDN cache for example. When the summer holiday started did I need a project I could work on when I had my time off, which is Edgar Image.

Edgar Image is available as a Docker image which makes it possible for you to control how to run and host it. I've developed using Digitalocean Apps but also runned it on a single Droplet at Digitalocean. But to be able to load the image fast every time do you need something that caches the image. And 1 service to achieve that is Cloudflare. This could be done with Cloudflare Workers or Page rules depending on how basic you want the cache to be. Using Page Rules will give you a basic, easy setup cache that could create problems as someone whose browser accepts a new format as WEBP could create a WEBP image that is cached, and when another browser that doesn't accept WEBP loads the same cached image, will it not load as the browser don't support it. Now, this could be handled with a Cloudflare Worker which reads the Accept header and forces a format with the format= query parameter. [A working Cloudflare Worker can be found here](https://github.com/edgar-image/cacheing/tree/main/examples/cloudflare-worker).
Cloudflare Worker also supports 0 start up time so a client won't notice a delay on the image if the image is cached.

## Future of Edgar Image

Edgar Image is in an early stage which means some functionality is still in progress and the goal is to support as many different functions as possible which makes it possible. But a goal is also to work with videos, for example, encode them in a modern format. But also to manipulate the video on the fly if needed.
