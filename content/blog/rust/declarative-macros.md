---
title: "Rust: Declarative macros"
date: 2023-02-11T23:00:45+01:00
draft: false
toc: true
description: "Article about developing declarative macros in Rust" 
type: "blog"
tags: ["rust", "macros"]
series:
- Rust
- Rust Macros
cover:
  image: "/og-images/rust-og.jpg"
---
Let's discuss Macros. They are one of many features in Rust that help you write better software. Macros enable you to write concise, clear code and reduce repetition.

## Introduction

Macros are not functions, but can be called as if they were. They help write less code efficiently and are a useful tool for Rust applications. Macros are a way of writing code that generates other code, known as *metaprogramming*. *Metaprogramming* is a way for a program to write or manipulate other programs. It's like building a house: you don't want to do everything yourself, so you create a plan or instructions for people helping you build your house. The same is true for Macros in Rust: you provide instructions to the compiler so it knows which code to expand into your codebase.

There are different types of declarative macros:

- Custom `#[derive]` functions, which are used on structs and enums to specify attributes in the enum or struct.
- Attribute-like macros that define custom attributes that can be used on any item. An example of this type is `cfg-if`, which can be used to, for example, enable a function only if the target build is Linux.
- Function-like macros that look like functions but operate based on the input arguments passed into them. An example of this type is `println!()`, which prints based on the input args.

Macros are useful for reducing the amount of code you write and maintain, as well as simplifying your code by writing less of it. They are also created to help you write less code.

Macros are often compared to functions, as they work similarly, but there is a difference between the two. Macros allow for a dynamic set of inputs, compared to functions which require you to specify each input. Macros allow you to dynamically define inputs or parameters, as they are implemented and used during build time, while functions are used during runtime.

`println!()` is a good example of a macro that allows you to define multiple inputs. `println!()` can be used to print a static message to the console:

```rust
println!("Hello World")
```

Macros differ from how functions are called by adding an exclamation mark (`!`) to the macro name. For example, the following code can be used to print a dynamic message by passing in variables:

```rust
let name = "World".to_string();
println!("Hello {}", name);

```

### Matchers

Macros are defined using *matchers*, which are used to let Rust understand what the macro does. The syntax for defining a macro is `()` (the Matcher) and `{}` (the Transcriber). When Rust compiles the code and reads the macro, it matches the code inside the Matcher to determine what it should expand into, using the value inside the Transcriber. The matching process is an important part of the macro definition, as it allows Rust to understand what the macro should do.

Inside the Matcher, you can parse expressions you want to match on, such as `($name:expr)`. Here, `expr` is the type that the compiler matches on and `$name` is the variable or value that the Transcriber uses when expanding the code. The matching process can also be done with `{}` and `[]`, if you'd like to match on more complex expressions.

For example, you can use the following code to create a macro that matches on a pair of curly braces:

```rust
macro_rules! match_curly_braces {
    ({ $($inner:tt)* }) => {
        // Code to execute when a pair of curly braces is matched
    };
}

```

In the same way, you can also create a macro that matches on a pair of square brackets:

```rust
macro_rules! match_square_brackets {
    ([ $($inner:tt)* ]) => {
        // Code to execute when a pair of square brackets is matched
    };
}

```

The code won't work yet, as we still need to develop the Transcriber functionality, which allows us to expand the code depending on what is matched by the Matcher. This is the next step in creating macros in Rust.

[Rust Playground link](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=4280b8ae234de097e6737389dd93b75b)

### Macro parameters types

Macros have different types of parameters inputs that you can use to create your macro, such as:

