---
title: "Introducing DBCaml, Database toolkit for OCaml"
date: 2024-02-11T10:01:38+01:00
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

It's time for me to discuss what I've been working on recently: Dbcaml. Dbcaml is a database toolkit built for OCaml, based on Riot. Riot is an actor-model multi-core scheduler for OCaml 5, heavily inspired by Erlang's beam. Riot works by creating lightweight processes that execute code and communicate with the rest of the system using message-passing.

You can find Riot on [GitHub](https://github.com/riot-ml/riot).

The core idea of DBCaml is to provide a toolkit that assists with the "boring" tasks you don't want to deal with, allowing you to focus on your queries. Some examples of these tasks include:

- **Database pooling**. Built with using Riots lightweight process to spin up a connection pool.
- **Database Agnostic**. Support for Postgres, and more to come(MySQL, MariaDB, SQLite)
- **Built in security**. With built in security allows users to focus on writing queries and don't be afraid of security breaches.
- **Cross Platform**. DBCaml compiles anywhere
- **Not an ORM**. DBCaml is not an orm, it simple handle the boring stuff you don't want to deal with and allow you to have full insight on what's going on.
- Mapping data to types

However, DBCaml is not an ORM. I want developers to have control over the queries and be aware of what is being sent to the database.

```ocaml
let driver =
    Dbcaml_driver_postgres.connection
      "postgresql://postgres:mysecretpassword@localhost:6432/development"
  in

  let conn = Dbcaml.Dbcaml.start_link driver |> Result.get_ok in

  print_endline "Sending 1 query to the database...";
  (match
     Dbcaml.Dbcaml.fetch_one
       conn
       ~params:["1"]
       "select * from users where id = $1"
   with
  | Ok x ->
    let rows = Dbcaml.Row.row_to_type x in
    (* Iterate over each column and print it's values *)
    List.iter (fun x -> print_endline x) rows
  | Error x ->
    print_endline (Dbcaml.ErrorMessages.execution_error_to_string x);
    failwith "");
```

## Installation

DBCaml can be installed via

```ocaml
opam pin dbcaml.0.0.1 git+https://github.com/dbcaml/dbcaml
```

## Background

I wanted to learn a new language and decided to explore functional programming. I came across OCaml online and found it interesting. When Advent of Code 2023 started, I chose OCaml as the language for my solutions. However, I didn't build them using a functional approach. Instead, I wrote them in a non-functional way, using a lot of references. My solutions turned out to be so bad that a colleague had to rewrite my code.

But this experience sparked my interest even more, and one day I discovered [Leostera](https://twitter.com/leostera), a developer who works on Riot, an actor-model multi-core scheduler for OCaml 5. It is similar to Erlang's beam, which intrigued me. I realized that if I wanted to delve deeper into OCaml, I needed a project to work on. That's when I decided to build a database library for OCaml.

This process hasn't been easy, especially since I had never written any functional programming before. I had to reset my programming mindset, as Leostera put it: "Emil, you need to take rust out of your brain and write OCaml".

Elixir's Ecto, a database library for Elixir, is a great example of how it should be done and has been an inspiration for this project.

## How it works

TBA

## My vision

I have a broad vision for DBcaml, which encompasses three categories: testing, development, and runtime. The specifics of what the testing and developing area will contain will become clearer as we begin working on it, at the moment is the most important to have a v0.0.1 for the connection pool as this is the most important part of the system and we need feedback on how it works.

### Testing

Writing effective tests can be challenging, particularly when it is not possible to mock queries. However, one solution to this problem is to utilize DBcaml. DBcaml can help you in writing tests by providing reusable code snippets. This includes the ability to define rows, close a database, and more, giving you control over how you test your application.

### Developing

I believe SQLx by Rust (https://github.com/launchbadge/sqlx) has done an excellent job of providing a great developer experience (DX). It allows users to receive feedback on the queries they write without the need to test them during runtime. In other words, SQLx enables the use of macros to execute code against the database during the compilation process. This way, any issues with the queries can be identified early on. It is, of course, optional for users to opt in to this feature.

The advantage of this feedback during development is that users can work quickly without having to manually send additional HTTP requests in tools like Postman to trigger the queries they want to test. This saves users valuable time.

By allowing users to test queries during compilation, they can skip writing tests for queries. This provides feedback on whether the query works or not during development.

### Runtime

During runtime, it is important for the user to have a reliable solution that assists with tasks such as connection pooling and security, allowing the user to focus on making the queries they need.

## Roadmap

Currently, DBCaml consists of one foundational library that handles connections, one PostgreSQL driver, and a high-level library to assist you in writing queries and mapping the results to types. It also includes security measures, which means that each driver is responsible for handling SQL injections and TLS.

### v0.0.1

- Low-level Dbcam
    - Connection pool
    - Query manager
- Postgres driver
- High-level library (name: TBA) to assist with queries and results (not mapping to types yet)
    - Most developers will likely use this library, and I recommend using it for its convenience. Dbcam is recommended for advanced usage, such as if you want to have full control over the results. Dbcam will return bytes/streams directly from the database.

### v0.0.2

- Bug fixes
- Mapping result rows to types
- More drivers

## Future

The upcoming releases will mostly focus on making DBcaml and co stable by testing it via different applications, but also to continue add support for a big amount of databases and build the support that did talk about within developing and testing step.

## The end

I want to give a special thank you to Leostera, who has helped me a lot during the development. I wouldn't argue that this is something I've just worked on. This is a joint effort between me, Leostera, and other members of the Riot Discord to make this happen.

If you are interested in the project, I would recommend joining the [Riot Discord](https://discord.gg/CaykCHrAXN) where most of the conversations are taking place.

