---
title: "Rust: Memory Management"
date: 2023-11-27T10:31:53+01:00
draft: false
toc: true
description: "Article about working with the memory within rust" 
type: "blog"
tags: ["rust", "memory management"]
images:
  - /og-images/rust-og.jpg
---
Rust is an amazing low-level language that empowers users to work directly with memory. It provides developers with both thread-safety and memory safety, which are fantastic features. This post is all about working with memory in Rust and covers interesting topics such as the stack, heap, and the `.clone()` method.

Rust keeps its promise of ensuring memory safety to developers through its ownership system. Unlike other systems languages that rely on garbage collection or require manual memory management, Rust intelligently manages memory through a system of ownership rules that the program must follow in order to compile. The best part is that this system does not have any negative impact on the performance of the code.

## Some words that are good to know

- Pushing to the heap/stack: This means adding data to the memory.
- Dropping memory: This refers to releasing memory resource that is no longer used.
- Allocation: This process involves checking where Rust can store data in the memory by analyzing the size of the data and finding a slot that is either equal to or larger than the data.
- Deallocation: This refers to removing data from the memory and freeing up space in the memory.

## The Stack and the Heap

When we talk about memory management in Rust, there are two terms that we often use: "Stack" and "Heap". As developers, we work closely with these concepts, and one way to describe them is that the stack is like a local space that we can access within a function, while the heap is like a global space that we can access throughout our code. There are some differences between the two. The stack has a limit on how much data we can store per memory slot, and it is only local to the function. On the other hand, the heap is accessible globally within our code and only limits is the memory limit you have on your machine. However, it is slower compared to the stack.

```rust
fn hello() {
    let s1 = String::from("Hello World"); // The variable "s1" is initialized and stored on the heap
} // s1 has been dropped and no longer exists due to that the scope ends.
```

There are also some differences between the stack and the heap in how they handle data allocation in memory. The stack doesn't actually allocate memory; it simply pushes and stores the data. On the other hand, the heap performs an allocation before storing the value. When you push data to the heap, it looks for a suitable memory location to allocate and store your data, and then it gives you a reference to the memory slot where the pushed data is stored.

The stack operates on the principle of "first in, last out," which means that the data stored first on the stack is the last one to be removed. So, when your function is completed, the variable that was defined first within it will also be the last value to be dropped. In simple terms, a "stack" refers to all the variables you define within a function, in the order you define them.

```rust
fn main() {
    let s1 = String::from("Stack item 1");
    let s2 = String::from("Stack item 2");
    let s3 = String::from("Stack item 3");
    let s4 = String::from("Stack item 4");
    let s5 = String::from("Stack item 5");
}
```

In the given function, we create five variables, which leads to a stack of five items (s1, s2, s3, s4, s5), all containing references to memory slots. This group of variables created within the function is also known as a "stack frame.” 

## .clone()

It's time to discuss `.clone()`, the function that, for many, can be seen as a temporary solution to avoid dealing with memory in Rust, which is considered "the more effective and better approach". This is also a function that I relied on a lot, maybe even too much, at the beginning of my Rust journey. Especially when it's nearly 5pm on a Friday and it's time to head home from work, and you really don't want to deal with the borrow-checker any longer, a simple `.clone()` might seem like an appealing solution. However, it's important to be cautious with excessive use of `.clone()`. While it may make you and the rust compiler happy, it can lead to less efficient code and unnecessary memory consumption.

When you invoke `.clone()` in Rust, it duplicates the data from the memory location you wish to clone, finds a place to allocate space, stores the cloned data in that space, and then returns a reference to the new memory location that contains the exact same data as the original. Let's imagine you have a project where you store a substantial amount of data in memory (e.g., in-memory search projects like Meilisearch), and you utilize `.clone()` on a field that stores a JSON blob. In this scenario, it's possible to encounter a memory problem where the program allocates an excessive amount of memory, causing the server to crash, when in reality, you only needed to borrow the value.

Let me provide you with a small code example:

```rust
fn main() {
    let s1 = String::from("I might be a 25 MB wide string stored in memory :O");
    let s2 = s1;
    println!("{s1}");
}
```

In this code above, we will encounter an issue saying "borrow of moved value `s1`, value borrowed after move". A quick and easy solution is to add a `.clone()` on line 3.

```rust
let s2 = s1.clone();

```

However, is it really "good" to do so? Well, no. The reason is that a `.clone()` here is not necessary. Using a reference to `s1` on line 3 would yield the same result without allocating any new memory. This leads to the following result:

```rust
fn main() {
    let s1 = String::from("I might be a 25 MB wide string stored in memory :O");
    let s2 = &s1;
    println!("{s1}");
}
```

## Ownership rules

While discussing the use of `.clone()` vs references, let's explore the next topic: ownership rules in Rust. These rules play a vital role in ensuring memory safety in Rust and might seem a bit challenging at first. However, as you gain experience and embrace the mindset they require, working with memory becomes more manageable.

You can think of the ownership rules as follows:

- Every value in Rust has an *owner*.
- Only one owner can exist at a time.
- When the owner goes out of scope, the value is dropped.

So, what do these rules mean in your code?

```rust
fn print(value: String) {
    println!("{value}");
}

fn main() {
    let s1 = String::from("Hello world");
    print(s1);
    println!("{s1}");
}
```

On line 6, we create a variable `s1` that contains a reference to a memory slot with the value "Hello World". The owner of the data in this memory slot is the variable `s1`. We then pass the variable `s1` to the function `print()`, and afterwards we pass `s1` to the `println!()` macro.

