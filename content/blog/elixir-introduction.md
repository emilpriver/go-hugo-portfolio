---
title: "Elixir: Introduction"
date: 2022-11-05T11:13:20+01:00
seoTitle: "Introduction to Elixir"
summary: "Generate a sitemap.xml after Nextjs 9.4 update. Works with getServerSidedProps, getStaticProps update"
images:
  - https://og.priver.dev/api/og?title=Introduction%20to%20Elixir
draft: true
tags: ["Elixir"]
categories: ["Elixir"]
keywords: ["Elixir", "Introduction to elixir"]
series:
  - Elixir
---
![](images/elixir/elixir.jpg)

I did recently visit a small Elixir and Erlang talk in Varberg, Sweden and I learned some stuff that is something I want to share in this article. The first impression I got was that elixir is a language that is made to be understood by developers easily (short time to get started) but is also built quite smart when it comes to stuff such as spreading running code over multiple cores. But also do elixir have support for releasing a new update to the server without needing to restart the server (hot swap)

## What is Elixir

Elixir is a functional, concurrent, fault-tolerance and general-purpose programming language running in Erlang VM build to make it easy to develop scalable and maintainable applications, also a language that gives a guarantee to know if another process is killed or stuck. The language comes with support for hot-swapping code, meaning that you can swap out running code and use the new functionality without interrupting the service. Ericsson did build the language erlang and erlang-VM to be able to hot swap code which is running without interrupting or closing phone calls. With other languages could this mean downtime which is something that telecom can't have as important calls could be active when a bug needs to be fixed urgently. 

Elixir runs your code in lightweight threads when your code is executed, called processes. Each process is isolated but talks (exchange information) to another process via what Elixir calls "Messages". It's not uncommon that Elixir is running 100 thousands of processes concurrently without impacting another process. As all of the processes are running isolated each process has its garbage collection, meaning that 1 process doesn't need to stop other processes from running. In languages such as Javascript could this mean that the whole script is not running as Node needs to handle its garbage, in elixir case would this mean that the code you are serving your users won't stuck or be slow. As each process can communicate with another process does also Elixir provide fault-tolerance functionality by creating what Elixir calls "supervisors". The supervisor is used to telling the system how to restart parts of your system when things go bad and revert it to its initial state which is guaranteed to work, this is also how Elixir can guarantee fault tolerance. Elixirs concurrency is called BEAM or Bogdan Erlang Abstract Machine and is part of Erlang's OTP. 

Erlangs OTP is a big part of the Erlang ecosystem providing modules and behaviors that represent standard implementations of common practices like message passing or spawning tasks. This means that instead of inventing the wheel again for common services like GenServer, Elixirs OTP provides these tools for you to just grab and use. BEAM uses 1 os thread per core and runs a scheduler on every os thread to schedule tasks to be executed on that core.

Elixir does also allow you to share states between process in a system Elixir call "GenServer". GenServer is like all other Elixir processes but is to be allowed to be accessed by all other processes. As GenServer or generic server process is that you can keep GenServer always up to date but also execute code async, create a standard set of functions that can be re-used, and also a good way to log errors via GenServer. But it does also provide a good way to handle monitoring events and system messages. GenServer is part of a supervisor and works as a client-server relation between your code and the GenServer.

Outside of platform and language features does also Elixir provide good tooling features which are built to help you develop your application. The mix is the tool used to create, build, manage tasks, and run tests in your application. But Elixir does also provide tooling to interact with your code, the same way Django has interactive tooling. Here are you able to run different functionality such as code reloading, reading formatted docs, or debugging a problem by executing functions in a shell environment. But these interactive tools are also reachable from a website which enables you to run functionality in your code from a website. Elixir has a project called "Livebook" which is an application that talks to your Elixir code and make you able to execute code in your codebase.

## Atoms

An atom is a constant whose value is its own name. Some of those are defined by the system to create a standard for how the code is running. One of these atoms is ":ok" which can be used to tell a function that the execution of the function was ok and no error happened. To be able to create an atom in another language would you need to create a constant and assign a value to it with a static type. Meaning that a language that is strict on types would probably create problems as you could check if a return value which is a string is the same as a constant which is a number, but with the same data in both the return and the constant.

```elixir
iex>:apple
:apple

iex>:orange
:orange

iex>:apple == :apple
true

iex>:apple == :orange
false
```


## Phoenix

Phoenix is a web framework built on Elixir which implements a server-sided Model View Controller. For people that know what Pythons Django is, then Phoenix is the similarity but for Elixir. The first thought I had when I first did see Phoenix's live view was that it looked like React Server Components which is not the case. It's more like Blazors' live view. Phoenix live view works by listening to a WebSocket which broadcasts messages to the socket telling it to re-render parts of the HTML/template. This means that if you make a change to the server side for example, that an SMS is sent into the system and your users need this information without reloading the page then phoenix can show that message without reloading the page by sending the message into the socket.

