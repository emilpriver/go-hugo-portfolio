---
title: "Building a Connnection Pool for DBCaml on top of riot"
date: 2024-02-19T12:00:23+01:00
draft: false
type: "blog"
tags: ["Ocaml"]
cover:
  image: "images/poolparty.jpeg"
series:
  - Ocaml
toc: true
description: "This article talks about how I wrote the connection pool for DBCaml"
---
While developing DBCaml, I needed to build a connection pool to manage all the connections to the database. This allows us to create a pool of connections that can be used by multiple processes to send queries to the database and then return the connection back to the pool. In this post, I will provide a more in-depth explanation of how the pool, named PoolParty, looks and functions. It's important to note that DBCaml is currently in an unstable version (v0.0.1), so there may be changes in the future. I will make an effort to update this article with any significant changes we make.

Now, let's dive into the background of how the connection pool in DBCaml, or PoolParty, works. When I started the DBcaml project, I initially tried to write everything in a non-functional way because I had more experience with Rust and Go. However, when implementing the connection pool, I needed to rethink my coding approach to fit a more functional style. The first version of the pool didn't meet our expectations because I had written the functionality to resemble an HTTP backend rather than a connection pool. The main difference between the two is that an HTTP backend can terminate a process after handling a socket connection, whereas a connection pool needs to persist the connection. Otherwise, we would create a new connection for every request to the database, which is not what we want.

