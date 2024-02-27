---
title: "Don't Use Ai and Code"
date: 2024-02-27T16:41:53+01:00
draft: false
toc: true
description: "This posts talks about why I don't like using AI for programming" 
type: "blog"
tags: ["rant"]
cover:
  image: "images/rant/ai.jpg"
---

Not long ago, I wrote a small function in OCaml that took a string and returned a record containing the username, password, host, port, and schema from that string. During this process, I received a suggestion from Copilot.



![Copilot code suggestion](images/rant/copilot-suggestion.jpeg)

The large amount of code that copilot gave me to parse a string got me thinking about the use of AI in programming. Specifically, how developers incorporate AI into their routine coding tasks and its impact on new developers. This post is primarily for new developers, and I want to caution against relying on AI, especially while learning to code. But first, let me introduce you to a common ally of many programmers - the Stack Overflow programmer.

A Stack Overflow programmer is someone who encounters a problem, searches for a solution on Stack Overflow, then copies and pastes the solution directly into their codebase without fully understanding what the code does or considering if there's a better approach.

While this may not necessarily be an issue, it could potentially become one, which I will discuss shortly.

## The new AI developer

Let's discuss new programmers, those who haven't been programming for long and are relatively new to the market with limited experience. They often use services like ChatGPT to find solutions. The issue isn't their inexperience, but rather their limited understanding of the quality of code or solutions provided by ChatGPT or similar services.

Programmers might not fully grasp that the role of AI services, like Copilot, is to generate a potential answer rather than a guaranteed correct one. The AI can produce a response related to the query, but it could also generate unrelated or inaccurate responses. This might not be immediately evident to everyone.

Furthermore, Copilot's function is to find code written by the community on Github and suggest it to the user. Essentially, it is a tool that matches boilerplate code with your existing code. However, the suggested boilerplate code doesn't necessarily solve the same problem you're trying to address. Copilot's main job is to provide code suggestions, not guaranteed solutions.

> By the way, Copilot suggests code based on the community, so if you believe that Copilot is suggesting poor code, remember that the suggested code is written by programmers in that community.
> 

I mention this to emphasize that there is a significant risk associated with AI-generated code. The AI may produce a response in the requested language, but the resulting code could be poorly crafted. Developers may not recognize this issue and could inadvertently incorporate the code into their codebase without fully understanding its function.

Here's an example of OCaml code that I believe could be improved. The task was to extract the host, port, username, and password from this PostgreSQL URL: `postgresql://postgres:mysecretpassword@localhost:6432/development`. However, I found the code provided by [ChatGPT](https://chat.openai.com/share/891a0dfe-2e23-45f4-9380-ae6a4cafa231) unsatisfactory:

```ocaml
open Str

(* Define a type to hold the extracted components *)
type url_components = {
  username: string;
  password: string;
  host: string;
  port: int;
  database: string;
}

(* Function to parse the URL and extract components *)
let parse_pg_url url =
  let regex = Str.regexp "postgresql://\\\\([^:]+\\\\):\\\\([^@]+\\\\)@\\\\([^:]+\\\\):\\\\([0-9]+\\\\)/\\\\([^/]+\\\\)" in
  if Str.string_match regex url 0 then
    let username = Str.matched_group 1 url in
    let password = Str.matched_group 2 url in
    let host = Str.matched_group 3 url in
    let port = int_of_string (Str.matched_group 4 url) in
    let database = Str.matched_group 5 url in
    Some { username; password; host; port; database }
  else
    None
```

Now, imagine you're a new developer without much experience, and you don't understand how regex works. You might see this as a solution, and it may get the job done, but how good do you think this code is? In my opinion, using regex to solve this isn't ideal, and I wouldn't approve the PR. However, I don't think a new programmer would understand this.

Instead I would develop the same function like this:

```ocaml
let ( let* ) = Option.bind

type t =
  | ConnectionInformation : {
      host: string;
      port: int;
      username: string;
      password: string;
      schema: string;
    }
      -> t

let of_string connection_info =
  let parsed_url = Uri.of_string connection_info in
  let* host = Uri.host parsed_url in
  let* port = Uri.port parsed_url in
  let* username = Uri.user parsed_url in
  let* password = Uri.password parsed_url in

  Some
    (ConnectionInformation
       { host; port; username; password; schema = "postgresql" })
```

I am using OCaml's `Uri`, which follows a protocol for URIs, to parse the URI. This is a much better solution.

## Not understanding code

This issue isn't new; it existed even during the pre-ChatGPT era, albeit on a smaller scale with platforms like Stack Overflow. However, with AI, we receive responses much faster, eliminating the need to sift through numerous Stack Overflow pages or read extensive documentation. The problem with not understanding the code isn't just an increase in skill gaps, but also a potential influx of bugs and poorly devised solutions, without even realizing it.

## Being a lazy developer

In this article, the term "lazy developer" refers to those who rely heavily on AI tools like Copilot and ChatGPT to solve problems without much personal thought or effort. This reliance on AI isn't inherently bad, but excessive use can lead to dependency.

A common scenario is when a developer waits for an AI response to a problem instead of trying to solve it independently. This habit could lead to over-reliance, and the developer might lose the ability to solve problems without AI assistance. An important point to note is that AI may not fully understand the context of the problem or the project.

This could transform into a scenario where you depend on AI to even begin solving a problem, as you've forgotten how to initiate the problem-solving process. While using AI isn't inherently bad, it's essential to remember that AI isn't **the** solution, but rather **a** solution. It can be part of your problem-solving strategy, but the real solution should come from your own efforts and experimentation.

## How you should use AI

I have shared why I am not a fan of using AI for development. Now, I want to discuss how I recommend using AI in the development process. I suggest using AI as a tool for exploring potential solutions. Instead of asking AI to generate code, like "give me code that parses this string," I would ask "what ways would you parse this string?" This approach might reveal a new, possibly better, path.

Another example is, suppose you've identified three potential solutions to a problem. You could then consult an AI like ChatGPT to see if it can suggest additional solutions, potentially adding two more paths to your list. Therefore, rather than directly providing the solution, AI can serve as a tool for suggesting possible solutions.

## The end

Thank you for reading this. I hope it has given you a fresh perspective on AI and programming. I penned this when I realized that, as a developer, I was becoming overly dependent on AI. This led to a decrease in my learning due to complacency. Consequently, I decided to remove Copilot entirely.

If you have any feedback or comments, please don't hesitate to contact me at https://twitter.com/emil_priver.

