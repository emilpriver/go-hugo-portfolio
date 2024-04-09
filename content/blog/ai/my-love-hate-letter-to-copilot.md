---
title: "My Love/Hate Letter to Copilot"
date: 2024-04-07T20:31:09+02:00
draft: false
type: "blog"
tags: ["copilot"]
cover:
  image: "images/ai/love-hate-letter-to-copilot.webp"
toc: true
description: "My love/hate letter to copilot"
---
Just as Post Malone expressed a love-hate relationship with alcohol, I'm here to share my mixed feelings about Copilot. This bittersweet tool has been in my toolkit for a while. Despite its frequent frustrations, I find myself relying on it more than I'd like. Only after disabling the AI did I notice the changes in my programming habits due to its influence.

For those unfamiliar with Copilot, here's a quick introduction: Copilot is a tool that attempts to understand your problem and then searches GitHub for matching solutions and suggest it to you. For many is this tool something they love as the can create the solution faster as they can just wait for a suggestion to be recommended and apply it as fast they can and then move on with their life.

When I began using Copilot and ChatGPT, I was amazed at how much faster I could create things. However, I hadn't anticipated how it would change my approach to system creation, or how it might affect my perspective during development and how it made the engineer within me smaller.

As software engineers, developers, or programmers, our role is not just to understand a problem and find a solution, but also to write good software. This means that while certain solutions, such as using `.clone()` in Rust, may technically work, they may not be the best practice. For example, it's generally advisable to minimize the use of `.clone()` in order to conserve memory.

If you're unfamiliar with `.clone()`, it essentially copies existing memory into another part of memory and provides a new reference to this new memory. While this might not sound problematic, it can be quite detrimental. For instance, if you clone something that is 1GB in size, you allocate another 1GB within the memory. This could likely be avoided by properly utilizing reference and ownership rules. Another issue is that you could potentially overload the memory, causing your service to crash.

Copilot might suggest using `.clone()`. We could apply this suggestion and proceed. However, instead of doing our job, we may end up relying on a solution provided by an AI that might not understand the real context. This can be problematic. I noticed this happening when I first started learning OCaml. There were instances when I waited for a suggestion, even though the solution was just two lines of straightforward code.

One instance that I recall is when I was parsing a URL. Copilot suggested using Regex, which is not ideal due to its potential for bugs. Instead, I solved it using the following code:

```ocaml
let make ~conninfo =
  let uri = Uri.of_string conninfo in
  let user = Uri.user uri |> Option.value ~default:"" in
```

## Removes the engineering out of software engineering

One of my major issues with Copilot is that it can diminish our problem-solving skills. Instead of analyzing a situation and finding a good solution ourselves, we increasingly delegate this task to AI. Over time, this could diminish our engineering mindset.

For instance, when we encounter a bug, our first instinct might be to ask an AI about the bug, rather than trying to figure it out ourselves. Believe it or not, at this stage, the AI is less capable than you. You may find yourself in a loop where you keep telling the AI, "No, this doesn't work," and the AI keeps suggesting new code. Ironically, the solution could be as simple as changing a single character in the code. 

Another issue is that you might create a solution that, although functional, is subpar due to not leveraging your own skills.

I believe it's common for us to become complacent when AI becomes a significant part of our development process. I experienced this myself recently when I was building SASL authentication for Postgres in OCaml and encountered a tricky bug. Instead of manually inserting print statements into the code to debug, I copied the code and the error and handed it over to ChatGPT. The solution came from a combination of reading [sqlx](https://github.com/launchbadge/sqlx) code and realizing that I had overlooked a small detail.

## We stop learning

As software engineers, continuous learning is essential. We often learn by problem-solving, addressing issues, and devising solutions. However, over-reliance on AI in our development process can hinder this learning. We may apply code without fully understanding it, which can be detrimental in the long run. Just because you used an AI to solve a bug doesn't mean you should rely on it every time a similar issue arises.

This can be a significant issue, especially for new developers. It's crucial that we're able to "feel" the code we're working on. Programming is not just about understanding code; it's about connecting the pieces in the larger puzzle to build a solution and it takes time to understand this and it’s really important in the beginning of the career and also why learning programming takes time.

## We forget how to start

Imagine having a bytestring from which you need to parse values. Ideally, you would do this piece by piece - extract the first value, print it, then move on to the next value. Repeat this process until you've gathered all necessary values. It's common to print the initial data for transparency.

However, as AI becomes more integral to development and begins to handle such tasks for us, there may be situations where starting from scratch becomes challenging due to our reliance on these tools and we’re end up stuck.

One day, we may face a problem that AI can't solve, and we might not know where to start debugging. This is because we're so used to having someone else handle it for us. This is why I always advise new developers to try to solve problems themselves first before asking for help. I want them to understand what they're doing and not rely on me.

## I really don’ think we become more efficient

I also don't believe that we necessarily become more effective by using AI. Often, we might find ourselves stuck in a loop, waiting for new suggestions repeatedly. In such situations, we could likely solve the problem faster, and perhaps even better, by using our own brains instead.

We often associate efficient programming with the ability to produce large amounts of code quickly. However, this isn't necessarily true. A single line of code can sometimes be more efficient and easier to work with than ten lines of code.

AI is effective at generating boilerplate but often falls short in providing quality solutions.

## The end

I've critiqued Copilot for a while, but it's worth mentioning that it's not necessarily bad to use it, provided you choose the appropriate time. I still use Copilot, but only when I'm working on simpler tasks that it can easily handle, like generating boilerplate code. However, I only enable it occasionally. I've noticed that it's crucial not to rely heavily on such tools, as doing so can lead to negative habits, like waiting for a suggestion and hitting enter repeatedly to find a solution.

AI can pose a significant challenge for new developers. It's tempting to let AI dictate the path to a solution, rather than using it as one of many potential paths. This often leads to developers accepting the code returned by AI without truly understanding it. However, understanding the code is essential for new developers.

The easiest way to contact me is through Twitter: https://twitter.com/emil_priver