More info about Phoenix [here](https://www.phoenixframework.org/)

## Livebook

Livebook is Elixir's version of Jupyter but with some extra cool functions. Livebook is a library of markdown files where you can add executable Elixir code which can for example be used to discover more about your program or work with data but they also give you LiveView and Beam which allows you to write code in 1 place and re-use it in another place. But also to collaborate in a team within your
Livebook. Livebook is both available to run locally on your machine and also in the cloud to enable multiple people to use the same Livebook server and work together.

Livebook is also able to let you investigate problems within your running project. This means that if your customers are experiencing problems and you want to find out what the problem is, then you can within Livebook test certain functionality even if the application is still serving your users. But also a good way to document your application to enable others in your team to understand and work with your application easier.

More info about Livebook [here](https://livebook.dev/)

## Pattern Matching

I've heard that pattern matching was something good within Elixir so I looked into it. Pattern Matching in Elixir is that both values left of "=" and right of "=" should be the same.

```elixir 
iex> x = 1
1

iex> 1 = x
1

iex> 2 = x
** (MatchError) no match of right hand side value: 1
```

In this example, we see that in the first 2 examples both values did match as 1 = x and x = 1 but when we tried to check if 2 = x then the execution failed as 2 != 1. Now, this is a basic example that in many other languages works the same, but pattern matching in elixir also works with for example tuples.

```elixir
iex> {a, b, c} = {:hello, "world", 42}
{:hello, "world", 42}

iex> a
:hello

iex> b
"world"

iex> {a, b, c} = {:hello, "world"}
** (MatchError) no match of right hand side value: {:hello, "world"}
```
Meaning that we can use this when we for example want to match the return value of a function. We are also able to pattern match on lists.

```elixir
iex> [a, b, c] = [1, 2, 3]
[1, 2, 3]

iex> a
1
```

And we can use a pipeline to add the rest of the values to 1 variable

```elixir 
iex> [head | tail] = [1, 2, 3]
[1, 2, 3]
iex> head
1
iex> tail
[2, 3]
```

And append values to an array in an easy way with the pipeline

```elixir
iex> list = [1, 2, 3]
[1, 2, 3]

iex> [0 | list]
[0, 1, 2, 3]
```

But Elixir also supports the pin operator which is used to do pattern matching to a variable with an existing variable rather than rebinding the variable.

```elixir
iex> x = 1
1

iex> ^x = 2
** (MatchError) no match of right hand side value: 2
```

As we did earlier pinned value of x to 1 is the equivalent of the following code

```elixir
iex> 1 = 2
** (MatchError) no match of right hand side value: 2
```

## Use-cases of Elixir in production
There are plenty of use cases for Elixir by companies but most of the companies I've seen using Elixir in production use it for real-time communication or messages queues and some of these companies are Spotify, Discord, and WhatsApp. But Elixir is also popular in e-commerce, banking, advertising, and IoT. And one of the main reasons is that Elixir handles a lot of traffic concurrently and scales easily due to Erlang's VM. Elixir, on the other hand, will probably not be the fastest choice but it handles tons of traffic on a high level.

More use-cases at [Elixirs website](https://elixir-lang.org/cases.html)

### Discord
Discord has been using Elixir since the beginning and handling the core of its products which is the chat infrastructure. Discord is a real-time communication service with both voice and messaging support which as of 8 October 2020 handles 100 million active users each month. Elixir was picked to power relaying messages, real-time applications, and Discord's WebSocket which is used for real-time communication within all apps they provide. While Discord uses Python to power its API. While the Python part of the infrastructure is a monolith while the Elixir part has multiple services distributed to multiple servers running each task concurrently with GenServer and GenStage.

### All Aboard
All Aboard is a Swedish company selling train tickets all around the world by searching different APIs and calculating the best route. All Board uses Elixir for their backend, allowing them to wait for a response at APIs which are slow without interrupting other users that want to use their system at the same time.
TBA

## My thoughts
I think Elixir is a great language that can handle tons of work at the same time due to its concurrent model but also how easy it is to get started with Elixir and get up and running. I don't think programming should be hard and many languages make it hard to get up and running quickly, but also hard to write your program in general. This is something that Elixir doesn't have due to the tooling they have created and the way the language is written. Something I don't like is that it doesn't come as required, mostly because I think types help prevent problems and enable us to remove some tests that we don't need to write as we typed them and tested all cases by using the types. On the other hand are you able to use types in Elixir and could set a standard for the project to type the code. 

I think the way I would use Elixir is with real-time data or message queues. For example, building a notification queue for apps and using Elixir to concurrently send all the messages to the devices as I think this would be the best use-case for it.

## Thanks
Thanks to Lars Wikman for the great Elixir talk he had, But also for wanting to read this post and give feedback. Lars is doing great things for the Elixir community. I recommend checking him out at [https://underjord.io/](https://underjord.io/) or his [Youtube](https://www.youtube.com/c/Underjord) 

Also want to thank the community at Kodsnack for answering my questions regarding the language and sharing information on how they use it. Great community with great people.

## End
Do you have any input or stuff I could add or change? I would love feedback! I am using a Twitter post for comments here:
