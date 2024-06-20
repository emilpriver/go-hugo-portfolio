---
title: "6 Tips for New Developers"
date: 2024-06-18T13:40:47+02:00
draft: false
toc: true
description: "This article gives some of my tricks for new developers" 
type: "blog"
tags: ["tips"]
cover:
  image: "images/nasa-rocket.jpg"
series:
- tips for new developers
---

I have been programming for various companies for about six years. 

I explored the frontend and e-commerce world while working at Rivercode, gained experience in fintech at Zimpler, and now I am helping the environment at CarbonCloud. Each of these companies has provided me with different experiences and helped me in various ways along my path as a developer.
If I got a dollar for every time someone asked me on social media, in Discord/Slack communities, at meetups, and so on, “I am a new developer, do you have any tips for me to get a job or become a better developer?” I would probably be able to retire at 27 years old (I am 25 now). Most of the time, the answers I’ve given have been well-received and helpful, so I thought I should share some of my insights.

## Grind
The first point is grinding. This is not just about writing code or putting in hours. Grinding is about building experience and learning. Programming is not just about writing code; that's a part of it, but there's much more to it. For instance, understanding the solution you need rather than the solution you want is also part of it, and the only way to achieve this is through experience.

Another important aspect of grinding, similar to learning to play an instrument, is developing your programming muscle memory. This includes learning how to write loops, statements, and the basic syntax of the language you work with, but it also involves understanding the system you work with and how things work. The more you understand how things work, the easier it becomes to find better solutions to problems.

When I’ve talked with recruiters about what they look for in a developer, they rarely mention specific languages or tools. Of course, if you are applying for a data engineering job and you have data warehouse experience, it will probably help you, but it's usually not the most important factor. Recruiters often focus more on your overall experience and your personality.

## Find what you like
The programming world is vast, encompassing many different categories such as frontend engineering, backend engineering, platform engineering, security engineering, and data engineering. Each of these fields is important and focuses on different aspects of programming. Most of the time, companies are not looking for people with experience in multiple fields; they are usually seeking individuals with expertise in a specific area because such people are likely to be highly skilled in that category.

However, having a basic understanding of other fields can be beneficial. For instance, understanding frontend development as a backend developer can help you design better APIs. Similarly, having a basic grasp of platform engineering can help you get your backend services up and running more efficiently, and you can design your backend service to better fit the platform. While having expertise in a specific area is probably the best approach, cross-disciplinary knowledge can enhance your overall effectiveness as a developer. 

I know how to develop websites, but there's more to frontend development than just fetching data, designing, and displaying content. It also involves understanding when to fetch data, ensuring accessibility, and more. While I could probably handle these aspects, I might not excel at them. I prefer working with systems and backends, as that is where my true interest lies.
With the rise of AI, I don’t think AI will replace us. Instead, I believe AI will raise the requirements for developers. It will be less about simply writing code and more about having expertise in specific areas, effective communication, and understanding the real issues that customers, companies, or requesters have. So, don’t think that learning programming is unnecessary because some AI will replace your job.

## Don’t be afraid of failure
This is my absolute favorite topic because it’s where I’ve learned the most. When I worked at Rivercode, I crashed a major webpage for two hours by changing some Cloudflare settings. This incident taught me about DNS looping and cache settings that you can create in the Cloudflare admin. It also showed me the importance of promptly admitting mistakes, as it helps bring a solution faster.

At Zimpler, I crashed the API for 20 minutes when I rolled out a change to the HTTP routing in our platform, causing all traffic to be sent to another service instead of mine. From this, I learned that rolling out changes in the platform should be done in steps.

Another issue I caused at Zimpler was deadlocking the entire production database by forgetting to add CONCURRENTLY to a migration when creating an index. If you forget to add CONCURRENTLY, it locks the entire database, preventing any operations and rendering queries non-functional.

If I gave away $1 for every time I’ve failed at something, I would probably go bankrupt 😊.

Shit happens, and the best thing you can do is:
1. Be honest and explain what happened
2. Understand what went wrong
3. Collaborate on a fix
4. Reflect on the failure to see how you can prevent it next time

People can absolutely be upset when something goes wrong; we’re human, and we have emotions. However, that is an issue with that person, not with you. A good person understands that you probably already feel bad about creating a failure and wants to work together to find a solution. When I took down the API at Zimpler, I asked the platform team for help, and they were super happy to assist. Together, we created a solution, and I learned a lot. My first instinct was to provide information on what happened and to help as much as I could.

We all make mistakes; we’re human. The best thing is that failure is the best teacher you can ever have, so don’t be afraid to mess up from time to time.

## Try to avoid AI
With the increasing use of AI in our daily developer life, I think this is an important topic to discuss. AI is good, but not great. It can write code and provide solutions, but they are often not the best solutions. When we use AI to help solve issues, we offload some of the work from our brains to the AI. The task then shifts from figuring out the issue and testing different solutions to writing a good prompt and waiting for the AI to respond.

Earlier, I mentioned muscle memory. If you ask AI to write code for you, you don't add this information to your muscle memory, so you will probably ask the AI again next time you encounter a similar problem. I believe we learn the least when we ask someone else to do something for us rather than trying it ourselves with some help.

AI can show a path, but not the path. It’s up to you to decide which path to take.

So, is using AI completely bad? No, I think AI has become a more efficient version of Google, helping you find the best Stack Overflow post. The issue lies more in what you do with the information you receive. This “problem” isn’t new; it’s just that obtaining more accurate information has become easier.

Programming is not magical; it has never been and will never be. It only feels magical because you don't understand what's happening in a system. If you ask AI to do stuff for you, you might miss learning how it works, which will only affect you badly in the long term.

Another important thing is learning how to understand systems, meaning that learning how to dig into a system, debug it, and look for information is a valuable skill. Sometimes digging into a new system can be hard, but it's not impossible. If you try to do this yourself rather than asking AI or another person for help, you will get better at learning how to explore systems each time.

## Asking why
This is a topic I’ve loved because I’ve done my best learning when I’ve gotten help from more senior developers by asking “why.” Senior developers become seniors due to their experience, so when you ask “why,” you can get a deeper answer with more insight into the problem.

For instance, instead of just saying, “It’s simpler to build a queue system with your database,” a senior developer might explain, “It’s harder to send messages over SQS and different services because you need to ensure that the payload you create at service A is readable by service B. For example, if field A is sent as a string and service B is expecting a number, you could get an error.

If we keep everything local to our service, we can enforce different types locally.” This detailed answer provides more insights, based on experience, so next time you need to decide between using a queue system like SQS or using the database with each job being a row in a table, you have a better understanding of what solution might work best.

## Ask for feedback if you fail recruitment processes
The last topic I want to discuss is something I haven’t experienced much myself, as I haven’t gone through many recruitment processes, but it’s something I’ve heard is very beneficial if you are looking for a job.

Recruitment processes can be really challenging. You might face questions you don’t have answers to, deal with a lot of nervousness and stress, and experience imposter syndrome. If you fail a process but reach out and ask for feedback, you can gain valuable information about what you need to learn or improve. For instance, if you receive feedback that they are looking for someone who knows Go or Rust, learning these languages might help you if you apply again or for a similar job, as other companies might be looking for the same skills. The best way to understand what companies are looking for in a developer is by asking them directly as they understand their business the best.

## The end
Hope this topic might give you something and I would love to hear other topics that could help new developers. The developer role is lovely and suits everyone 😀

