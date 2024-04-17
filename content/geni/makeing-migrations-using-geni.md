---
title: "Running schema/database migrations using Geni"
date: 2024-04-17T14:25:36+02:00
draft: false
toc: true
description: "Running schema/database migrations using Geni" 
type: "blog"
tags: ["database", "geni"]
cover:
  image: "images/poolparty.jpeg"
---
A while ago, I developed [Geni](https://github.com/emilpriver/geni), a CLI database migration tool. The goal of the app was to make migrations to [Tursos](https://turso.tech/) databases easier. When I developed Geni, I also decided to add support for Postgres, MariaDB, MySQL, and SQLite. The goal of this post is to describe what database/schema migrations are and how to perform them via Geni.

A schema within a database describes its current structure, which includes elements such as tables, indexes, and constraints. When you connect to a PostgreSQL database and run `\\d+`, you'll see something like this:

![Image description](images/database-structure.png)

The image above shows the current structure of my `job` table. Essentially, migrations are used to modify the database structure. In other words, a migration is a set of instructions for making changes to your database.

Suppose you receive a new task at work that requires you to add a table and a new column to another table. One approach is to connect to the database and make these changes manually. Alternatively, you could use a tool, such as Geni, for this task.

Using Geni offers several advantages. It provides a reproducible database structure, useful for deploying to different environments or running tests within a CI. Because they are just normal SQL files, you can version control them within your repository. Additionally, Geni allows for programmatically making changes to your database without human input.

I've applied this within a project running on Kubernetes. When we released a new version of our app within the Kubernetes cluster, we spun up a [geni container](https://github.com/emilpriver/geni/pkgs/container/geni) in the same Kubernetes namespace. This container checked for any migrations and, if found, ran them before terminating itself.

You can utilize migrations in your integration tests to evaluate the entire application against its actual structure.

There are specific requirements for using this type of tool. Firstly, each migration can only be executed once; if a migration has been applied, it cannot be reapplied. Secondly, migrations need to be run in the correct sequence; for instance, migration 3 cannot be executed before migration 2.

Geni handles this by checking if the table `schema_migrations` exists in your database before executing each migration. If it doesn't, Geni creates the table and inserts the migration id. This table is used to keep track of which migrations have been applied.

When Geni creates migrations, it uses timestamp as the ID, followed by the name of the migration. The format for a migration is `{TIMESTAMP}_{NAME}.sql`. Geni orders each migration based on the ID because it's incremental, preventing migrations from being run in the wrong order.

This is why Geni scales effectively with your projects. It allows you to track each migration within your version control. Simultaneously, you can view the current database structure by reading the schema.sql file that Geni also produces.

## Installation

There are several ways to install Geni:

### Github

You can download the official binaries directly from Github here: https://github.com/emilpriver/geni/releases

### Homebrew

You can install Geni using the Homebrew package manager with the following command:

```jsx
brew install emilpriver/geni/geni

```

### Cargo

You can also install Geni using Cargo with the following command:

```jsx
cargo install geni

```

### PKGX

Alternatively, you can run Geni using PKGX with the following command:

```jsx
pkgx geni up

```

## Creating a Migration

Creating a migration is straightforward. Start by running the following command in your repository:

```jsx
geni new new_table
```

Geni will create two new files in the `./migrations` folder. These files end with .up.sql and .down.sql respectively.

The .up.sql file is where you write new changes. For instance, if you want to create a new users table, you could add:

```sql
create table users (
    id int primary key,
    name varchar(255)
);
```

The .down.sql file is for rolling back changes. Ideally, the SQL code in the .down.sql file should revert the changes made in the .up.sql file. An example is:

```sql
drop table users;
```

## Running the migration

After creating your new migration, execute `geni up` to apply the migrations. This command will prompt geni to read the migrations folders and apply them.

You can also run Geni directly via GitHub Actions as part of your CI flow:

```sql
- uses: emilpriver/geni@main
  with:
    migrations_folder: "./migrations"
    wait_timeout: "30"
    migrations_table: "schema_migrations"
    database_url: "<https://localhost:3000>"
    database_token: "X"
```

Alternatively, you can include it as a container in your docker-compose file:

```sql
version: "3.8"

services:
  luigi-database:
    image: postgres:15.6
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: development
    profiles: [dev, test]
    ports:
      - "7432:5432"
    restart: unless-stopped

  migration-postgres:
    image: ghcr.io/emilpriver/geni:latest
    environment:
      - DATABASE_URL=postgresql://postgres:postgres@luigi-database:5432/development
    volumes:
      - ./migrations:/migrations
    command: up
    profiles: [dev, test]
```

I use Geni as a container for projects where I want others to easily set up and run an environment.

## The end

I hope this article has inspired you to use migrations for your databases, and perhaps even try Geni.

If you're interested in tracking the development of Geni, I recommend starring it on GitHub: https://github.com/emilpriver/geni

For more of my content, consider following me on Twitter: https://twitter.com/emil_priver
