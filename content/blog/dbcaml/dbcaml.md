---
title: "Introducing DBCaml, Database toolkit for OCaml"
date: 2024-02-20T10:01:38+01:00
draft: true
type: "blog"
tags: ["Ocaml", "DBCaml"]
cover:
  image: "images/ocaml/dbcaml.jpeg"
series:
  - Ocaml
toc: true
description: "Introducing DBCaml, Database toolkit for OCaml"
---

It's time for me to discuss what I've been working on recently: Dbcaml. Dbcaml is a database toolkit built for OCaml, based on Riot. Riot is an actor-model multi-core scheduler for OCaml 5. Riot works by creating lightweight processes that execute code and communicate with the rest of the system using message-passing.

You can find Riot on [GitHub](https://github.com/riot-ml/riot).

The core idea of DBCaml is to provide a toolkit that assists with the "boring" tasks you don't want to deal with, allowing you to focus on your queries. Some examples of these tasks include:

- **Database pooling**. Built with using Riots lightweight process to spin up a connection pool.
- **Database Agnostic**. Support for Postgres, and more to come(MySQL, MariaDB, SQLite)
- **Built in security**. With built in security allows users to focus on writing queries and don't be afraid of security breaches.
- **Cross Platform**. DBCaml compiles anywhere
- **Not an ORM**: DBCaml is not an ORM. It simply handles the boring stuff that you don't want to deal with and allows you to have full insight into what's going on. However, it should be possible to build an ORM/query builder on top of DBCaml (more information about this later).
- Mapping data to types.

This is an example of how you can use DBCaml:

```ocaml
let driver =
  Dbcaml_driver_postgres.connection
    "postgresql://postgres:mysecretpassword@localhost:6432/development"
in

let pool_id = Dbcaml.start_link ~connections:10 driver |> Result.get_ok in

(* Fetch 1 row from the database *)
(match
   Dbcaml.fetch_one
     pool_id
     ~params:[Dbcaml.Param.String "1"]
     "select * from users where id = $1"
 with
| Ok x ->
  let rows = Dbcaml.Row.row_to_type x in
  (* Iterate over each column and print its values *)
  List.iter (fun x -> print_endline x) rows
| Error x -> print_endline (Dbcaml.Res.execution_error_to_string x));
```

## Installation

During the initial v0.0.1 release, DBCaml can be installed using the following command:

```ocaml
opam pin dbcaml.0.0.1 git+https://github.com/dbcaml/dbcaml
```

## Background

I wanted to learn a new language and decided to explore functional programming. I came across OCaml online and found it interesting. When Advent of Code 2023 started, I chose OCaml as the language for my solutions. However, I didn't build them using a functional approach. Instead, I wrote them in a non-functional way, using a lot of references. My solutions turned out to be so bad that a colleague had to rewrite my code.

However, this experience further sparked my interest. One day, I came across [Leostera](https://twitter.com/leostera), a developer working on Riot, an actor-model multi-core scheduler for OCaml 5. Riot is similar to Erlang's beam, which intrigued me. It dawned on me that if I wanted to explore OCaml further, I needed a project to work on. That's when I made the decision to build a database library for OCaml. I believed that it would be a useful addition to the Rio ecosystem.

## How it works

DBCaml can be categorized into three layers: Driver, Connection pool, and the interface that the developer works with. I have already explained how the connection pool works in a previous post, which you can find here: [Building a Connection Pool](https://priver.dev/blog/dbcaml/building-a-connnection-pool/).

However, I would like to provide further explanation on drivers and the interface.

### Driver

The driver is responsible for communicating with the database. It acts as a bridge between DBCaml and the database. The main idea behind having separate drivers as a library is to avoid the need for installing unnecessary libraries. For example, if you are working with a Postgres database, there is no need to install any MySQL drivers. By keeping the drivers separate, unnecessary dependencies can be avoided.

Additionally, the driver takes care of all the security measures within the library. DBCaml simply provides the necessary data to the drivers, which handle the security aspects.

### The interface

I will describe the current functionality of everything and explain my vision for how I believe this library will evolve in future releases.

Currently, DBCaml provides four methods: start_link, fetch_one, fetch_many, and exec. These methods serve as the highest level of functionality in the package and are the primary interface used by developers for testing purposes in v0.0.1. These methods handle most of the tasks that developers don't need to worry about, such as requesting a connection from the pool.

## My vision

I have a broad vision for DBCaml, which encompasses three categories: testing, development, and runtime. The specifics of what will be included in the testing and development areas will become clearer as we start working on it. However, currently, the most important aspect is to have a v0.0.1 release for the connection pool. This is the critical component of the system, and we need feedback on its functionality and to identify any potential bugs or issues.

### Testing

Writing effective tests can be challenging, particularly when it is not possible to mock queries. However, one solution to this problem is to utilize DBCaml. DBCaml can help you in writing tests by providing reusable code snippets. This includes the ability to define rows, close a database, and more, giving you control over how you test your application.

### Developing

I believe SQLx by Rust (https://github.com/launchbadge/sqlx) has done an excellent job of providing a great developer experience (DX). It allows users to receive feedback on the queries they write without the need to test them during runtime. In other words, SQLx enables the use of macros to execute code against the database during the compilation process. This way, any issues with the queries can be identified early on. It is, of course, optional for users to opt in to this feature.

The advantage of this feedback during development is that users can work quickly without having to manually send additional HTTP requests in tools like Postman to trigger the queries they want to test. This saves users valuable time.

By allowing users to test queries during compilation, they can skip writing tests for queries. This provides feedback on whether the query works or not during development.

### Runtime

During runtime, it is important to have a system that can handle pooling for your application. This ensures that if a connection dies, it is recreated and booted again.

## Roadmap and future ideas

Currently, we are in version v0.0.1, which is a small release with limited functionality. However, I have big plans for the future of this package. The purpose of creating v0.0.1, despite knowing that there will be upcoming changes, is to test the connection pool and ensure its functionality.

The v0.0.1 release includes the ability to fetch data from the database and use it, along with a connection pool and a PostgreSQL driver. However, I will soon be branching out DBCaml into three new packages:

1. PoolParty (name subject to change): This package will provide a connection pool that anyone can use(not only for database connections).
2. DBCaml: This library will utilize PoolParty to run queries against the database and return streaming data or bytes. The reason for this change is to allow developers to use tools like [Serde.ml](http://serde.ml/) to map data to types. By returning streaming data or bytes instead of fixed static types (such as strings), developers will be able to build libraries on top of DBCaml. For example, it would be possible to build a query builder on top of DBCaml and use it.
3. Library X: This high-level package will use DBCaml to make queries and map responses to types using serde.ml. I expect this to be the package that most developers will use. It will include functions like `fetch_one`, `fetch_many`, `start_link`, and `exec`, which already exist in DBCaml.

This significant change will be implemented in the v0.0.2 milestone.

## The end

I want to give a special thank you to Leostera, who has helped me a lot during the development. I wouldn't argue that this is something I've just worked on. This is a joint effort between me, Leostera, and other members of the Riot Discord to make this happen.

If you are interested and would like to follow along with the development, I can recommend some links for you:

- Riot discord: https://discord.gg/CaykCHrAXN The core discussions about the project are conducted on the Riot discord.
- The Caravan discord: https://discord.gg/XpAWHYbFB3
- DBCaml GitHub: https://github.com/dbcaml/dbcaml
