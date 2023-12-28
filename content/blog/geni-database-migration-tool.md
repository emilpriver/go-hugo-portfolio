---
title: "Geni, A database migration CLI tool"
date: 2023-12-28T09:10:04+01:00
draft: false
toc: true
description: "Geni, a CLI migration tool" 
type: "blog"
tags: ["database", "announcement"]
images:
  - /og-images/geni-social-media.jpg
---
I'm excited to introduce Geni, a user-friendly CLI migration tool for databases written in Rust. It currently supports LibSQL, Postgres, MariaDB, MySQL, and SQLite, and I have plans to add support for more databases in the future. The concept behind Geni is simple: it can seamlessly integrate with your code as a plugin for your CI, or as a sidebar in Kubernetes, without causing any disruptions or requiring you to use a specific programming language.

Personally, I'm a big fan of [dbmate](https://github.com/amacneil/dbmate) and I rely on it for both my professional and personal projects to handle migrations. It's an excellent tool. However, when they declined my [PR](https://github.com/amacneil/dbmate/pull/470) to add LibSQL support, I decided to develop my own CLI tool. I couldn't find any satisfactory migration tools, although I did come across [Atlas](https://atlasgo.io/). However, Atlas handles migrations in a way that doesn't align with my preferences, and it also appears to be closely tied to Kubernetes. 

Geni became my Christmas project with the goal of being a small component for your workspaces. One common issue with migrations is not keeping track of which migrations have been executed. Geni (and dbmate, for that matter) solves this problem by storing all migrated migrations in the database. This ensures that developers won't overwrite or re-run the same migrations. 

The application is developed using Rust and relies on the [libsql-client-rs](https://github.com/libsql/libsql-client-rs) library for SQLite and LibSQL. Moreover, it makes use of [SQLX](https://github.com/launchbadge/sqlx) to support Postgres, MariaDB, and MySQL databases. As this is written in rust is it lighting fast, blazingly fast, tiny, ultra fast and memory safe.

## Features

- Databases:
    - Postgres
    - MariaDB
    - MySQL
    - SQLite
    - LibSQL
- Generating migrations using `geni new **name**`
- Migrating using `geni up`
- Rollback using `geni down`
- Create database using `geni create`
- Dropping database using `geni drop`
- Timestamp based migrations

## Installation

### Github

```rust
$ sudo curl -fsSL -o /usr/local/bin/geni <https://github.com/emilpriver/geni/releases/latest/download/geni-linux-amd64>
$ sudo chmod +x /usr/local/bin/geni
```

### Homebrew

TBA(check [github](https://github.com/emilpriver/geni) for more information). Will be added when we are out of beta

### Scoop

TBA(check [github](https://github.com/emilpriver/geni) for more information). Will be added when we are out of beta

### PKGX

Run using PKGX

```
pkgx geni up
```

### Docker

Docker images are published to GitHub Container Registry ([ghcr.io/emilpriver/geni](https://ghcr.io/emilpriver/geni)).

```
$ docker run --rm -it --network=host ghcr.io/emilpriver/geni --help

```

If you wish to create or apply migrations, you will need to use Docker's [bind mount](https://docs.docker.com/storage/bind-mounts/) feature to make your local working directory (`pwd`) available inside the geni container:

```rust
$ docker run --rm -it --network=host -v "./migrations:./migrations" ghcr.io/emilpriver/geni new hello`
```

## Commands

```rust
geni new    # Generate a new migrations file
geni up     # Run any pending migration
geni down   # Rollback migrations, use --amount to speify how many migrations(default 1)
geni create # Create the database, only works for Postgres, MariaDB and MySQL. If you use SQLite will geni create the file before running migrations if the sqlite file don't exist. LibSQL should be create using respective interface.
geni drop   # Remove database
geni help   # Print help message

```

## Example usage

First, make sure you have installed Geni CLI using one of the installation methods mentioned above.

### Creating a New Migration

To create a new migration, run the following command:

```rust
DATABASE_URL="x" geni new hello_world
```

This will generate two files, one ending with `.up.sql` and the other with `.down.sql`. The `.up.sql` file is used for creating migrations, while the `.down.sql` file is used for rolling back migrations. The path to the generated files will be displayed in the console.

### Adding SQL to the Migration

Open the `.up.sql` file and add your SQL code to create the desired database table or make any other changes you need. For example, to create a table named `Persons`, you can add the following code:

```rust
CREATE TABLE Persons (
    PersonID int
);
```

Make sure to include the corresponding rollback code in the `.down.sql` file. In this case, the rollback code would be:

```rust
DROP TABLE Persons;
```

### Running the Migration

To run the migration and apply the changes to the database, use the following command:

```rust
geni up
```

This will execute all pending migrations and update the database accordingly.

That's it! You have now successfully created a migration, added SQL code to it, and executed the migration using Geni CLI.

## End

That’s it. Hope this CLI might be useful to you :D  If you find any bugs then I would love to hear about them here https://github.com/emilpriver/geni/issues

