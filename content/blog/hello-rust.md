---
title: "Hello Rust"
date: 2023-02-01T23:25:57+01:00
draft: false
toc: true
description: Good rust stuffs I learned when working with rust.
type: "blog"
tags: ["rust", "tokio", "macros"]
series:
- Rust 
images:
  - /og-images/rust-og.jpg
cover: "images/rust-og.jpg"
---
I started to write Rust in the autumn of 2022 and have since then loved it, even if the learning curve is kinda huge but when you start to understand how the language works is it pretty easy to work with it. This is some stuffs I've learned since I started to write Rust that I think is good to know information.

## Short about Rust
Rust is a highly flexible, type-safe, blazingly fast high-performance language without runtime or garbage collector that can be used on a wide area of domains, such as in the Web, embedded or to be used for networking stuff. The Rust compiler called [rustc](https://doc.rust-lang.org/rustc/what-is-rustc.html), compiles the code into [LLVM](https://llvm.org/) to create platform independent almost machine code. Rust enforces memory safety by pointing all references to valid memory without the need for a garbage collector and to prevent data races Rust's borrow checker tracks the object lifetime of all references in the code during compile time.

## Rust is a flexible language
Rust is built to be easy flexible and it doesn't force you to use language-created stuff, such as async runtimes or loggers. Instead, does rust create standardized high-level functionality that allows you to write the functions and then choose which runtime to use, which is great as it allows you to write the code the same way for all types of platforms and if you for example want to change from using [async-std](https://async.rs/) to [tokio](https://tokio.rs) as async runtime, is this done quite easy with often minimal changes.

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



In most cases are there some runtimes/frameworks which fit most of the needs for using Async rust but all of them are probably not suitable for most cases, for example, async in WebAssembly might not work on all async runtimes as they rely on primitives that might not be available or optimal for WebAssembly, in this case changing your runtime for async to [wasm-rs/async-executor](https://github.com/wasm-rs/async-executor) could be handy.

But the language is not only flexible in a way that you can use different runtimes, but you are also able to use code depending on if the config has enabled the feature or if a build is targeted to a special runtime, such as WASM. This is done by using the `cfg-if` crate and can be used in the code like this:

```rust 
// This function only gets compiled if the target OS is linux
#[cfg(target_os = "linux")]
fn are_you_on_linux() {
    println!("You are running linux!");
}

// And this function only gets compiled if the target OS is *not* linux
#[cfg(not(target_os = "linux"))]
fn are_you_on_linux() {
    println!("You are *not* running linux!");
}

```
Or like this
```rust
cfg_if::cfg_if! {
    if #[cfg(unix)] {
        fn foo() { /* unix specific functionality */ }
    } else if #[cfg(target_pointer_width = "32")] {
        fn foo() { /* non-unix, 32-bit functionality */ }
    } else {
        fn foo() { /* fallback implementation */ }
    }
}

fn main() {
    foo();
}
```

## Pattern syntax and matching is great 
I love using `match` in rust as it's highly flexible. You are able to match stuff such as ranges, enums, struct values, and nested structs in quite an easy way.  I use match most of the time as I like to test each case I have, for example when I am developing an HTTP API do I match the input data or the result of a database query to be able to handle every necessary case there are to be able to return the value I wanted. I rather use match than using functions such as unwrap or unwrap_or which could work more than fine for the use case.

But enough of how I like to write rust, here are some examples of using match in rust.

First if matching on multiple values: 

```rust 
let x = 1;

    match x {
        1 | 2 => println!("one or two"),
        3 => println!("three"),
        _ => println!("anything"),
    }
```
A pretty easy and normal thing to do in general in programming. Doing this in GO for example could look like this: 

```go
func main() {
	string := "hello";

	switch  string {
	case "Hej", "hello":
		fmt.Println("Either Swedish or English")
	case "Hola":
		fmt.Println("spanic")
	default:
		fmt.Println("I dont speak this language")
	}
}
```
Or JavaScript
```javascript
switch (varName)
{
   case "afshin":
   case "saeed":
   case "larry": 
       alert('Hey');
       break;

   default: 
       alert('Default case');
}

```
As you might see the normal basic switch cases are supported, but Rust also supports matching on ranges, such as characters ranges:
```rust
    let x = 'c';

    match x {
        'a'..='j' => println!("early ASCII letter"),
        'k'..='z' => println!("late ASCII letter"),
        _ => println!("something else"),
    }

```
or structs

```rust
  let p = Point { x: 0, y: 7 };

    match p {
        Point { x, y: 0 } => println!("On the x axis at {x}"),
        Point { x: 0, y } => println!("On the y axis at {y}"),
        Point { x, y } => {
            println!("On neither axis: ({x}, {y})");
        }
    }
```
and you are even able to match on what nested function that are called
```rust 
  let msg = Message::ChangeColor(0, 160, 255);

    match msg {
        Message::Quit => {
            println!("The Quit variant has no data to destructure.");
        }
        Message::Move { x, y } => {
            println!("Move in the x direction {x} and in the y direction {y}");
        }
        Message::Write(text) => {
            println!("Text message: {text}");
        }
        Message::ChangeColor(r, g, b) => {
            println!("Change the color to red {r}, green {g}, and blue {b}",)
        }
    }

```
or the type of the input to the nested function that are used 
```rust

enum Color {
    Rgb(i32, i32, i32),
    Hsv(i32, i32, i32),
}

enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(Color),
}

fn main() {
    let msg = Message::ChangeColor(Color::Hsv(0, 160, 255));

    match msg {
        Message::ChangeColor(Color::Rgb(r, g, b)) => {
            println!("Change color to red {r}, green {g}, and blue {b}");
        }
        Message::ChangeColor(Color::Hsv(h, s, v)) => {
            println!("Change color to hue {h}, saturation {s}, value {v}")
        }
        _ => (),
    }
}
```
All of these examples are copied from the official rust documentation and I think the example they give in the documentation is easy to understand and well-defined. You can read more about pattern matching [here](https://doc.rust-lang.org/book/ch18-03-pattern-syntax.html)

Mastering the match statement is something I recommend. It allows you to write easy-to-understand, blazingly fast-code.

A example of how I often use match
```rust
    let user = match get_user_by_jwt_token(auth.token().to_string()).await {
        Ok(u) => u,
        Err(error) => {
            log::warn!("couldn't validate jwt due to: {}", error);

            return HttpResponse::InternalServerError().json(types::ErrorJsonResponse {
                message: "couldn't read users ".to_string(),
            });
        }
    };
```

## Macros
[Macros](https://doc.rust-lang.org/book/ch19-06-macros.html) are not functions, but they kinda work like functions 💁? Macros are a way of writing code, that writes other code which is called [metaprogramming](https://en.wikipedia.org/wiki/Metaprogramming). Some of these macros are `vec!` or `#[tokio::main]` .
For example do the macro `#[tokio::main]` expand from 
```rust 
#[tokio::main]
async fn main() {
    println!("hello");
}
```
to 
```rust
fn main() {
    let mut rt = tokio::runtime::Runtime::new().unwrap();
    rt.block_on(async {
        println!("hello");
    })
}
```
So macros are useful to re-use existing code for your project and to write smaller and way simpler code which can(if using pre-defined macros) allow you to maintain fewer lines of code.

Macros are created by creating a new macro_rule which takes arguments you define and return code the compiler read and use, which you can see in the example below for the `vec!` macro
```rust
#[macro_export]
macro_rules! vec {
    ( $( $x:expr ),* ) => {
        {
            let mut temp_vec = Vec::new();
            $(
                temp_vec.push($x);
            )*
            temp_vec
        }
    };
}
```

## The borrow checker can be a living hell but is great.
Rust is memory-safe, non-garbage-collected language, does it come with a borrow checker to ensure that we don't work with any non-valid memory points in our systems. This is done during the compilation time and can cause a lot of headaches for the developers. On the other hand, the developers of Rust spent a lot of time working on a good developer experience for the users and describing the issues in the simplest way possible.

This is a small example of what I mean:
```rust
fn main() {
    let mut value = "hello rust! :DDDD".to_string();
    let later_reused_value = &value[6..];
    value.clear();
    println!("Hello there, {}!", later_reused_value);
}
```
and the error description we get is
```
error[E0502]: cannot borrow `value` as mutable because it is also borrowed as immutable
 --> main.rs:4:5
  |
3 |     let later_reused_value = &value[6..];
  |                               ----- immutable borrow occurs here
4 |     value.clear();
  |     ^^^^^^^^^^^^^ mutable borrow occurs here
5 |     println!("Hello there, {}!", later_reused_valu...
  |                                  ------------------ immutable borrow later used here

error: aborting due to previous error

For more information about this error, try `rustc --explain E0502`.
```

What happens here is that we create a mutable value which is needed as we are going to change the variable "value" later on by clearing the value. In this case, does Rust create a new value it stores in the memory which the variable `later_reused_value` later on re-use and takes ownership over, by extracting `rust` from "hello rust!". And when we, later on, try to clear the value of the variable `value` is it already used by `later_reused_value` so the memory point is not valid anymore. The solution for this problem would then be to copy the value of variable `value` using the `.clone()` function and clone the same value from the memory into another memory spot.
```rust 
let later_reused_value = &value.clone()[6..];
```

But if it wasn't for the borrow checker and all the "headache" it can create would we create performance issues and bugs that we don't like.

But as you might see, the error description is really useful and well-defined. And we also get a more in-depth explanation by running `rustc --explain E0502` in the command line. This is the part the developer behind rust has worked hard on to develop a good developer experience.

## The Rust ecosytem

The people behind Rust have done a really good job when building the ecosystem behind Rust. You can run multiple toolchains concurrent with rustup to run and build for multiple platforms.
When installing rust do you also get Cargo. Cargo is a CLI tool used to run, build, test, and write docs for your application. But also for linting and fixing issues and improving your code with [Clippy](https://github.com/rust-lang/rust-clippy). Clippy is a collection of links that you can run to get help with the design of your code, and also to fix common design issues. But we also do have [rust-analyzer](https://rust-analyzer.github.io/), which is an [LSP](https://microsoft.github.io/language-server-protocol/)(Langauge Server Protocol) that your editor can talk to get features such as autocomplete, go to definitions and documentation of functionality, But also to get real-time error messages within the editor.

The rust community is getting bigger and bigger and more libraries and tooling is created and published to help rust developers. We do see a lot of rust being developed and used in the web space. For example, a lot of rewrites from JavaScript projects into Rust to speed up the tools used for Javascript linting or building projects.

## The developer experience

I found out rust has a really good developer experience, which is something I talked about earlier in this post. Many languages don't provide an easy why-to-understand error message easily which is something Rust has been working hard to achieve. I love that Rust tries to standardize ways of writing stuff and working with the different tooling and so on which is great because we prevent the situation where we have a lot of different ways to write the same code which creates confusion because one developer is experienced in writing the code in 1 way and another developer in another way.

## The end

I love working with rust and love to see the growing community and functionality the language provides. The language is not for everyone, it can be quite hard to work with and sometimes a tiny bit of a headache. But it's flexible, fast, and written well. My initial thought when I started to work with Rust was the design of the language are very well thought out and but it was so hard to understand the borrow checker, but as fast as I started to get a small understanding of how I should write my code was the borrow checker way easier to work with. I don't think Rust is the JavaScript killer which is something I do read mostly on Twitter, and not also the greatest language of all time. But I love to see that other languages are using Rust to enhance the tooling around the language or the language itself.
My goal with the article was to share stuffs I found was really good with rust, There is more stuffs I do enjoy when working with rust but I didn't choose to add them to this article.

I love to get feedback on the article, This is the first article of many I want to write about Rust. If you want to reach out or give feedback, here is my twitter: [https://twitter.com/emil_priver](https://twitter.com/emil_priver)
