---
title: "Rust: Pointers"
date: 2024-01-10T17:57:34+01:00
draft: false
toc: true
description: "In this article, we explore Rust pointers, starting with an overview of pointers and then focusing on smart pointers. We discuss the concept of pointers in Rust, their usage, and how they differ from direct data access. We also cover different types of pointers, including raw pointers, and highlight their unsafe nature. Additionally, we delve into smart pointers, such as Box, Rc, Arc, and RefCell, explaining their features and use cases. The article aims to provide a comprehensive understanding of Rust pointers and their role in memory management." 
type: "blog"
tags: ["rust", "pointers"]
series:
- Rust
cover:
  image: "images/rust-og.jpg"
---
Let's dive into Rust pointers, a concept that all developers work with in Rust. In this post, we'll give you an overview of pointers and then focus on smart pointers. Pointers in Rust can be a bit confusing for new developers, but don't worry! Our goal with this post is to help you gain a better understanding of them.

If you're not familiar with the terms "stack" and "heap," we recommend checking out [this article](https://priver.dev/blog/rust/memory-management/#the-stack-and-the-heap) before continuing with this post.

So, what exactly is a pointer in Rust? When you create a new variable, Rust stores the value you assign to the variable either on the heap or the stack. Rust then returns a reference to the location where this data is stored. When you use this variable, you don't directly access the data. Instead, you use a reference that tells Rust where the data exists.

A real-world use case would be if you, as the reader, are a variable and you know where the milk in the supermarket is. In this scenario, you are acting as a pointer because you are pointing to where the milk exists. The same logic applies to pointers in Rust: the variable holds the knowledge of where the data in the memory exists.

```rust
let a = "hello rust";
```

In the code example above, we create a variable named `a` which holds the integer value `1337` and is stored at a memory location (e.g., `0xd3e100`). Rust stores this memory on the stack, and you can imagine it looks something like this:

| location | value |
| --- | --- |
| 0xd3e100 | 1337 |

We can also create a pointer that stores the memory location of another pointer.

```rust
let a = "hello rust";
let b = &a;
```

| location | value |
| --- | --- |
| 0xd3e100 | 1337 |
| 0xd3e101 | 0xd3e100 |

However, the type of `b` would not inherit from `a`; it would still be `str`. The type would change from `str` to `&str` because we are now storing a reference to a memory location rather than the memory location itself. To access the value of variable `a` from variable `b`, we would need to dereference it. Dereferencing means accessing the value of a reference rather than the reference. In Rust, it is possible to create a chain of references, which could have a type of `&&&`. This would mean that if you need to access the value of a type with `&&&`, you would also need to dereference it with `***` before the variable.

One useful tip about pointers is to consider using them when you want to store something on the heap. Pointers offer the flexibility to store data on the heap, especially when you are unsure about the data's size or if the size may change over time. A great example of this scenario is when you box a value and work with `dyn` traits, as explained in more detail [here](https://priver.dev/blog/rust/traits/#dyn-traits). In the code example provided on that page, you can utilize the following code to box a client:

```rust
let a = Box::new(client)
```

This creates something like this:

| location | value |
| --- | --- |
| a | 0xd3e100 |

By employing this approach, developers can easily store a struct directly on the heap without the need to determine its size in advance. Instead, they can simply store a reference to the heap location on the stack, which can be accessed later as required.

## References

In Rust, one of the most common pointers you'll come across are `references`. You can easily identify a reference by looking at the type of the variable. Just check if the type starts with an `&`, and that means it's a reference. For instance, if you see a type like `&i32`, you can be sure that it's a reference pointing to data of type `i32`. If you see a type of a pointer starting with `&'a` or `&`, then you are working with a shared (immutable) reference. If you get a type starting with `&mut` or `&'a mut`, then you are working with a mutable reference.

```rust
fn main() {
    let mut data = 10;

    // Mutable reference
    {
        let data_mut = &mut data;
        *data_mut += 5;
        println!("Value after mutation: {}", data_mut);
        // Mutable borrow ends here
    }

    // Immutable references
    let data_ref1 = &data;
    let data_ref2 = &data;

    println!("Value after borrowing immutably (ref1): {}", data_ref1);
    println!("Value after borrowing immutably (ref2): {}", data_ref2);
    // Immutable borrows end here
}
```

