---
title: "Rust: Traits"
date: 2023-12-16T02:29:53+01:00
draft: false
toc: true
description: "Article about working with traits in rust" 
type: "blog"
tags: ["rust", "traits"]
series:
- Rust
images:
  - /og-images/rust-og.jpg
---
It's been a while since Rust introduced traits, which are similar to interfaces in most other languages (although they do have some differences). I personally enjoy working with traits because they provide great flexibility within a statically typed language. However, they can be a bit confusing to grasp at first. The goal of this post is to help you gain a better understanding of traits.

The case we will use in this post is a real use-case, as I am currently working on a SQL migration tool. I know that there are probably millions of them, but I haven't found any that make handling libSQL migrations easy. The code can be found [here](https://github.com/emilpriver/geni). I am using traits to support multiple databases without the need to write numerous if-else statements and complex logic. My goal is to obtain the correct database driver and its corresponding `execute` function by simply providing a `database_url` to a `new` function.

Traits in Rust are often compared to interfaces in other languages, but there are some differences. One difference is that Rust allows you to create defaults for traits and supports generic traits. One of the main advantages of using traits in Rust is the ability to abstract over different types with the same behavior. This is particularly useful when working with data structures or algorithms that need to operate on various types, as it allows you to write code that is agnostic to the specific types being used. Additionally, Rust enforces type-safety and can prevent common programming mistakes. For example, Rust prevents you from calling a method if it cannot be guaranteed to exist. Traits can also be added to types, which means that you can add functionality to different types within Rust and override the functionality of a type's method.

Traits are everywhere in Rust. Some common traits you may work with include `Clone`, `Copy`, `Serialize`, `Deserialize`, and even the async/await functionality has a trait called `Future`.

## Creating a trait

