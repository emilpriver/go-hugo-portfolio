---
title: "I'm Turning AI Optimistic"
date: 2025-07-01T16:40:03+02:00
draft: true
---
I've been an AI pessimist since the rise of LLMs, mainly because they worked quite poorly and everything they generated was quite bad. But also because no one understood how they actually worked. Many people still don't understand AI, and it remains this overhyped thing that's slowly becoming less hyped. Even though LLMs today are still quite bad when compared to humans on coding skills, there are still some things we can use them for to optimize our daily work.

Despite AI still being quite bad and generating poor output, I've become faster at building systems because I'm offloading all the simple stuff to AI so I can focus on the more complicated things. For instance, I recently added bulk endpoints to an existing API and asked AI for help. The job AI did for me involved copying the existing functionality from the non-bulk endpoints, adding goroutines, handling each item in the bulk request independently, and adding channels for success and failure messages. By asking AI for help, I probably saved a day of work, which I think is fantastic. But I do understand developers who say they don't get any improvement from AI, especially those who work at a lower level than I do.

My whole goal has always been to replace all the boring tasks with AI so I can focus on the fun stuff—the more complicated things.

## Finding the Right AI Workflow

For the last year, I've been working on optimizing my setup and the way I write code when using AI, because I do see benefits with it. In this journey, I've tried:

1. **AI-powered IDEs** such as Cursor, but I realized it's dangerous to have something recommending code before you've even thought about what you want to do.
2. **Web-powered tools** such as Gemini or Claude's website, then copying code.
3. **CLIs that work with AI** such as Aider or Opencode.

The only approach that worked for me is using CLI tools, and the reason is that I've realized it's really important that I understand and break down the problem before writing any code. I can't let the AI try to break down the problem for me, which is what happened when I tried an IDE with AI—the AI already suggests code before I've even started thinking.

Another thing I really like about AI is when you want to build something you've never built before. You start the project with zero experience and don't know how to begin. In these scenarios, AI is really good because you can get direction on where to start, even if that direction is really bad. However, it's also important not to let AI do the job for you, because you'll lose out on knowledge.

Even though I mentioned that AI has saved me a day of work from time to time, it's also important to mention that AI makes me lose a day of work from time to time too.

## The Future with AI

It's a fact that AI has changed how we work and what's now required from developers. Before LLMs, it was good enough to have someone who could just code and understood the bare minimum. Now that AI is involved, we also need to understand how systems work because we need to understand what we want to build before we start prompting. AI isn't able to understand how to build a good system unless someone strictly tells it how it should build it in detail—and this isn't something the average founder can do unless they're a software engineer. This means software engineers will still be needed.

Sure, when owners of no-code tools say there are people without any technical skills who have created startups using their tools (like Replit), they've probably used the tool to create a landing page or something similarly simple, which could be created using Wix or similar platforms.

But it's true that we've become faster, and we became faster a long time ago when we started using CLIs to do a bunch of work for us, like getting something up and running. The only difference is that AI tools are now smarter than the CLIs we had, so we can accomplish more. Which is great—let AI keep doing all the boring stuff so we can work on the more interesting things.

With this said, there are some new changes to the software engineer role. It's now required to understand the system and not just write code. We also need to be able to communicate and work as a team (which isn't something new, but it's more important now). This isn't actually something new—it's always been required—but the lower bar has increased, which is one of the reasons it's harder for new engineers to find jobs.

Another thing I've found great is using "Research mode" to find bugs. Sometimes before LLMs, we could spend hours finding information about specific behavior, and using AI we can fetch a bunch of content from the internet and summarize it. Sometimes it saves us hours of work, and sometimes we spend more time searching for an answer.


