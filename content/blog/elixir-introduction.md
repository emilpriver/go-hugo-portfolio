---
date: 2022-11-06T22:53:58+01:00
title: "Elixir: Introduction"
seoTitle: "Introduction to Elixir"
summary: "Introduction to Elixir, What is it, How does it work, What does it ship"
images:
  - https://og.priver.dev/api/og?title=Introduction%20to%20Elixir&bgImage=https://priver.dev/og-images/elixir.jpg
draft: false
tags: ["Elixir"]
categories: ["Elixir"]
cover: images/elixir/elixir.jpg
keywords: ["Elixir", "Introduction to elixir"]
series:
  - Elixir
toc: true
---

I did recently visit a small Elixir and Erlang talk in Varberg, Sweden and I learned some stuff that is something I want to share in this article. The first impression I got was that elixir is a language that is made to be easily understood by developers (short time to get started) but is also built quite smart when it comes to stuff such as spreading running code over multiple cores. But also do elixir have support for releasing a new update to the server without needing to restart the server (hot swap).
Erlang also comes with soft real-time computing meaning that when Elixir is computing real-time data does Elixir allows tasks to be sent after the task's deadline without the system handling the tasks as a failure as long as the task is completed. 

## What is Elixir

Elixir is a functional, concurrent, fault-tolerance and general-purpose programming language running in Erlang VM, built to make it easy to develop scalable and maintainable applications, also a language that gives a guarantee to know if another process is killed or stuck. The language comes with support for hot-swapping code, meaning that you can swap out running code and use the new functionality without interrupting the service. Ericsson did build the language erlang and erlang-VM to be able to hot swap code which is running without interrupting or closing phone calls. With other languages could this mean downtime which is something that telecom can't have as important calls could be active when a bug needs to be fixed urgently. 

Elixir runs your code in lightweight threads when your code is executed, called processes. Each process is isolated but talks (exchange information) to another process via what Elixir calls "Messages". It's not uncommon that Elixir is running 100 thousands of processes concurrently without impacting another process. As all the processes are running isolated, each process has its garbage collection, meaning that 1 process doesn't need to stop other processes from running. In languages such as JavaScript could this mean that the whole script is not running as Node needs to handle its garbage, in elixir case would this mean that the code you are serving your users won't stuck or be slow. This is generally called the actor model. The Actor model is a mathematical model of concurrent computation that treats the actor as the universal primitives of concurrent computation. When an Actor receives a message is it able to make its own decisions such as creating more actors, sending more messages, and telling the system how to respond to the next message. An actor can modify its state but no other process states directly, but can modify other processes states by messaging. As each process can communicate with another process does also Elixir provide fault-tolerance functionality by creating what Elixir calls "supervisors". The supervisor is used to telling the system how to restart parts of your system when things go bad and revert it to its initial state which is guaranteed to work, this is also how Elixir can guarantee fault tolerance. To make Elixir able to run concurrently does it need BEAM or Bogdan Erlang Abstract Machine which is Erlangs Virtual Machine.

Erlangs OTP could you say is a part of the code of Erlang which is providing modules, libraries, and behaviors that represent standard implementations of common practices like message passing or spawning tasks. This means that instead of inventing the wheel again for common services like GenServer, Elixirs OTP provides these tools for you to just grab and use. BEAM uses 1 OS thread per core and runs a scheduler on every os thread to schedule tasks to be executed on that core.


An OTP that Erlang provides which can be used in Elixir is called GenServer. A library that Erlang provides which can be used in Elixir is called GenServer which is a long-running stateful process allowed to send and receive messages. As GenServer or generic server process is that you can keep GenServer always up to date but also execute code async, create a standard set of functions that can be re-used, and also a good way to log errors via GenServer. But it does also provide a good way to handle monitoring events and system messages. GenServer is part of a supervisor and works as a client-server relation between your code and the GenServer. But GenServer is not the only way to work with a state in your application, Erlang also provides ETS or Erlang Term Storage which is a robust in-memory storage store built into OTP which makes it usable within Elixir.  ETS can store large amounts of data available to processes.

