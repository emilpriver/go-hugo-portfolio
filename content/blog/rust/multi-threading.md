---
title: "Rust: Multi threading" 
date: 2023-12-25T01:01:27+01:00
draft: false
toc: true
description: "Article about multi threading within rust" 
type: "blog"
tags: ["rust", "multi threading"]
series:
- Rust
images:
  - /og-images/rust-og.jpg
---
Time to dive into multi-threading in Rust, a topic that many developers work with and something that sets Rust apart by enforcing rules to ensure memory safety in your code. A common use case for multi-threaded Rust is building web servers, where each thread can handle different requests.

However, multi-threaded programming can present a few challenges. Rust aims to tackle these challenges by offering compile-time alerts. Some of these challenges include race conditions and deadlocks. Rust also has specific rules for memory management, which you can read more about [here](https://priver.dev/blog/rust/memory-management/). These rules may require you to approach coding differently and consider additional factors. But don't fret about making mistakes, because the Rust compiler will let you know when you compile your code.

One example of the need to adapt your code is the ownership difference between single-threaded and multi-threaded scenarios. In addition to considering ownership between functions and scope, you also need to think about which threads own the data. If you need to modify data in memory, you must also take precautions to avoid race conditions and related issues.

By default, Rust follows a 1:1 model, where each language thread corresponds to one operating system thread. However, there are other crates (e.g., tokio) that work differently. In the 1:1 model, Rust makes use of the CPU's threads. So, if you have 16 CPU threads, you can create 16 threads in Rust. It is possible to create more than 16 threads, but you won't see any significant benefits as the threads will simply accumulate.

```rust

use std::thread;
use std::time::Duration;

fn main() {
    thread::spawn(|| {
        for i in 1..10 {
            println!("hi number {} from the spawned thread!", i);
            thread::sleep(Duration::from_millis(1));
        }
    });

    for i in 1..5 {
        println!("hi number {} from the main thread!", i);
        thread::sleep(Duration::from_millis(1));
    }
}
```

In the example above, Rust spawns two threads on the kernel, which are controlled by the kernel itself for their creation and destruction. This differs from Tokio's model, which also allows green threads (tasks) that execute on top of the kernel threads. One distinction between kernel threads and green threads is the responsibility for creating and destroying threads, which lies either with the kernel or the application. Green threads are useful when performing I/O operations, as they can handle situations where the program waits for a response, such as within an HTTP call. With green threads, you can switch to a different task while the first task is waiting for a response.

It's important to note that a thread is not guaranteed to finish if the `main()` function stops executing before the thread is done. If the `main()` function exits before the thread completes, all threads associated with the application may be terminated. However, in Rust, when you create a new thread, it returns a `JoinHandle` which allows you to wait for the thread to finish before terminating the application.

```rust
use std::thread;

fn main() {
    let v = vec![1, 2, 3];

    let handle = thread::spawn(move || {
        println!("Here's a vector: {:?}", v);
    });

    handle.join().unwrap();
}

```

By using `handle.join().unwrap()`, you can make sure that the program doesn't exit before the thread is finished.

## Async rust

Using OS threads instead of something like async Rust has a drawback. OS threads are considered to be costly, which means they use system resources even when not actively running tasks. This puts a heavier burden on the system when creating and deleting these threads. Additionally, CPU resources are needed to schedule the threads, requiring additional CPU resources for switching between system calls. Moreover, the application does not have direct control over the execution of the thread since it is managed by the operating system.

OS threads are more suitable if you only require a few threads running with the ability to prioritize them. However, for most tasks involving normal async operations, using async Rust works perfectly fine and does not have any disadvantages compared to OS threads.

This is where async Rust comes in handy. Async Rust differs from other languages (like almost everything else, Rust loves to be different) by only providing an interface for async within Rust, but not a runtime. The runtime is taken care of by Rust crates (such as Tokio), and most of the time, green threads work just fine for parallel execution.

Async tasks (green threads) work by the runtime spinning up a couple of heavy threads (OS threads) and adding a layer on top of these threads to handle tasks. The benefit of this approach is that it's more cost-effective for the system, as the application is in charge of scheduling, creating, and terminating tasks. Additionally, the OS is unaware of the tasks created by the application; it only knows about the OS threads.

Async Rust is unique compared to other languages because a `Future` (an asynchronous task) only advances when it is polled. This means that instead of blocking other tasks if the future is not ready, the application waits until the task is ready and then continues. Rust's crates handle the runtime, providing both single-threaded and multi-threaded runtimes, each with their own advantages and disadvantages.

There are also some differences in how you create and write threads.

```rust
use std::thread;

fn main() {
  let thread_one = thread::spawn(|| {
    println!("Hello from thread one!");
  });

  let thread_two = thread::spawn(|| {
    println!("Hello from thread two!");
  });

  thread_one.join().unwrap();
  thread_two.join().unwrap();
}

```

In this example, we create two threads that print values, then we await the first one and then the second one.

Creating async tasks requires you to specify the function as async, and `join()` is now changed to `await`.

```rust
use tokio;

#[tokio::main]
async fn main() {
  let one = tokio::spawn(async {
    println!("Hello from one!");
  });

  let two = tokio::spawn(async {
    println!("Hello from two!");
  });

  one.await.unwrap();
  two.await.unwrap();
}
```

Switching between OS threads and async tasks can be a major code change. Another example of using async/await in Rust is when you retrieve data from a database using SQLX.

```rust
let row: (i64,) = sqlx::query_as("SELECT $1")
    .bind(150_i64)
    .fetch_one(&pool).await?;
```

In the code above, we wait for the result of `fetch_one`, which provides us with a `Future` containing the data.

It's also worth noting that `Future` is similar to a Promise in JavaScript or a goroutine in Go. The concept is the same, but their implementation details differ.

## Ownership between threads

When you're working with memory in Rust, the language has some rules in place to make sure that memory is safe. These rules also apply when you're working with multiple threads, so you still need to follow the ownership and borrowing rules. There are various approaches to handling ownership and borrowing when it comes to multithreading.

```rust
use std::thread;

fn main() {
    let v = vec![1, 2, 3];

    let handle = thread::spawn(|| {
        println!("Here's a vector: {:?}", &v);
    });

    handle.join().unwrap();
}
```

In the example above, we start by creating a vector `v` that holds numbers. Next, we pass this vector into a newly created thread and print its contents. Rust is smart enough to understand that we only want to print the value of `v`, so it passes a reference to the thread for printing. However, when working with threads, a challenge arises because they run in parallel. It is possible for one thread to be terminated before the other finishes executing or before it has a chance to use the reference.

When compiling the code above, you may encounter an error indicating an issue with ownership when a variable is used within a new thread. Fortunately, there is a simple solution to fix this. Just add the `move` keyword before the variable in question.

```rust
 let handle = thread::spawn(move || {
														++++
      println!("Here's a vector: {:?}", &v);
  });
```

What happens now is that we kindly instruct Rust to change the ownership of the data within the memory to be associated with the function running in another thread. This way, Rust can help ensure that your code avoids issues where it points to a memory location that doesn't exist.

## Memory safety between threads

Let's explore the topic of safe memory access between threads, which involves `Mutex`, reference counting (`Rc`), and atomic reference counting (Arc). We'll begin with `Mutex`, which acts as a protector for data. It ensures that only one reference can access the data at a time by preventing others from accessing it when the memory is occupied.

In order to obtain exclusive access to the data, we need to lock the access. In the following example, we acquire a lock for some data and then increase its value to 6. However, please keep in mind that this code functions correctly only in a single-threaded program (I will explain why shortly).

```rust
use std::sync::Mutex;

fn main() {
    let m = Mutex::new(5);

    {
        let mut num = m.lock().unwrap();
        *num = 6;
    }

    println!("m = {:?}", m);
}
```

When the `Mutex` is locked and another thread wants to access the same mutex, the thread politely asks the running process to wait until it has achieved a lock. Therefore, it's important to be mindful when acquiring locks as it could potentially slow down your code. It is advised to lock the mutex right before you need to use or modify it, ensuring a smooth and efficient execution.

However, the issue with the code above is that `Mutex::new(5)` returns a smart pointer to a mutex. You cannot share the smart pointer across threads because doing so would mean transferring ownership of the smart pointer to another thread. Fortunately, there is a solution to this problem called `Arc`. Before we discuss `Arc`, let's briefly talk about `Rc` as they are somewhat related to each other.

`Rc`, short for reference counting, is a great way to enable multiple owners of the same data. Normally, there is only one owner per data, but there are situations where you require more than one owner for the data. For instance, when running something asynchronously and two functions need access to the same data. However, the drawback of `Rc` is that it is designed for single-threaded systems.

The functioning of `Rc` is to keep track of the number of references currently utilizing the data. Once the reference count reaches 0, the data is dropped.

```rust
use std::sync::{Arc, Mutex};
use std::thread;

fn main() {
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];

    for _ in 0..10 {
        let counter = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            let mut num = counter.lock().unwrap();

            *num += 1;
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    println!("Result: {}", *counter.lock().unwrap());
}
```

However, a solution to sharing the same smart pointer between threads is by using `Arc` together with `Mutex`. This approach ensures that the `Mutex` can be shared across threads without the value being dropped. If thread A stops executing while thread B still uses the value within `Arc`, the value will not be lost. The `Mutex` is used to prevent race conditions by locking the value, updating it, and determining the order in which threads are allowed to update the value based on when they acquire a lock on the `Mutex`.

In the example above, we create a new `Mutex` with a value of 0 and then update the value to 10. Before updating each value, we also clone the `Arc` smart pointer to ensure that we get a pointer to the same data as all other threads that clone the smart pointer, without any ownership issues. We store each thread in a variable called `handles`, allowing us to wait for each thread to finish before printing the result, which is `Result: 10`.

## `Send` and `Sync` traits

When discussing the `Mutex` type, it's also beneficial to have a brief understanding of the `Sync` and `Send` traits, as they are relevant when working with threads.

The `Sync` trait allows an object to be used by multiple threads simultaneously, while the `Send` trait ensures that an object can be safely sent between threads. Both traits serve as markers that inform the compiler whether a value can be safely shared or moved between threads. `Sync` is typically used for immutable references, indicating that the referenced data is read-only.

## Message passing between threads

Message passing is a widely used mechanism that allows threads to communicate with each other. It works by creating bridges between threads, enabling them to send and receive messages. The concept of channels in programming is often used to illustrate this idea. As explained in the Rust book:

> You can think of a channel in programming as being similar to a one-way channel of water, like a stream or a river. If you put something like a rubber duck into a river, it will flow downstream to the end of the waterway.
> 

There are various types of channels available, but one of the most commonly used ones is `mpsc`, which stands for multiple producer single consumer channel. The way mpsc works is by creating an mpsc channel and specifying a buffer size. If the buffer becomes full, mpsc will prevent you from sending a new message until one message is removed from the channel.

```rust
use std::sync::mpsc;
use std::thread;
use std::time::Duration;

fn main() {
  let (tx, rx) = mpsc::channel();

  let tx1 = tx.clone();
  thread::spawn(move || {
      let vals = vec![
          String::from("hi"),
          String::from("from"),
          String::from("the"),
          String::from("thread"),
      ];

      for val in vals {
          tx1.send(val).unwrap();
          thread::sleep(Duration::from_secs(1));
      }
  });

  thread::spawn(move || {
      let vals = vec![
          String::from("more"),
          String::from("messages"),
          String::from("for"),
          String::from("you"),
      ];

      for val in vals {
          tx.send(val).unwrap();
          thread::sleep(Duration::from_secs(1));
      }
  });

  for received in rx {
      println!("Got: {}", received);
  }
}
```

In the example above, we start by creating a channel and then make a copy of the `tx` variable. This way, we can have several producers sending messages to the channel simultaneously. Finally, we retrieve the values from the channel and print it.

## `.unwrap()`

Time to unwrap this post. I used the examples from the Rust Book because I found them easy to understand. I hope you learned something, and I would appreciate any feedback you may have. The easiest way to reach me is through my Twitter handle: [@emil_priver](https://twitter.com/emil_priver) 😄
