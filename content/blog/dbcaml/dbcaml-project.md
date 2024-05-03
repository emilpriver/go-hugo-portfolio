---
title: "Announcing DBCaml, Silo, Serde Postgres and a new driver for postgres"
date: 2024-05-03T00:01:38+01:00
draft: false
type: "blog"
tags: ["Ocaml", "DBCaml"]
cover:
  image: "images/ocaml/dbcaml.jpeg"
series:
  - Ocaml
toc: true
description: "Announcing DBCaml, Silo, Serde Postgres and a new driver for postgres"
---
I've spent the last four months working on DBCaml. Some of you may be familiar with this project, while others may not. When I started DBCaml, I had one primary goal: to build a toolkit for OCaml that handles pooling and mapping to types and more. This toolkit would also run on Riot, which is an actor-model multi-core scheduler for OCaml 5. 

An issue I've found in the OCaml space and databases is that most of the existing database libraries either don't support Postgres version 14 and higher, or they run on the PostgreSQL library, which is a C-binding library. The initial release of DBcaml also used the Postgresl library just to get something published. However, this wasn’t something I wanted as I felt really limited in what I was able to do, and the C-bindings library would also limit the number of processes I could run with Riot, which is something I didn’t want. So, I decided to work hard on the Postgres driver to write a native OCaml driver which uses Riot's socket connection for the database.

This post is to describe the new change by talking about each library. The GitHub repo for this project exists here: https://github.com/dbcaml/dbcaml

Before I continue, I want to say a big thank you to [Leandro Ostera](https://twitter.com/leostera), [Antonio Monteiro](https://twitter.com/_anmonteiro) and many more in the OCaml community. When I've been in need of help, you have provided me with information and code to fix the issues I encountered. Thank you tons! <3

Now that DBCaml has expanded into multiple libraries, I will refer to these as "The DBCaml project". I felt it was important to write about this project again because the direction has changed since v0.0.1.

## DBCaml

DBCaml, the central library in this project, was initially designed to handle queries, type mapping, and pooling. As the project expanded, I decided to make DBCaml more developer-friendly. It now aids in pooling and sending queries to the database, returning raw bytes in response.

DBCaml's pool takes inspiration from Elixir's ecto.

Currently, I recommend developers use DBCaml for querying the database and receiving raw bytes, which they can then use to build any desired features.

However, my vision for DBCaml is not yet complete. I plan to extract the pooling function from DBCaml and create a separate pool manager, inspired by Elixir's ecto. This manager can be used by developers to construct features, such as a Redis pool.

If you're interested in learning more about how DBCaml works, I recommend reading these articles: [”Building a Connnection Pool for DBCaml on top of riot](https://priver.dev/blog/dbcaml/building-a-connnection-pool/)” and [”Introducing DBCaml, Database toolkit for OCaml”](https://priver.dev/blog/dbcaml/dbcaml/).

## DBCaml Postgres Driver

A driver essentially serves as the bridge between your code and the database. It's responsible for making queries to the database, setting up the connection, handling security, and managing TLS. In other words, it performs "the real job."

The first version of the driver was built for Postgresql, using a C-binding library. However, I wasn't fond of this library because it didn't provide raw bytes, which are crucial when mapping data to types.

This library has since been rewritten into native OCaml code, using Riot's sockets to connect to the database.

## Serde Postgres

The next library to discuss is Serde Postgres, a Postgres wire deserializer. The Postgres wire is a protocol used by Postgres to define the structure of bytes, enabling us to create clients for Postgres. You can read about the Postgres wire protocol at: https://www.postgresql.org/docs/current/protocol.html

With the introduction of Serde Postgres, it's now possible to deserialize Postgres wire and map the data to types. Here's an example:

```ocaml
type user = {
  name: string;
  id: int;
  some_int64: int64;
  some_int32: int32;
  some_float: float;
  some_bool: bool;
  pet_name: string option;
  pets: string list;
  pets_array: string array;
}
[@@deriving deserialize]

let u =
    match Serde_postgres.of_bytes deserialize_user message with
    | Ok u -> u
    | Error e -> fail (Format.asprintf "Deserialize error: %a" Serde.pp_err e)
  in

print_string u.name:

```

By creating a separate library, developers can use Serde, Postgres, and Dbcaml to make queries and later parse the data into types.

## Silo

The final library to discuss is Silo. This is the high-level library I envisioned for DBcaml, one that handles everything for you and allows you to simply write your queries and work with the necessary types. Silo uses DBcaml to make raw queries to the database and then maps the bytes from Postgres to types using Serde Postgres.

Here's an example:

```ocaml
type user = {
  name: string;
  id: int;
  some_int64: int64;
  some_int32: int32;
  some_float: float;
  some_bool: bool;
  pet_name: string option;
  pets: string list;
  pets_array: string array;
}
[@@deriving deserialize]

type users = user list [@@deriving deserialize]

let () =
  Riot.run_with_status ~on_error:(fun x -> failwith x) @@ fun () ->
  (* Start the database connection pool *)
  let* db =
    let config =
      Silo.config
        ~connections:5
        ~driver:(module Dbcaml_driver_postgres)
        ~connection_string:
          "postgresql://postgres:postgres@localhost:6432/postgres?sslmode=disabled"
    in

    Silo.connect ~config
  in

  (* Fetch the user and return the user to a variable *)
  let* fetched_users =
    Silo.query
      db
      ~query:
        "select name, id, some_bool, pet_name, some_int64, some_int32, some_float, pets, pets as pets_array from users limit 2"
      ~deserializer:deserialize_users
  in

  List.iter
    (fun x ->
      Printf.printf
        "Fetching user with id %d:\nName: %s\nSome float: %f\nSome int64: %d\nSome int32: %d\n%s\n Some bool: %b\nPets: %s\nPets array: %s\n\n"
        x.id
        x.name
        x.some_float
        (Int64.to_int x.some_int64)
        (Int32.to_int x.some_int32)
        (match x.pet_name with
        | Some pn -> Printf.sprintf "Pet name: %S" pn
        | None -> "No pet")
        x.some_bool
        (String.concat ", " x.pets)
        (String.concat ", " (Array.to_list x.pets_array)))
    (Option.get fetched_users);
```

Silo is the library I anticipate most developers will use if they don't create their own database library and need further control over functionality.

## The future

There is some more stuff I've planned for this project, such as building more drivers and deserializers for different databases:

- MariaDB
- MySQL
- SQLite
- Turso
- Clickhouse

I also want to build more tools for you as a developer when you write your OCaml projects, and some of these are:

- Generate types based on the query
- Mock database driver so you can test the functionality within your project without a database running
- Developer feedback from your LSP

## The End

I hope you appreciate these changes. If you're interested in contributing to the libraries or discussing them, I recommend joining the Discord: https://discord.gg/wqbprMmgaD

For more minor updates, follow my Twitter page: https://twitter.com/emil_priver

If you find a bug would I love if you create a issue here: https://github.com/dbcaml/dbcaml/issues