[Rust playground link](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=dbb14726259e86bc0b1528312e8387b6)

## Raw pointers

Another type of pointer is raw pointers. Raw pointers are unsafe and not recommended for use unless you have a clear understanding of what you are doing. They can be `null` or `unaligned`, meaning that the memory location they point to may not exist or may be incorrect. You can identify a raw pointer by the types `*const T` or `*mut T`. A raw pointer is essentially a pointer without the knowledge of whether the data it points to exists or not. For this reason, they are considered harmful to your code unless you are fully aware of what you are doing. In the code example below, you will see me using raw pointers to modify and use some data, and I need to mark the code as `unsafe{}` in order to compile successfully.

```rust
fn main() {
    // Creating a raw pointer
    let x = 10;
    let x_ptr: *const i32 = &x;

    // Creating a raw mutable pointer
    let mut y = 20;
    let y_ptr: *mut i32 = &mut y;

    // Accessing values via raw pointers
    unsafe {
        println!("x_ptr points to: {}", *x_ptr);
        println!("y_ptr points to: {}", *y_ptr);

        // Modifying the value pointed to by y_ptr
        *y_ptr += 10;
        println!("y_ptr now points to: {}", *y_ptr);
    }

    // Demonstrating the updated value of y
    println!("The value of y after modification: {}", y);
}
```

[Rust playground link](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=51b4f24910cd808a29484b12b26f5af5)

## Smart pointers

Let's continue this post with smart pointers, which are pointers but with some extra intelligence (obviously). These pointers come with additional metadata and functionality, such as reference counting to make sure that data is not discarded when nobody is using it. So, smart pointers are basically pointers with handy features like keeping track of how many references are using the data or preventing [race conditions](https://en.wikipedia.org/wiki/Race_condition).

One smart pointer that you might not have considered is `String`. The interesting thing about `String` is that it ensures that you always get a UTF-8 string, and its capacity information is stored within its metadata.

### Box

While discussing pointers, let's also talk about `Box` in Rust. `Box` allows us to store data on the heap without specifying the size of the data. Boxes are particularly useful when working with dynamic traits in Rust. Dynamic traits can vary significantly between each struct that implements a trait, as explained [here](https://priver.dev/blog/rust/traits/#dyn-traits). To store this data, we need to box it. Here's an example of how to box data in Rust:

```rust
struct HelloWorld {
    name: String,
}

fn print_type_of<T>(_: &T) {
    println!("{}", std::any::type_name::<T>())
}

fn main() {
    let data = Box::new(HelloWorld {
        name: "hello".to_string(),
    });

    print_type_of(&data);
}
```