Outside of platform and language features does also Elixir provide good tooling features which are built to help you develop your application. The mix is the tool used to create, build, manage tasks, and run tests in your application. But Elixir does also provide tooling to interact with your code, the same way Django has interactive tooling. Here are you able to run different functionality such as code reloading, reading formatted docs, or debugging a problem by executing functions in a shell environment. But these interactive tools are also reachable from a website that enables you to run functionality in your code from a website called Livebook.

## Atoms

An atom is a constant whose value is its name with no static type assigned to the atom as Elixir is a dynamic language. Some of those are defined by the system to create a standard for how the code is running. One of these atoms is ":ok" which can be used to tell a function that the execution of the function was ok and no error happened. To be able to create an atom in another language would you need to create a constant and assign a value to it with a static type. Meaning that a language that is strict on types would probably create problems as you could check if a return value which is a string is the same as a constant which is a number, but with the same data in both the return and the constant.

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

Phoenix is a web framework built on Elixir which implements a server-sided Model View Controller. For people that know what Pythons Django is, then Phoenix is the similarity but for Elixir with some extra features such as LiveView. But it also comes with features such as PubSub and Swoosh which are 2 great libraries providing value when developing your Phoenix application. PubSub is used to develop real-time functionality on your website and Swoosh is a feature to help you compose, deliver and test emails sent from your application. As Phoenix comes with a lot out of the box it makes you able to get up and running fast but also that you don't need to reinvent the wheel as Phoenix has a lot of tools already created for you.

