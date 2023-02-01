---
title: "Hello Rust"
date: 2023-02-01T07:37:57+01:00
draft: true
toc: true
---
I started to write Rust in the autumn of 2022 and have since then loved it, even if the learning curve is kinda huge but when you start to understand how the language works is it pretty easy to work with it.

## Short about Rust
Rust is a highly flexible, type-safe, blazingly fast high-performance language without runtime or garbage collector that can be used on a wide area of domains, such as in the Web, embedded or to be used for networking stuff. The Rust compiler called rustc, compiles the code into LLVM to create platform independent almost machine code. Rust enforces memory safety by pointing all references to valid memory without the need for a garbage collector and to prevent data races Rust's borrow checker tracks the object lifetime of all references in the code during compile time.

## Rust is a flexible language
Rust is built to be easy flexible and it doesn't force you to use language-created stuff, such as async runtimes or loggers. Instead, does rust create standardized high-level functionality that allows you to write the functions and then choose which runtime to use, which is great as it allows you to write the code the same way for all types of platforms and if you for example want to change from using async-std to tokio as async runtime, is this done quite easy with often minimal changes.

Same example but in code:

This is our async function that we will use with both Tokio and async-std 
```rust
async fn say_hello() {
    println!("Hello, world!");
}
```
And to run this function with async-std do we simply import async-std and then call task::

```rust
use async_std::task;

fn main() {
    task::spawn(say_hello())
}
```

and with tokio:

```rust
#[tokio::main]
async fn main() -> Result<()> {
  tokio::spawn(say_hello());

  Ok(())
}
```