When you compile this code, you will encounter the same error as in the earlier example: "borrow of moved value `s1`, value borrowed after move". This error happens because when we use `s1` as the variable for the `print()` function, we transfer ownership of the data from `s1` to the argument of the `print()` function and its scope. Consequently, `s1` cannot be used to access the data within that scope anymore unless we return the data from `print()` and use the returned data as the value for the last `println!()` macro. Here's the revised code:

```rust
fn print(value: String) -> String {
    println!("{value}");
    value
}

fn main() {
    let s1 = String::from("Hello world");
    let s2 = print(s1);
    println!("{s2}");
}
```

And this code doesn't look great. We should probably consider using a borrow within print instead.

## Borrowing

The next topic is borrowing, which closely relates to ownership rules. Borrowing is a simple concept where you borrow the data from a memory slot using a reference that points to the same memory slot. Rust has two rules for borrowing:

1. At any given time, you can have either one mutable reference or any number of immutable references.
2. References must always be valid.

In the code example above, we have a function called `print()` that takes in one argument called `value`, which is of type `String`. However, when we pass `s1` to the function, we unintentionally transfer ownership to the `value` argument. In this case, we actually just want to print the value without transferring ownership. To achieve this, let's change the type of the `value` argument to be a reference, specifically `&String`. By using a reference as an argument, we can still ensure that `s1` retains ownership while achieving our desired outcome.

```rust
fn print(value: &String) {
    println!("{value}");
}

fn main() {
    let s1 = String::from("Hello World");
    print(&s1);
    println!("{s1}");
}
```

Thanks to now using a reference as an argument, we no longer need to have a return in `print()`. This means that we can now also use `s1` in the macro `println!()` afterwards.

Let’s speak a bit about the first borrow rule.

```rust
fn main() {
    let mut array = vec!["Hello", "World"];

    let last = array.last().unwrap();
    array.push("From");
    array.push("Rust");

    println!("{last}")
}
```

In the code above, we begin by creating a variable called `array` of type `Vec<String>`, which is mutable. Next, we obtain a reference to the last item in the array. Afterward, we append 2 new values to the array and display the value of `last`. However, an error message appears stating "cannot borrow 'array' as mutable because it is also borrowed as immutable." This error occurs because when we add a new value to the array, it allocates new memory for a fresh array and deallocates the old one. Consequently, the variable `last` now points to a deallocated memory slot, causing issues when we attempt to access it.

The second rule is that a variable or reference needs to live long enough for the entire scope. This means that if we create a variable and then use it within a function, we likely need to ensure it has a proper lifetime (more about this later).

```rust
fn highest_value(a: &i64, b: &i64) -> &i64 {
    if a > b {
        a
    } else {
        b
    }
}

fn main() {
    let n1: i64 = 10;
    let n2: i64 = 20;

    let result: &i64 = highest_value(&n1, &n2);

    println!("{result}")
}

```

The reason why it’s not compiling is due to that the code violates the rules of lifetimes.

## Lifetime

Let's explore the fascinating world of memory management, particularly lifetimes. Lifetimes in Rust are akin to superheroes that protect against the premature deallocation of memory slots that are still required within your code. The objective of a lifetime is for Rust to guarantee that each borrow that takes place is a valid borrow, ensuring it doesn't point to deallocated memory.

```rust
fn highest_value<'a>(variable1: &'a i64, variable2: &'a i64) -> &'a i64 {
    if variable1 > variable2 {
        variable1
    } else {
        variable2
    }
}

fn main() {
    let n1: i64 = 10;
    let n2: i64 = 20;

    let result: &i64 = highest_value(&n1, &n2);

    println!("{result}")
}
```

In the previous example, we discussed borrowing in Rust and showed code that would not compile due to missing lifetime annotations. We have now added lifetimes to our function `highest_value`, which tells Rust that the return value in this case has the same lifetime as the arguments and is valid within the same scope.

Rust provides different ways of annotating lifetimes, and one of them is `'static`, which instructs Rust to keep this data in memory until the program terminates.

## That's a `.unwrap()`!

I hope you have gained valuable insights from this article. Working with memory in Rust can be intimidating at first, especially when dealing with the rules (and rust-analyzer). However, once you become familiar with the rules and learn how to navigate them, it becomes much easier.

The beauty of working with memory in Rust is that the mindset you develop can also help you write more memory-efficient and memory-safe code in other programming languages.

I want to give a special shoutout to the awesome YouTube channel [Let’s Get Rusty](https://www.youtube.com/@letsgetrusty) and their video "[The Rust Survival Guide](https://www.youtube.com/watch?v=usJDUSrcwqI)". This video provides excellent explanations, and I have incorporated a similar approach into this article because their examples were well-presented and easy to follow.

I would also like to express my sincere gratitude to Togglebit, who streams at https://www.twitch.tv/togglebit. Togglebit has been incredibly helpful in providing me with valuable feedback on this text. They have a talent for explaining concepts in a way that is accessible to new developers. Furthermore, their unwavering support and willingness to patiently address all of my inquiries have played a vital role in my Rust journey.

I would also like to give a shout out to Trav for providing feedback on this post. You can find them on [Twitter](https://twitter.com/techsavvytravvy) or [Twitch](https://www.twitch.tv/techsavvytravvy).

If you would like to connect, feel free to find me on Twitter: https://twitter.com/emil_priver 😄