More info about Phoenix [here](https://www.phoenixframework.org/)

### Phoenix's LiveView
The first thought I had when I first did see Phoenix's live view was that it looked like React Server Components which is not the case. It's more like Blazor's live view. Phoenix live view works by listening to a WebSocket which broadcasts messages to the socket telling it to re-render parts of the HTML/template. This means that if you make a change to the server side for example, that an SMS is sent into the system and your users need this information without reloading the page then phoenix can show that message without reloading the page by sending the message into the socket.


## Livebook

Livebook is Elixir's version of Jupyter but with some extra cool functions. Livebook is a library of markdown files where you can add executable Elixir code which can for example be used to discover more about your program or work with data but they also give you LiveView and Beam which allows you to write code in 1 place and re-use it in another place. But also to collaborate in a team within your
Livebook. Livebook is both available to run locally on your machine and also in the cloud to enable multiple people to use the same Livebook server and work together.

Livebook is also able to let you investigate problems within your running project. This means that if your customers are experiencing problems and you want to find out what the problem is, then you can within Livebook test certain functionality even if the application is still serving your users. But also a good way to document your application to enable others in your team to understand and work with your application easier.

More info about Livebook [here](https://livebook.dev/)

## Pattern Matching

I've heard that pattern matching was something good within Elixir, so I looked into it.  In elixir is `=` a match operator which you can compare to the equal sign in algebra, where the goal is that the value on the left side of `=` is the same as the value on the right side of `=`. And if the values match does Elixir return the value, or it throws an error if it fails.

```elixir 
iex> x = 1
1

iex> 1 = x
1

iex> 2 = x
** (MatchError) no match of right hand side value: 1
```

In this example, we see that in the first 2 examples both values did match as 1 `=` x and x `=` 1 but when we tried to check if 2 = x then the execution failed as 2 != 1. Now, this is a basic example that in many other languages works the same, but pattern matching in elixir also works with for example tuples.

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

## Use-cases of Elixir or Erlang in production
There are plenty of use cases for Elixir or Erlang by companies but most of the companies I've seen using the languages in production use it for real-time communication or messages queues and some of these companies are Spotify, Discord, Klarna, Ericsson, and WhatsApp. But Elixir is also popular in e-commerce, banking, advertising, and IoT maybe because it has plenty of libraries and frameworks built on top of it, such as Phoenix. And one of the main reasons is that Elixir handles a lot of traffic concurrently and scales easily due to Erlang's VM. Elixir, on the other hand, will probably not be the fastest choice, but it handles tons of traffic on a high level.

More use-cases at [Elixirs website](https://elixir-lang.org/cases.html)

### Discord

Discord has been using Elixir since the beginning and handling the core of its products which is the chat infrastructure. Discord is a real-time communication service with both voice and messaging support which as of 8 October 2020 handles 100 million active users each month. Elixir was picked to power relaying messages, real-time applications, and Discord's WebSocket which is used for real-time communication within all apps they provide. While Discord uses Python to power its API. While the Python part of the infrastructure is a monolith while the Elixir part has multiple services distributed to multiple servers running each task concurrently with GenServer and GenStage.

### Cars.com

Cars.com is one of the leading platforms for selling cars and buying cars online serving more than 400 million visitors annually. Adopting Elixir as the primary language for its application enabled developers to get started faster and understand the code faster helping cars.com to grow faster and enabling 0 downtimes with a scalable and reliable platform. Cars.com uses Phoenix for its front end enabling Cars.com to show real-time data for its users.

### All Aboard

All Aboard is a Swedish company selling train tickets all over the world.  They use Elixir to run their backend in a pretty cool way. As All Aboard needs to fetch information from multiple APIs could this mean that they need to way a long time for the response they need for their users, and sometimes they fetch APIs returning links to other APIs which need to also be fetched. They solved this by creating a struct that returns 

```elixir
{:async, fn -> fetch_the_other_thing() end}
```
When the whole struct is built do they go through each value and put them into a queue in GenServer which creates tasks with the respective function and executes it and as fast as a new task is done will a new task start. And as fast as they have a new response, they add a new message to their WebSocket which updates user's view.
In this case, does Elixirs Concurrency work really well as some responses could take a really long time and still don't interrupt other tasks that are running.

I did ask Patrik at All Aboard for a comment on what he thought about Elixir and how they use Elixir. Patrik told that as he comes from Python and Ruby and thinks this quite magical because it's easy to understand Elixir, and it's model, but also works really well.

Thanks to Patrik at All Aboard for wanting to share his experience and how he use Elixir. You can find more information about All Aboard on their [website](https://allaboard.eu/)

## My thoughts
I think Elixir is a great language that can handle tons of work at the same time due to its concurrent model but also how easy it is to get started with Elixir and get up and running. I don't think programming should be hard, and many languages make it hard to get up and running quickly, but also hard to write your program in general. This is something that Elixir doesn't have due to the tooling they have created and the way the language is written. Something I don't like is that it doesn't come as required, mostly because I think types help prevent problems and enable us to remove some tests that we don't need to write as we typed them and tested all cases by using the types. On the other hand are you able to use types in Elixir and could set a standard for the project to type the code. 

I think the way I would use Elixir is with real-time data or message queues. For example, building a notification queue for apps and using Elixir to concurrently send all the messages to the devices as I think this would be the best use-case for it, but I want to explore it in more areas than queues.

## Thanks

Thanks to Lars Wikman for the great Elixir talk he had, But also for wanting to read this post and give feedback. Lars is doing great things for the Elixir community. I recommend checking him out at [https://underjord.io/](https://underjord.io/) or his [YouTube](https://www.youtube.com/c/Underjord) 

Also want to thank the community at Kodsnack for answering my questions regarding the language and sharing information on how they use it. Great community with great people.

## End
Do you have any input or stuff I could add or change? I would love feedback! I am using a Twitter post for comments here: [https://twitter.com/emil_priver/status/1589632749446438912](https://twitter.com/emil_priver/status/1589632749446438912)

I want to explore this language more and the next step in this series of Elixir posts will be to test Elixirs concurrency.
