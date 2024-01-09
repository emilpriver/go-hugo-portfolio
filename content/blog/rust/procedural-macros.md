---
title: "Rust: Procedural Macros"
date: 2023-04-26T19:33:19+02:00
draft: false
toc: true
description: "Article about developing procedural macros in Rust" 
type: "blog"
tags: ["rust", "macros"]
series:
- Rust
- Rust Macros
cover:
  image: "images/rust-og.jpg"
---
Hello and welcome to the second part of our series on writing Rust macros! In this article, we'll be focusing on procedural macros, which can help extend your functions. If you missed the first part of this series, don't worry - you can find it [here](https://www.priver.dev/blog/rust/macros-in-rust/). If you're not yet familiar with macros in Rust, I highly recommend checking out the first [article](https://www.priver.dev/blog/rust/declarative-macros) where I explain them in an easy-to-understand way. I hope you enjoy this read!

This article covers the three different ways to write procedural macros:

- Custom Derive macros `#[derive(CustomDerive)]`
- Function-like macros `custom!(…)`
- Attribute macros `#[CustomAttributes]`

Procedural macros are defined using the `proc_macro` crate, which provides a set of APIs for parsing Rust code, manipulating the syntax tree, and generating new code. When Rust compiles your code, it parses the inputs as a stream of tokens. The macro later uses these tokens to generate more code.

## Procedural vs Declarative Macros in Rust

There are significant differences between procedural and declarative macros in Rust. One of the biggest differences is that procedural macros operate over token streams to generate new code at compile time, while declarative macros generate code that matches a pattern at compile time. Procedural macros are defined as functions that take a TokenStream as input and output a TokenStream.

Declarative macros, on the other hand, use patterns to understand what code to generate based on rules defined using `macro_rules!`. Declarative macros are easier to write but are not as flexible as procedural macros.

If you need to generate complex or dynamic code at compile time, a procedural macro is probably the way to go. However, if you need to generate static code that matches a specific pattern, a declarative macro is likely the best choice.

## Custom Derive Macros

Derive macros are used to add functionality to structs, enums, and unions. Two famous examples of derive macros are `Serialize` and `Deserialize`, which make it easy to serialize and deserialize Rust structs to and from JSON.

Here is an example of adding the `Serialize` macro to a JSON struct:

```rust
#[derive(Serialize)]
struct MyStruct {
	pub hello: string
}
```

Building a derive macro is fairly easy and can be done using the `proc_macro_derive` macro. First, you need to define that you are building a derive macro, and then you need to define the name for your macro. This is an example of how you could implement this:

```rust
#[proc_macro_derive(YourMacroName)]
pub fn your_macro_name_derive(input: TokenStream) -> TokenStream {
    // Your macro implementation goes here
}
```

In this example, we create a macro named "YourMacroName" that we will later use to add functionality to our struct `MyStruct`.

Adding functionality to your struct using `YourMacroName` is easy. Simply parse the `proc_macro::TokenStream` passed into the function. In this example, we created the `YourMacroName` macro and want to add functionality to it that we can use in our projects. One simple functionality is to print the name of the struct that uses this derive macro. This can be demonstrated below:

```rust
#[proc_macro_derive(YourMacroName)]
pub fn your_macro_name_derive(input: TokenStream) -> TokenStream {
		// Parse the input tokens into a syntax tree
    let name = syn::parse(input).unwrap();

    // Generate the implementation of the trait
    let gen = quote! {
        impl MyTrait for #name {
            fn my_trait_method(&self) {
                println!("MyTrait method called for struct {}", stringify!(#name));
            }
        }
    };

    // Return the generated code as a token stream
    gen.into()
}
```

To use this macro later on, add `YourMacroName` as an argument to your struct. For example:

```rust
#[derive(YourMacroName)]
struct MyStruct {
    field1: u32,
}

let my_struct = MyStruct {
    field1: 42,
};
```

You should then be able to call our new function `my_trait_method` using the following syntax:

```rust
println!("{:?}", my_struct.my_trait_method())
```

### **Derive macro helper attributes**

In addition to creating the actual derived functionality, `derive` macros can also generate *derive macro helper attributes* that are added to the scope of the item they are defined on. These attributes, while not serving any purpose on their own, are crucial for the functionality of the derive macro that created them.

Their inclusion in the item's scope allows for the custom behavior of the derive macro to be executed seamlessly, without impacting the rest of the codebase. This can be especially useful in larger codebases where the modification of existing code can be difficult and time-consuming. By generating these attributes, derive macros can ensure that the derived functionality is added to the codebase with minimal hassle and disruption.

Defining attributes for use in a macro is easy. Simply add `attributes(..)` when creating your macro, like this:

```rust
#[proc_macro_derive(MyCustomDerive, attributes(my_attribute))]
pub fn my_custom_derive_macro(input: TokenStream) -> TokenStream {
    // Parse the input tokens into a syntax tree
    let input = syn::parse_macro_input!(input as DeriveInput);

    // Get the name of the struct or enum we're deriving MyCustomDerive for
    let name = input.ident;

    // Get any attributes defined on the struct or enum
    let attributes = input.attrs;

    // Iterate over the attributes and do something with them
    for attribute in attributes {
        if attribute.path.is_ident("my_attribute") {
            // Do something with the attribute value
            let attribute_value = attribute.parse_args::<syn::LitInt>().unwrap();
            println!("Found my_attribute with value {}", attribute_value.value());
        }
    }

    // Generate the code for the new type that implements MyCustomDerive
    let output = quote! {
        impl MyCustomDerive for #name {
            fn do_something(&self) {
                // Do something here
            }
        }
    };

    // Return the generated code as a TokenStream
    TokenStream::from(output)
}
```

We can now use this attribute later on.

```rust
#[derive(MyCustomDerive)]
#[my_attribute = 42]
struct MyStruct {
    // Struct fields here
}

fn main() {
    let my_struct = MyStruct { /* Initialize struct fields here */ };
    my_struct.do_something(); // Call the generated method
}
```

## Function-like macros

The next type of macro to discuss in this article is the function-like proc-macro. Function-like macros are invoked using the macro invocation operation `!`. These macros are invoked at compile time and read the input of the macro, then create an output that is added to the codebase. An example of a function-like macro taken from the official [Rust documentation](https://doc.rust-lang.org/reference/procedural-macros.html) is:

```rust
extern crate proc_macro;
use proc_macro::TokenStream;

#[proc_macro]
pub fn make_answer(_item: TokenStream) -> TokenStream {
    "fn answer() -> u32 { 42 }".parse().unwrap()
}
```

The function-like procedural macro shown in the code block ignores any input provided to it and instead generates a new function called `answer`. This new function has a return type of `u32` and always returns the value `42`.

The primary purpose of this macro is to create the `answer` function, which can then be used elsewhere in the codebase. For example, in the code snippet provided below, the `make_answer` macro is invoked, which generates the `answer` function. The `answer` function is then called later on to print the value `42`:

```rust
extern crate proc_macro_examples;
use proc_macro_examples::make_answer;

make_answer!();

fn main() {
    println!("{}", answer());
}
```

Function-like procedural macros can be used like any other macro, in places like statements, expressions, patterns, types, and items. This includes items within `extern` blocks, inherent and trait implementations, and trait definitions.

## Attribute macros

Attribute macros are a type of Rust macro that allow you to define attributes that can be used with items to add extra functionality. These macros are incredibly useful for simplifying code and making it more readable. One widely used example of an attribute macro is `tokio::main`. This macro is used to specify that a function should be run as the main function of a tokio-based application. By using this macro, you can avoid having to write a lot of boilerplate code and focus on the functionality you want to add to your application.

In addition to `tokio::main`, there are many other attribute macros available in Rust. These include macros for specifying that a function should be run as a test, macros for controlling the visibility of items, and macros for generating code at compile time.

Overall, attribute macros are an incredibly powerful feature of Rust that can help you write cleaner, more readable code. By using these macros, you can simplify your code and focus on what really matters: the functionality you want to add to your application.

The `tokio::main` macro is used, for example, like this:

```rust
#[tokio::main]
async fn main() {
    println!("hello");
}

```

Thanks to the attribute macro, the code can be extended as follows:

```rust
fn main() {
    let mut rt = tokio::runtime::Runtime::new().unwrap();
    rt.block_on(async {
        println!("hello");
    })
}
```

Creating a new attribute macro is not difficult and is very similar to other procedural macros. You use the `proc_macro` crate's `proc_macro_attribute` trait in combination with a function. The function takes two `TokenStream` inputs and outputs a `TokenStream`. An example of a simple attribute macro is shown below:

```rust
#[proc_macro_attribute]
pub fn my_attribute_macro(_attr: TokenStream, item: TokenStream) -> TokenStream {
    // Parse the input function
    let input = parse_macro_input!(item as ItemFn);

    // Generate some new code to replace the original function
    let new_code = quote! {
        #input

        println!("This is a custom message from my_attribute_macro!");
    };

    // Return the new code as a TokenStream
    TokenStream::from(new_code)
}
```

This macro takes the input added to the body of the function that it is attached to, and adds a `printLn(...)` statement to the end of the function. It then returns the new function as a TokenStream, and all of this is done during compile time.

The example above can be used as follows:

```rust
#[my_attribute_macro]
fn my_function() {
   println!("hello");	
}
```

which would output:
```
hello
This is a custom message from my_attribute_macro!
```

## Ending

This article discusses procedural macros in Rust, which can extend functions. Three types of procedural macros are covered: custom derive macros, function-like macros, and attribute macros. Custom derive macros add functionality to structs, enums, and unions, while function-like macros are invoked using the macro invocation operation `!`. Attribute macros allow you to define attributes that can be used with items to add extra functionality. The `proc_macro` crate is used to define procedural macros, which parse Rust code, manipulate the syntax tree, and generate new code.

The code examples above were generated using ChatGPT, and this article is not associated with the Rust Foundation in any way.

I hope you enjoyed this article, and I look forward to your feedback!  😀