So when I realized that I needed to rewrite the functionality for the pool, I reached out to [Leostera](https://twitter.com/leostera), the author of Riot, which is the core actor-model DBCaml uses to operate. I asked for help, and together we decided to study Elixir's [ecto](https://github.com/elixir-ecto/ecto) and how it's connection pool was implemented. This gave me a clearer understanding.

> Before I continue discussing the pool, I want to give a big shoutout to Leostera for all the help. It has been an amazing experience, and you are extremely talented! You can follow Leandro on [Twitter](https://twitter.com/leostera) or on [Twitch](https://www.twitch.tv/leostera).
> 

## Terms that will be good to understand

This section will include descriptions of some terms used in this article to make it easier to follow along when discussing the pool.

### Supervisor

A supervisor is something that controls processes, if a process dies do the supervisor need to know how to start it up again and it’s done via providing a initial state to the supervisor for the child it’s holding

### Supervisor child

It's something that the supervisor controls and keeps an eye on. The child is responsible for taking the action, while the supervisor ensures that it doesn't fail. You can imagine it looking something like this:

![Supervisor children](images/poolparty/supervisor.png)

### Riot

An actor-model multi-core scheduler for OCaml 5. When discussing actor-models, Erlang and the Beam are often mentioned. The Beam is a component of Erlang that controls all the processes created. The main difference between the Beam and Riot is that Riot only operates on a single machine, whereas the Beam can manage multiple hosts. Another distinction is the programming language they are built on. Despite these differences, Riot aims to emulate the capabilities of the Beam, as I understand it.

### Process

In computing, a process is the instance of a computer program that is being executed by one or many threads.

### Holder

A holder in this context is something that hold something and give it away when needed. Imagine that you are a holder and you hold a box and you don’t know what is inside the box but you hold something and when someone asks for it do you give it away. This  is the idea of a holder in the pool

### Pool manager

A pool manager is responsible for controlling and managing all the holders. It can be likened to a team lead in a development scenario. Just as a team lead takes care of background tasks such as meetings and communication with sales, the pool manager is responsible for responding to messages and knowing the current state of the holder in this context.

The pool manager in DBCaml is called PoolParty.

## How it works

![Poolmanager](images/poolparty/poolmanager.png)

What you are currently looking at is an explanation of how the pool works in real-time. Please note that this information may change, and if any changes occur, I will update the DBCaml documentation page at [https://dbca.ml](https://dbca.ml/).

Here are some clarifications:

- In this context, "App" refers to your program, the code you write, and the code that calls DBCaml.
- "PoolParty" is the name for the connection pool in DBCaml. The idea is to separate PoolParty into its own library, allowing developers to use it independently of DBCaml. For example, it could be used as a Redis pool.
- "Holder" refers to an item in the connection pool. A holder stores some data, but it shouldn't be aware of what it is holding. It is up to the app to know the details (more about this will be explained later).

### Creating the pool

In the schema above, the app creates a new pool and receives a pool manager PID (Process ID). Once it obtains the PID, the app starts registering all of its holder items, which in the context of DBCaml refers to all the connections. An example of what this code could look like is provided below:

```ocaml
(*Create the pool manager*)
let pool_id = Poolparty.start_link ~pool_size:connections in

(* Add new holders to the pool *)
  let pids =
    List.init connections (fun _ ->
        let pid =
          spawn (fun () ->
              match Driver.connect driver with
              | Ok c -> Poolparty.add_item pool_id c
              | Error _ -> error (fun f -> f "failed to start driver"))
        in

        pid)
  in
(*wait before all items are added to the pool before we continue *)
  wait_pids pids;
```

Under the hood, PoolParty spins up a supervisor that controls the pool manager. The pool manager waits for messages to be added to its mailbox and handles each message as it receives them.

### Register items

When an app registers a new item to the pool, PoolParty stores the item in a local in-memory table, which is currently implemented using `Hashtbl`. After the item has been added to the `Hashtbl`, the holder item starts a Supervisor and a process. It then retrieves the process ID (PID) and sends it to the connection manager in a `CheckIn` message. The purpose of the `CheckIn` message is to either add the PID to the memory or change the state in the memory table to `Ready`.

Once the `CheckIn` message has been handled, the pool manager is aware of the process that holds the item, but it does not perform any further actions with it.

### Request a holder item

```ocaml
let item = Poolparty.get_holder_item pool_id |> Result.get_ok in

let result =
  match Connection.execute item.item p query with
  | Ok rows ->
    (match rows with
    | [] -> Error Res.NoRows
    | r -> Ok (List.hd r))
  | Error e -> Error e
in

Poolparty.release pool_id item.holder_pid;
```

I believe it would be easier if I show the code and then explain what happens at each step.

When the app needs a holder's item (in this context, a connection to the database), it uses a function called `get_holder_item`. This function sends a `CheckOut` message to the pool manager. Here's what the pool manager does when it receives a `CheckOut` message:

It checks with the in-memory table if there is any holder with a `Ready` state. Depending on the answer, it does one of two things:

1. If there is a ready holder:
    1. It changes the holder's state to `Busy`.
    2. It reads the PID (Process Identifier) for the holder and sends a `CheckOut` message to the holder. The holder then needs to send whatever it's holding to a requester PID, which is the process asking for a connection.
    3. The app uses the received connection from the holder and then sends a `CheckIn` message with the holder's PID to the pool manager, which changes the state of the holder to `Ready`.
    4. The next requester can then re-use the same holder, as it is ready to be used.
2. If there are no available holders:
    1. The pool manager sends the same `CheckOut` message back to its own mailbox. This step is important to prevent the loop from getting stuck. There was a bug where, if the pool didn't have any ready holders, it would get stuck because the pool manager was using a recursive function that repeatedly asked the storage if there were any available holders. However, this recursive function always returned false because the storage was never updated.

## The future

Currently, PoolParty only works with DBCaml for two reasons:

1. I haven't found a good way yet to allow the holders to store a generic item. Currently, it only works with a local type for DBCaml.
2. PoolParty is still far from stable and lacks some needed functionality. However, I want to release a basic early version of DBCaml to allow developers to experiment with it. I hope that any issues that I am not aware of will be reported, so that I can fix them.
3. PoolParty will break out from DBCaml to be able to work with more than just database connections.

## The end

Thank you for reading this article. I hope you liked it and learned something. DBCaml is still in its early stages, and my current focus is on creating a basic v0.0.1 version for developers to test. The purpose of this article is to serve as a reference for the article I will release when I launch v0.0.1 of DBCaml, as this part of the project is quite significant.

If you are interested and would like to follow along with the development, I can recommend some links for you:

- Riot discord: https://discord.gg/CaykCHrAXN The core discussions about the project are conducted on the Riot discord.
- The Caravan discord: https://discord.gg/XpAWHYbFB3
- DBCaml GitHub: https://github.com/dbcaml/dbcaml

I also post status updates on my Twitter account, which you can find at https://twitter.com/emil_priver if you want to follow along.
