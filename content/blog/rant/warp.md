---
title: "Sign in to view this article"
date: 2024-02-23T22:16:05+01:00
draft: false
toc: true
description: "This post talks about warp terminal and the fact that we need to sign in to write `cd`" 
type: "blog"
tags: ["rant"]
cover:
  image: "images/rant/rant.webp"
---
While reviewing my feeds recently, I discovered that [warp.dev](http://warp.dev/) had launched Warp for Linux. Intrigued, I downloaded and installed the .deb file, launching the application shortly thereafter. I was surprised to find that even basic terminal usage required sign-in, leading me to uninstall the application.

Nevertheless, curiosity prevailed, and I reinstalled the application. Upon signing in, I discovered that even a simple `cd` command required authentication. This unexpected requirement made me question how others might react to such an application.

To provide some context, I am an experienced vim and Linux user who appreciates a clean user interface and a straightforward terminal. I prefer to customize these elements to my satisfaction, which is why I use Alacritty and Fish. My critique of Warp is not about its appearance or functionality, both of which will likely appeal to some users. Rather, the requirement to sign into Warp, while acceptable for others, does not align with my personal preferences.

Although I mention Warp frequently throughout this article, the focus is not solely on this application. Instead, I aim to express my concerns regarding this terminal and explain why I believe these issues warrant serious consideration.

My main concern with Warp is related to security and privacy.

## Background about me

Our conversation today primarily revolves around the Warp terminal, but allow me to introduce myself initially. I have been immersed in the dynamic field of Fintech for close to two years. In our sector, security is not merely an aspect to consider—it is the cornerstone of everything we do. We are entrusted with people's hard-earned money and personal information, hence, taking unnecessary "risks" is not a path we choose to walk. For instance, the practice of sharing tokens to certain APIs via Slack, common in some companies, is unacceptable for us. We rely on a secure vault for such matters. One key lesson from my experience is that relying solely on a database password and ip range does not equate to robust security.

## Security

Warp is a terminal that requires users to sign in, potentially linking each command executed to a specific individual. Given that it's heavily reliant on internet connectivity, and features like Warp AI and Warp Drive, it's possible that the code you write in the terminal could be sent to a Warp-owned server.

I am not suggesting that this is their practice, but I am expressing concern about the potential for such actions. Even on the login page, it states, "Warp collects analytics data used to improve the product." This implies that they are tracking how you use the terminal.

![Sign in screen](images/rant/sign-in-screen.png)

My concern is that, despite Warp's claims of not collecting input or output, I'm not entirely convinced. There's no definitive proof that they don't do this since the code isn't open-source. The only assurance we have is a statement on their website saying they "never collect your input or output data." This statement feels as credible to me as Facebook's claim of caring about my privacy.

![privacy message](images/rant/privacy-message.png)

Ok so now have I ranted a while on that I don’t belive in warps statement about that they don’t store what we write in our terminal, time to explain why I see this is a big issue.

Consider this: every time you write `cd blog`, is that stored somewhere? A simple `cd` might not seem significant, but let me illustrate with a command that I can guarantee many developers use daily.

```ocaml
	DATABASE_URL=postgresql://user:password@host:3307/development migration-tool run-migration
```

We've created a command that contains a "username" and "password". Suppose the terminal stored all your input on a server. This could give them access to your username and password. While it's not certain, it's plausible, especially since they're already tracking analytics data according to the sign-in page.

The primary concern is the potential for unauthorized individuals gaining access to your server if all commands are stored there. We must also accept the possibility of a future security breach, and plan accordingly. Ignoring this risk would be unwise.

As we’re also talking about a terminal is it hard to use encrypted values within the terminal as if you for instance use a encrypted password rather then the plain-text password could this mean that the authentication won’t work so in most cases do you need to 

## Privacy

The next topic is privacy. Picture your written content being stored and collected somewhere. Consider that the responses you get from your curl could be archived. Imagine someone observing as you ask ChatGPT how to move a file. The idea that someone could monitor your every move is quite absurd specially when we talk about a terminal.

## The end

To end this do I want to clearify that in this particualar case may I talk a lot about warp, however there could be more apps like Warp that does the same kind of things. 1

![faq](images/rant/faq.png)

I've read about Warp's stance on open-source and there's no guarantee that they will open-source everything in the terminal. Regarding this topic, they state, “We are planning to open-source parts and potentially all of the terminal. We want to allow folks to audit our code and tweak Warp.” This statement doesn't guarantee that it will be open-source, which makes me hesitant to trust something I can't build myself from source.

Moreover, I have yet to hear a convincing reason why a terminal must be entirely cloud-based. I understand that specific features, such as AI, necessitate a login, but is that necessary for all functions? They assert on their [FAQ](https://www.warp.dev/faq) page that even sites like Github require sign-in. While this isn't entirely accurate, since I can view public Github repositories without signing in, I can accept needing to sign in to access app functions that require authentication. However, I fail to see why I need to log in merely to execute a basic `cd` command.

In any case, I hope you, as the reader, understand my point and why I'm concerned about this terminal.
