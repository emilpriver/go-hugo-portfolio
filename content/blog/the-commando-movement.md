---
title: "The internet cable that birthed the commando movement"
date: 2023-09-20T20:39:17+02:00
draft: false
toc: true
description: Read about the "Phone Call Fiasco" in Sweden's health system and the security breach that exposed private phone calls of Swedish individuals. Discover the chain of events, the lack of accountability, and the coined term "the commando movement.
type: "blog"
tags: ["1177"]
series:
- Swedish Fiascos
images:
  - /og-images/biggest-data-breaches-1.jpg
cover: "images/1177/biggest-data-breaches-1.jpg"
---
This is the story of when Sweden's health system, 1177, had a security breach where private phone calls of Swedish individuals were exposed on the World Wide Web.

It was early 2019, and most Swedes were on their way to work, maybe having coffee, or like me, coding an e-commerce site while enjoying my green monster energy drink. An [article](https://computersweden.idg.se/2.2683/1.714787/inspelade-samtal-1177-vardguiden-oskyddade-internet) published by Computer Sweden revealed that "2.7 million recorded calls to 1177 Vårdguiden were completely unprotected on the internet". According to Computer Sweden, they discovered 2.7 million recorded voice calls on a publicly accessible server dating back to 2013. These calls were made to 1177, the Swedish health system, and contained sensitive information such as diseases or other ailments that callers sought advice for. The callers discussed the medicine they were using, previous treatments, and in many cases, even revealed their national identification number. All this information was openly stored on the internet, accessible to anyone.

When the TV news started to talk about this and more articles were published, I realized that this was a big mess. What happened was that the Swedish government, known as 1177, hired Medhelp to handle the phone calls. Medhelp then subcontracted the work to their partner, Medicall, which is headquartered in Hua Hin, Thailand. According to Computer Sweden, Medhelp uses Medicall during "uncomfortable times" or challenging situations.

During this time, Medicall stored its recorded phone calls (which are legally recorded and used for patient security) on a NAS provided by Voice Integration Nordic AB. The NAS can be accessed at the URL http://188.92.248.19:443/medicall/. The NAS is hosted by Appalion AB, a sister company to Voice Integration Nordic AB. It's important to note that this NAS had direct internet access through an Ethernet cable, without a proper firewall in front. The CEO of Voice Integration Nordic, Tommy Ekström, commented on the network access for the NAS, stating: "someone had inserted an internet cable into the hard drive" source.

Before this [article](https://computersweden.idg.se/2.2683/1.714787/inspelade-samtal-1177-vardguiden-oskyddade-internet) was published, Computer Sweden contacted Medicall's (which no longer exists) CEO, Davide Nyblom, to inquire about the public availability of these files. Davide denied that the files were publicly accessible. When Computer Sweden requested to share a file with Davide, he abruptly ended the call.

While reading this, you might understand why I think this is another Swedish mess. (There is another mess that can be another [article](https://www.svt.se/nyheter/lokalt/stockholm/han-trottnade-pa-skolplattformen-byggde-en-egen-app).)

![Phone calls](images/1177/phone-call-list.jpg)
*Computer Sweden, 2019-02-18, 2,7 miljoner inspelade samtal till 1177 Vårdguiden helt oskyddade på internet. https://computersweden.idg.se/2.2683/1.714787/inspelade-samtal-1177-vardguiden-oskyddade-internet. The image shows the phone calls open for everyone to access.*

## “The commando movement” was born

The meme "the commando movement" originated in Sweden and has gained popularity among tech enthusiasts. It is often used to describe situations where there is a bug and its cause is not understood, or when someone wants to avoid taking responsibility for a bug. It is also used when production servers are down and the CEO of the company asks what in the flippin burgers is going on.  "well, someone made a commando movement and now everything is down.”

The term "[the commando movement](https://it-ord.idg.se/ord/kommandororelse/)" or "Kommandorörelse" in Swedish, was coined by Tommy Ekström, the CEO of Voice Integration Nordic, during an interview with [Dagens Nyheter](https://www.dn.se/ekonomi/ansvarig-for-vardguiden-haveriet-manskliga-faktorn/). Ekström claimed that it would be impossible for "normal persons" to access the server, suggesting that only those capable of a special command move could do so. In reality, all one needed was the correct URL to the server.


## Incompetence

What I'm really curious about is how this could have happened. How could 1177 or the coordinating company not have asked the following questions:

- How does the system actually work?
- Are there any plans to hire more companies?
- Do you record the calls, and if you do, where is the data stored?
- How exactly is the data stored?
- What level of security is in place?

From what I gather, it seems like inexperienced individuals were brought in to solve a tech-related problem for 1177. This likely led to the wrong questions being asked. There was a lot of trust placed in the hired company, but it seems like not enough questions were raised. Another problem is the lack of accountability and preventive measures right from the start.

Unfortunately, incidents like this are not uncommon and may happen again. Sweden has also had a similar issue with an expensive school platform that ended up publicly sharing grades.

## Summary

I am absolutely amazed that these types of things can happen, especially when the buyer is none other than 1177, the Swedish healthcare system. It is truly surprising that people are not able to ask simple questions when purchasing systems. I would have absolutely loved to be in the room when this system was being bought, just to witness firsthand how the ongoing conversation would have unfolded. This story is probably not something new for most Swedish tech personnel reading my blog. But for the worldwide web, this is undoubtedly something that would make you shake your head and think, "What in the flipping burgers are they doing?"

Anyway, I hope you liked this article. If you have any feedback, please reach out to me. The easiest way is via Twitter at https://twitter.com/emil_priver.
