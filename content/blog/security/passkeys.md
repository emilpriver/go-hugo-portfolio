---
title: "Passkeys - The password killer"
date: 2023-07-21T12:03:22+02:00
draft: false
toc: true
description: "This article explores the future of passwords and the potential replacement of traditional username and password authentication with PassKeys. PassKeys use biometric sensors, a PIN, or a pattern to authenticate users, making it easier and more secure to sign in. The article discusses the benefits of PassKeys over traditional passwords, potential risks, and the future of authentication." 
type: "blog"
tags: ["security", "passkeys"]
cover:
  image: "/og-images/apple-passkeys.png"
series:
- passkeys
---

You may be skeptical of the title, thinking, "What kind of drug is this guy on and where can I get it?" But rest assured, it's not clickbait. The title describes the future of passwords that we are moving towards. We're talking about PassKeys, the potential killer of passwords, which can be found at https://www.passkeys.com/.

The biggest problem with passwords today is that people tend to create weak ones. We want passwords that are both memorable and secure, but we often choose passwords that are easy to guess, such as the name of our pet and the year it was born, with maybe a "!" thrown in for good measure.

Unfortunately, many Swedish schools and municipalities still use "Sommar2023" as the default password, and most employees don't bother changing it. This lack of good passwords also costs companies money as they need to deal with leaks. The overall security is not as good as it could be due to users not picking strong passwords, which is beyond the control of the companies.

To prevent people from being hacked due to weak passwords, some companies have developed password managers that store passwords securely so that users don't have to remember them. Apple has built this feature into its products, prompting users to create and store a password whenever they create a new account. Other companies, such as 1Password, offer similar solutions. To enhance security, we use two-step authentication, which requires an additional login step. However, some users still skip enabling it due to laziness.

![Sign in new password](/images/security/change-password.png)

To solve this issue, we need to create an easy and efficient way to handle authentication. One potential solution is the use of PassKeys.

## What is Passkeys

PassKeys is a new method of authentication that replaces the traditional username and password approach. Instead, users authenticate themselves using biometric sensors (such as fingerprint and facial recognition), a PIN, or a pattern. This allows the device to generate a new passkey, which consists of a pair of two keys: one private and one public.

The private key is designed to be stored on the device in a vault that requires two-factor authentication to access, while the public key is sent over the internet to a server for storage. When a user attempts to sign in using PassKeys, the server creates a challenge that is sent to the device. The private key then verifies and signs the challenge, and the response is sent back to the server for verification. This ensures that the user is indeed who they claim to be, and not an imposter. 

Using passkeys makes it easier and smoother for users to sign in, as it removes a lot of overhead. For inexperienced users, this means they can press a button to trigger device verification (for example, facial recognition), which then triggers authentication and sign-in. This flow is not new; for example, Swedish BankID is used to sign users into banks and other services. Users press a button, which sends them to an app on their device, where they authenticate using a PIN or biometric sensor, and then return to the website or app to complete the sign-in process. This process is both smooth and secure.


![Apple Passkeys](/images/security/apple-passkeys.png)

*Passkeys, a tech designed to replace relatively insecure passwords, let you log in with a fingerprint or face ID.
[Apple](https://developer.apple.com/passkeys/)* 

Passkeys do not need to be tied to your device. The only requirement is that they should be stored in a secure vault. As a result, services such as 1Password can generate and store passkeys in their vault and sync them between your devices, allowing for easy login access across all devices.

## Leaks

Currently, handling leaks when passwords are compromised is a significant undertaking. Users must be notified to create new passwords. However, there are several ways in which this can be accomplished. One approach is to provide users with tools to strengthen their passwords, such as password managers or two-factor authentication. Another approach is to educate users on how to create strong passwords, such as using a combination of upper and lower case letters, numbers, and symbols.

In contrast, passkeys offer a more secure alternative to passwords since servers only store public keys. This means that even if a leak were to occur, hackers would not be able to access private data. However, there are still potential risks associated with passkeys, such as the possibility of a man-in-the-middle attack. Therefore, it is important to take measures to ensure the security of passkeys, such as encrypting them during transmission and storing them securely on the user's device.

## The future

Some companies are already advising their users to create passkeys and remove passwords for their services. Passkeys are used for authentication instead of passwords. Microsoft is one company that is actively promoting this approach (source: [Microsoft](https://techcommunity.microsoft.com/t5/microsoft-entra-azure-ad-blog/expansion-of-fido-standard-and-new-updates-for-microsoft/ba-p/3290633)).

As passkeys become more widespread, we can expect more companies to adopt this method and remove passwords in the coming year. Additionally, we anticipate that more libraries will be developed for developers to easily implement this type of sign-in flow. It is possible that we may no longer consider developing a traditional username and password flow, in favor of passkeys.

## The end

I started to discover more about passkeys when I began working on my vacation hobby project, Yummi Analytics. Yummi Analytics is a Google Analytics replacement where I plan to use passkeys whenever possible.

This post is the first in a series about Passkeys. The next part will cover integrating and developing Passkeys.

If you would like to try Passkeys now, click on this link: [https://passkeys-demo.appspot.com](https://passkeys-demo.appspot.com/)

I hope you enjoyed the article and learned something new! :D