- `item`: an item, like a function, struct, module, etc.
- `block`: a block; a Rust block is a group of statements that are executed together as a single unit, delimited by curly braces (`{` and `}`).
- `stmt`: a statement; something that performs an action and does not return anything.
- `pat`: a pattern; patterns are a way of specifying the structure of values, such as literals, variables, or more complex data structures.
- `expr`: an expression; expressions in Rust are codes that return a value, for example `5 + 10`.
- `ty`: a type; types are labels that specify the kind of value a variable or expression can hold.
- `ident`: an identifier; identifiers are names used to identify a variable, function, type, constant, module, or any other item.
- `path`: a path; paths are a way to refer to an item, such as a module, a struct, an enum, a function, or a constant, by its fully-qualified name.
- `meta`: a meta item; meta items refer to information about the code that’s not part of the code but which is used by the compiler.
- `tt`: a single token tree; single token trees are sequences of one or more tokens that can be treated as a single unit when expanding macros.
- `vis`: a `Visibility` qualifier; visibility qualifiers are used to control the visibility and accessibility of items, such as functions, structs, enums, and modules. Two of these visibility qualifiers in Rust are `pub` and `pub(crate)`. You can read more about this [here](https://doc.rust-lang.org/reference/visibility-and-privacy.html).

### Procedural macros

This article focuses mainly on declarative macros, which are defined using `macro_rules!`. It's also worth mentioning procedural macros, which are widely used and provide a powerful way to extend the Rust programming language. For example, procedural macros can be used to add custom behaviors to structs and to generate boilerplate code using `#[derive(Serialize)]`. This type of procedural macro expands to an implementation of the `Serialize` trait, meaning that the struct will automatically be serialized when it is used with a serialization library. As a result, procedural macros can be very useful for speeding up development time. For more information, see the Rust docs [here](https://doc.rust-lang.org/reference/procedural-macros.html). They provide a detailed overview of how to create and use procedural macros, as well as the various features and advantages of using them.

## Defining a simple macro

We can create powerful macros with Rust's `macro_rules!`, which is itself a macro. Macros are a powerful way to extend the Rust language to do things that may not be possible using functions, or even to simplify complex tasks into something that can be called with a few lines of code. As an example, we can use the one from the [Rust Book](https://doc.rust-lang.org/rust-by-example/macros.html):

```
// This is a simple macro named `say_hello`.
macro_rules! say_hello {
    // `()` indicates that the macro takes no argument.
    () => {
        // The macro will expand into the contents of this block.
        println!("Hello world!");
    };
}

fn main() {
    // This call will expand into `println!("Hello");`
    say_hello!()
}

```

This macro, named `say_hello`, takes no arguments and prints "Hello world!" to the console. It is a simple example of how macros can be used to extend the language, or even to simplify complex tasks. Macros can be used to automatically generate code that would otherwise need to be written manually, or to provide a layer of abstraction over complex tasks. With the right combination of macros and functions, it is possible to produce powerful programs that would otherwise be difficult to write.

## Adding parameters to macro

Next, we need to add parameters to our macro, which is similar to adding parameters to functions, but it has the additional capability of accepting dynamic values as inputs. This means that we can have both two and five parameters in the same macro. We'll continue using the example from earlier, and in this case, we'll add more functionality to the macro. We want to add the option to print the input we provide, after "Hello". To achieve this, we can use the following code snippet:

```
macro_rules! say_hello {
    ($a:expr) => {
        println!("Hello {}!", $a);
    };
}

fn main() {
    say_hello!("Rust");
}

```

The output of this macro should be:

```
Hello Rust!

```

The above macro takes the input provided, which in this case is "Rust", and prints it after the "Hello" string. This is a simple example of how adding parameters can help to add more functionality to a macro. By using this technique, you can create macros with more complex logic, such as if-else statements and looping structures, which can be used to create powerful macros to automate tedious programming tasks.

## Making the macro more advanced

Macros are incredibly powerful and enable us to create complex functions by allowing us to pass in dynamic parameters. This can be done in an incredibly simple way, making it a great tool for developers to utilize. We can further extend our macro by adding more dynamic parameters, allowing us to customize our functions even more. For example, the following code snippet sing our earlier created macro `say_hello` that takes two parameters, one required and one optional:

```
macro_rules! say_hello {
    ($a:expr) => {
        say_hello!($a, "this is the default if you only pass in one required parameter")
    };
    //  the trailing * means that we can add inifity amount of parameters with same type as $opt variable
    ($a:expr, $($opt:expr),*) => {
        {
            print!("Hello {}! ", $a);
            $(
                print!("{}", $opt);
            )*
        }
    };
}

fn main() {
    say_hello!("Rust", "I ", "like ", "pizza");
    println!("");
    say_hello!("Rust")
}

```

[Rust Playground link](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=6667867206eaf0e3dda64c41c1a6897c)

The macro `say_hello` enables us to pass in two or more parameters, with only two being required. This makes it possible to customize the output.. By passing in the optional parameter, we are able to add more information to the output of the macro. For example, if we pass in the argument `"I", "like", "pizza"`, the output of the macro will be `"Hello Rust! I like pizza"`. This way, by utilizing macros, we can create powerful functions that can be customized to suit our needs.

We can match on various parameters, such as statements or the parameter divider argument. This time, we change `,` to `;`, which allows us to call our macro using `say_hello!("Changed divider char to ;"; 1 > 2)`. This is easily done in the code by editing the parameter input from

```rust
    ($a:expr, $b:expr)

```

to

```rust
    ($a:expr; $b:expr)

```

### Full example macro that I’ve been working with writing this post:

```rust
macro_rules! say_hello {
    ($a:expr) => {
        say_hello!($a, "this is the default if you only parse in 1 required parameter")
    };
    // if second statement is type i64
    ($a:expr; i64) => {
        {
            say_hello!($a, "as int")
        }
    };
    // check if the second value is a expression
    ($a:expr; $should_print:expr) => {
        {
            if $should_print {
                say_hello!($a)
            }
        }
    };
    ($a:expr, $($opt:expr),*) => {
        {
            print!("Hello {}! ", $a);
						// this expression itterate over all added dynamic parameters to the $opt variable and print it.
            $(
                print!("{}", $opt);
            )*
        }
    };
}

fn main() {
    say_hello!("Rust", "I ", "like ", "pizza");
    println!("");
    say_hello!("Rust");
    println!("");
    say_hello!("Statement. I am printed"; 2 > 1);
    println!("");
    say_hello!("This is not printed"; 1 > 2);
    say_hello!("integer"; i64)
}
```

Same example on Rust playground can be found [here](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=2de881fae5e874d12db7969482ddb5f9).

## Conclusion

Macros are a powerful tool in Rust that allows you to write less code and maintain it more easily. They are a way of writing code that writes other code, and are used to reduce the amount of code you write and maintain. Macros are defined with matchers and transcribers, and can take different types of parameters. With macros, you can dynamically define inputs or parameters, as they are implemented and used during build time, compared to functions which are used during runtime.

I love using macros to speed up development, as I can create macros that do different tasks for me. Recently, I found them useful when developing HTTP error messages and didn't want to keep writing the same code. I have had some minor issues when developing more complex macros that need to match different inputs. Most of the problems have been related to the order of the matches in `macro_rules!`.

I love feedback and would appreciate hearing any you have! If you need to reach me, you can find me on Twitter at [https://twitter.com/emil_priver](https://twitter.com/emil_priver).