[Rust Playground Link](https://play.rust-lang.org/?version=stable&mode=release&edition=2021&gist=03e7bfe363a4b3158c1109696be9bb17)

### Rc and Arc

The next topic to discuss is `Rc` and `Arc` in Rust. Both of these are similar in that they allow multiple ownership of the same data through reference counting. They both return a pointer that the user can work with.

`Rc` stands for Reference counting and works by increasing the number of owners of a memory location by 1 every time a reference to that location is cloned to an `Rc`. This prevents the data from being deallocated when it is still needed. Here is an example usage:

```rust
use std::rc::Rc;

fn main() {
    // Create a new Rc instance
    let rc_example = Rc::new(10);

    println!("Initial reference count: {}", Rc::strong_count(&rc_example));

    {
        // Create another reference to the same Rc instance
        let _rc_clone = Rc::clone(&rc_example);
        println!(
            "Reference count after cloning: {}",
            Rc::strong_count(&rc_example)
        );
    }

    // The cloned Rc is out of scope, so the reference count should decrease
    println!(
        "Reference count after clone is out of scope: {}",
        Rc::strong_count(&rc_example)
    );
}
```

[Rust playground link](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=afaa9f375eeef2f1a41374ff7f450c3d)

However, the problem with `Rc` is that it is designed for single-threaded use only. If you use `Rc` in a multi-threaded application, it can potentially lead to issues. To address this, there is a smarter solution called `Arc`.

`Arc` stands for atomic reference counting and functions similarly to `Rc`. The difference is that `Arc` also locks the value before updating and keeps track of the order in which each owner wants to lock the `Arc`. This means that if we have threads a, b, c, and d, and each requires a lock on the `Arc` simultaneously, each owner thread will be placed in a queue and must wait until it is their turn to access the data.

```rust
use std::sync::Arc;
use std::thread;

fn main() {
    // Create a new instance of Arc
    let arc_example = Arc::new(10);
    println!(
        "Initial reference count: {}",
        Arc::strong_count(&arc_example)
    );

    // Create multiple threads that share ownership of the Arc instance
    let mut handles = vec![];
    for _ in 0..3 {
        let arc_clone = Arc::clone(&arc_example);
        let handle = thread::spawn(move || {
            println!("Thread with shared data: {}", arc_clone);
        });
        handles.push(handle);
    }

    // Wait for all threads to complete
    for handle in handles {
        handle.join().unwrap();
    }

    // Final reference count (should be 1, as all other references are dropped)
    println!("Final reference count: {}", Arc::strong_count(&arc_example));
}

```

[Rust playground link](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=8a7d532394760695f4caa260af44925e)

Something to keep in mind when working with `Arc` and `Rc` is that you should only use `Arc` if you really need it, as it can be more expensive for your application.

### RefCell

RefCell is a really handy functionality that returns a smart pointer when used. It can be compared to `Box`, but there is a significant difference between them. The main difference is that `Box` performs checks during compile time, while `RefCell` performs checks during runtime. This means that instead of getting a compile error, your code will panic. But don't worry, there is a good use-case for using `RefCell`! It comes in handy when you need to bypass checks at compile time. I even suspect that `RefCell` utilizes some `unsafe{}` functionality under the hood. Therefore, if you are not 100% sure about what you are doing, it's better to avoid using `RefCell`.

```rust
use std::cell::RefCell;

fn main() {
    // Create a RefCell containing an immutable value
    let cell = RefCell::new(5);

    // Borrow the value immutably
    let value = cell.borrow();
    println!("The value is: {}", value);
    drop(value); // Explicitly end the immutable borrow

    // Borrow the value mutably
    let mut mutable_value = cell.borrow_mut();
    *mutable_value += 1;
    println!("The mutated value is: {}", mutable_value);
    drop(mutable_value); // Explicitly end the mutable borrow

    // Borrow the value again immutably to see the updated value
    let new_value = cell.borrow();
    println!("The new value is: {}", new_value);
}

```

[Rust playground link](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=90eda31489f3177008459109104dffeb)

While discussing the `RefCell` feature, let's also explore `RefMut` and `Ref`. These buddies work hand in hand with `RefCell` and provide smart pointers. When you invoke the `borrow()` method on a `RefCell`, you receive a `Ref` pointer that enables you to borrow the value. Once the `Ref` is no longer in use, the reference count for the `RefCell` decreases. If the count reaches 0, the `RefCell` will be dropped.

Additionally, `RefCell` offers a function called `borrow_mut` which allows us to borrow the value and make changes to it. Please note that it only permits one mutable reference. So, if you attempt to obtain more than one `RefMut`, the code will panic. If you were to use `Box` instead, this code would fail to compile.

```rust
use std::cell::{Ref, RefCell, RefMut};

fn main() {
    let cell = RefCell::new(String::from("Hello"));

    // Get an immutable reference
    {
        let value: Ref<String> = cell.borrow();
        println!("Value: {}", value);
        // The immutable borrow ends when `value` goes out of scope
    }

    // Get a mutable reference
    {
        let mut value: RefMut<String> = cell.borrow_mut();
        value.push_str(", world!");
        // The mutable borrow ends when `value` goes out of scope
    }

    // Get another immutable reference to see the changed value
    let value: Ref<String> = cell.borrow();
    println!("Changed Value: {}", value);
}
```

[Rust playground link](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=5409577cf6bb49f0b5c96a557bf50a55)

# .unwrap()

Thank you for reading this article. I hope you found it informative, or perhaps it served as a refresher for some. If you have any input or feedback, please don't hesitate to reach out to me on [Twitter](https://twitter.com/emil_priver). If you think there are any changes that could be made, please feel free to contact me or click the "suggest change" button below the title.

There is a thread for comments [here](https://twitter.com/emil_priver/status/1745129442333049026)
