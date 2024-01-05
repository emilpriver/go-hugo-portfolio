---
title: "Rust may not be cheaper for companies"
date: 2024-01-05T18:34:32+01:00
draft: false
toc: true
description: "In this blog post, the author explores the overall costs of using Rust for companies, beyond just server resources. The post discusses factors such as development time, the availability of Rust developers, the learning curve of Rust, the size of the Rust community, and the need for resources and support during the transition to Rust. The author aims to provide insights into the cost comparison between different programming languages and encourages a friendly discussion on the topic." 
type: "blog"
tags: ["rust"]
series:
- Rust
images:
  - /og-images/rust-og.jpg
---

A while back, [shuttle.rs](http://shuttle.rs/) published a blog post discussing the benefits of using Rust. In one section, they mentioned that Rust is more cost-effective for companies in terms of server resources, and I completely agree with that. However, the purpose of this post is to provide more insights into the overall costs of using Rust and determine if it truly offers greater affordability for companies. I want to emphasize that this is not meant as criticism towards [shuttle.rs](http://shuttle.rs/); in fact, I am a happy user of their service and genuinely appreciate the value they provide. I am a big fan of Rust and enjoy using it whenever possible, but I also understand when it's more suitable to use other languages. It's also important to mention that this post does not apply to FAANG companies, as their cost considerations differ, which I'll explain further.

For a company, costs extend beyond just servers; they also include expenses such as hiring engineers and the time required to release products, among other factors.

It's widely recognized that Rust is more cost-effective in terms of servers and resources compared to languages like Go and JavaScript. This is mainly because Rust requires fewer resources to operate efficiently. Consequently, deploying with Rust instead of JS allows us to handle the same amount of traffic with fewer servers, which is a significant advantage.

Another crucial point to consider is that I reside in Sweden. When comparing the job market and salary perspectives, it's important to note that we can't directly compare the Swedish/EU market to the US market. Moreover, my personal experience with the language may also differ.

The first argument to consider is that the cost for a company isn't solely limited to servers; it also includes engineer salaries, hiring processes, and the size of the language community. If we compare a JS backend service to a Rust backend service, it's important to acknowledge that the same engineer can often develop something in JS much faster than in Rust, and there are valid reasons behind this.

##  High development time do cost companies more

A typical salary in Sweden is 45,000 SEK per month, and we usually get paid for 160 hours of work each month. This means that the hourly rate is 281 SEK. In this example, we have a list of 10 todos. Let's assume each todo takes 40 hours, which would cost the company approximately 112,400 SEK ((10 todos * 40 hours) * 281 SEK/hour) for these 10 todos.

Now, if we were to do the same todos using JavaScript, each todo might take around 24 hours since developers don't have to struggle with the compiler (even if you are extremely fluent in Rust, it still takes longer to write a Rust project). This would mean that the same todos in a JavaScript codebase could cost the company 67,440 SEK ((10 todos * 24 hours) * 281 SEK/hour). That's almost half the price for the same result but in different languages.

I strongly believe that if we take into account the cost of the resources needed to run a JS server, it could be lower than the cost of writing it in Rust plus the resources required to run the Rust app.

Something important to know is that the example I just provided is mainly meant to demonstrate that the time required to write a solution or make a change comes at a cost, and we need to be aware of it.

## Harder to find rust developers

If you're not a FAANG company or a company of high status, it can be more difficult to find talented developers. Many developers aspire to work at these big companies because they often offer very high salaries and bring prestige. During challenging times in the market, most companies prefer to hire senior developers who require less training and can bring more value due to their experience. Senior developers are aware of this and use it to negotiate higher salaries, which is understandable. Additionally, the market for Rust developers is smaller compared to the markets for JavaScript and Go developers. As a result, Rust developers tend to ask for even higher salaries because they know they face less competition compared to developers in other languages.

If you browse job pages within Sweden and the EU, you will probably see more job openings for Go rather than Rust, as Go was built to solve the problems I write about in this post.

## It takes longer time to learn rust

Learning Rust can be a bit time-consuming, especially if you're used to working with garbage-collected languages. However, with some effort and practice, you can develop a solid understanding of how to manage memory and work with the Rust compiler.

If a company is considering hiring a Rust developer without prior experience, it's important for them to be ready to offer the necessary time and support for the developer to become skilled in Rust and grasp its intricacies. It's worth mentioning that this transition period might involve some additional costs and temporarily lower productivity, as the developer needs time to learn how to effectively work with the Rust compiler and make changes to the codebase. It's important to acknowledge that this learning curve is not unique to Rust; other low-level languages could also pose a challenge for experienced developers.

## Community is not as big

The Rust community, though not as large as the communities of Go and JavaScript, is still vibrant and supportive. While there may be fewer open-source projects and developers offering solutions to common development challenges, there are still valuable resources available. If you need a library to add support for a specific functionality, it may be easier to find one in a larger community. Additionally, a larger community makes it easier to find solutions to errors and issues, as others may have already encountered and resolved similar problems. It is important to note that searching for Rust-specific solutions may require some extra time and effort, but the benefits of a strong and dedicated community make it worthwhile.

## .unwrap()

Time to unwrap this post! The goal here is to have a friendly discussion about the cost comparison between different programming languages from a broader perspective. I'm writing this post not because Shuttle wrote that paragraph in their post, but because I frequently come across this argument in real life, on Twitter, and in other forums. I strive to be transparent about this topic, for example, when discussing Rust in [podcasts](https://kodsnack.se/563/).

I want to clarify that this post is not meant to make one language seem better than another. It simply represents my thoughts and reflects my experience on this topic.

I am eagerly looking forward to the growth of the Rust community, hopefully reaching the size of languages like JavaScript or Go. This would greatly benefit companies by enabling them to hire more Rust developers and further embrace the Rust community. It's delightful to see more companies wanting to contribute to the growth of the community and actively seeking Rust developers.

Anyway, I hope you enjoyed this post. If you'd like to discuss it further, the easiest way to reach me is through Twitter at https://twitter.com/emil_priver. I'm always happy to have a conversation! 😀