I will be using the code I am currently working on for [Geni](https://github.com/emilpriver/geni/blob/main/src/database_drivers/mod.rs) as examples. For Geni, each `DatabaseDriver` (such as PostgreSQL, MySQL, LibSQL, etc.) is required to have two functions: `execute` and `get_or_create_schema_migrations`. These two functions are used within my project.

```rust
trait DatabaseDriver {
    async fn execute(self, query: &str) -> Result<()>;
    async fn get_or_create_schema_migrations(self) -> Result<Vec<String>>;
}
```

So, to create a new `DatabaseDriver`, you need to implement the `DatabaseDriver` trait for your struct. This will allow you to use the `execute` and `get_or_create_schema_migrations` functions later in your code. In the code below, we create a struct called "LibSQLDriver" and later provide a local implementation for the struct, adding a new function. After that, we also implement our trait `DatabaseDriver` for `LibSQLDriver`, defining the `execute` and `get_or_create_schema_migrations` functions.

```rust
pub struct LibSQLDriver {
    db: Client,
}

impl LibSQLDriver {
    pub async fn new(db_url: &str, token: &str) -> Result<LibSQLDriver> {
        let config = Config::new(db_url)?.with_auth_token(token);

        let client = match libsql_client::Client::from_config(config).await {
            Ok(c) => c,
            Err(err) => bail!("{:?}", err),
        };

        Ok(LibSQLDriver { db: client })
    }
}

#[async_trait]
impl DatabaseDriver for LibSQLDriver {
    // Execute query with the provided database
    async fn execute(self, query: &str) -> Result<()> {
        // write logic
    }

    // Get or create schema migrations with the provided database
    async fn get_or_create_schema_migrations(self) -> Result<Vec<String>> {
        // write logic
    }
}

```

## Trait as return type and arguments

So, creating traits is not only for adding methods to structs. They can also be used as a return type. What I mean by this is that you can instruct Rust to return a struct that has implemented the trait, without specifying which struct it is. However, Rust does not allow returning two different structs that implement the `DatabaseDriver` trait in this way. I will discuss an alternative approach later.

In the example below (taken from [rust docs](https://doc.rust-lang.org/book/ch10-02-traits.html)), we can see an example where we create a struct called `Tweet` and then return it to a type that expects a struct implementing the `Summary` trait.

```rust
fn returns_summarizable() -> impl Summary {
    Tweet {
        username: String::from("horse_ebooks"),
        content: String::from(
            "of course, as you probably already know, people",
        ),
        reply: false,
        retweet: false,
    }
}
```

But traits can also be used as arguments:

```rust
use serde::Serialize;

fn print_serialized(v: impl Serialize) {
    let serialized = serde_json::to_string(&v).unwrap();
    println!("{}", serialized);
}

```

This allows us to specify that we want an argument that implements the `Serialize` trait. It can be quite useful when working with libraries that require converting objects into JSON. By using `impl Serialize`, we can simplify our code and only need one argument for the function. For example, if we want to create a JSON log, we can pass any argument that implements `Serialize` to the function and easily print it as JSON.

```rust
#[derive(Serialize)]
struct MyStruct {
    x: i64,
    y: i64,
}

fn main() {
    let my_struct = MyStruct { x: 1, y: 2 };
    print_serialized(my_struct);

    let my_string = "hello";
    print_serialized(my_string);
}

```

## Default traits

If you implement a trait that is used with non-unique structs, providing a default value can be useful. Creating a default value for a trait is straightforward and is done when defining the trait. To create a default value for a trait, extend the trait's method declaration with the desired logic.

```rust
trait DatabaseDriver {
    async fn execute(self, query: &str) -> Result<()> {
        Ok(())
    }
}

```

With this default implementation, it is not necessary to define the `execute` method for every struct that implements the `DatabaseDriver` trait. Instead, you can use the default implementation as a fallback. If you do not provide a default value and do not provide a method for the struct that implements the trait, Rust will not compile, so there is no need to worry about making a mistake 😄

## Generics with traits

Next, let's discuss generic traits. These traits are useful for creating traits that can work with more than one type. For example, if you want to create a method that can return more than just a `String`. In the example below, we create different prints depending on the type that we use with the trait. This allows us to change the behavior of the trait depending on the type of the generic.

```rust
// Define a generic trait
trait PrintInfo<T> {
    fn print_info(&self, value: T);
}

// Implement the trait for a specific type (in this case, i32)
struct ExampleStruct;

impl PrintInfo<i32> for ExampleStruct {
    fn print_info(&self, value: i32) {
        println!("Printing information about i32 value: {}", value);
    }
}

// Implement the trait for a different type (in this case, String)
struct AnotherExampleStruct;

impl PrintInfo<String> for AnotherExampleStruct {
    fn print_info(&self, value: String) {
        println!("Printing information about String value: {}", value);
    }
}

fn main() {
    let example_struct = ExampleStruct;
    let another_example_struct = AnotherExampleStruct;

    // Use the trait methods with different types
    example_struct.print_info(42);
    another_example_struct.print_info(String::from("Hello, Rust!"));
}
```

Traits can also be used as normal generic arguments.

```rust
pub fn notify<T: Summary>(item: &T) {
    println!("Breaking news! {}", item.summarize());
}

```

Here, we specify that the argument `item` should implement the `Summary` trait.

## `dyn` traits

To return different implementations of traits, we can use dynamic traits. In my case, I want to return a different `DatabaseDriver` depending on the `db_url` given to the function. This allows us to work with different structs as long as they have implemented the `DatabaseDriver` trait.

```rust
pub trait DatabaseDriver {
    async fn execute(self, query: &str) -> Result<()>;
    async fn get_or_create_schema_migrations(self) -> Result<Vec<String>>;
}

fn print_serialized_trait_object<T: Serialize>(t: &T) {
    let serialized = serde_json::to_string(t).unwrap();
    println!("{}", serialized);
}

pub async fn new(db_url: &str) -> Result<Box<dyn DatabaseDriver>> {
    if db_url.starts_with("libsql") {
        let token = match config::database_token() {
            Ok(t) => t,
            Err(err) => bail!("{}", err),
        };

        let client = match libsql::LibSQLDriver::new(db_url, token.as_str()).await {
            Ok(c) => c,
            Err(err) => bail!("{:?}", err),
        };

        return Ok(Box::new(client));
    }

    if db_url.starts_with("postgressql") {
        let client = match postgres::PostgresDriver::new(db_url).await {
            Ok(c) => c,
            Err(err) => bail!("{:?}", err),
        };

        return Ok(Box::new(client));
    }

    bail!("No matching database")
}

```

In the given example, we change `impl` to `dyn` in order to inform Rust that we want to work with different structs as long as they implement the `DatabaseDriver` trait. This is not allowed if we set the return type to `impl Trait`. By defining the return type as `dyn Trait`, we tell Rust that the size of the returned value may differ. To work with dynamic sized data, we need to store it on the heap using constructs like `Box`, `Arc`, and others.

## .unwrap()

I hope this article has taught you something about working with traits in Rust and that it can help improve your Rust code.

I appreciate feedback, so if you have any, I would love to hear it. The easiest way to reach out to me is through my Twitter handle: [@emil_priver](https://twitter.com/emil_priver) 😄
