---
title: "OCaml: Introduction"
date: 2024-02-12T00:01:38+01:00
draft: false
type: "blog"
tags: ["Ocaml"]
cover:
  image: "images/ocaml.jpeg"
series:
  - Ocaml
toc: true
description: "Introduction for OCaml, a blog post for developers that want to dig into OCaml"
---
Time to delve into OCaml, a functional programming language that was first released in 1996 and has gained popularity in the academic world. This article is for those who are interested in OCaml and want to learn more about the language. It covers parts that I felt I needed to learn when I started with OCaml, and it's a continuation of the "[concepts of functional programming](https://priver.dev/blog/functional-programming/concepts-of-functional-programming/)" article I wrote a while ago.

Coming from a non-functional background myself, where I've written a lot of Rust and Go, I decided to give a functional programming language a try when Advent of Code started in 2023. OCaml seemed like the perfect choice, especially because it shares some features with Rust, such as matching, options, and pattern matching. However, in my opinion, unlike Haskell, OCaml is not a strict pure functional language.

This post will cover some important aspects when working with OCaml, such as how to define a function, modules, and the REPL. It will also highlight some features that I really like about it.

OCaml, previously known as Objective Caml (Categorical Abstract Machine Language), is a programming language that evolved from the ML programming language. ML is a functional programming language famous for its Polymorphic Hindley-Milner type system, which is derived from the lambda calculus and supports parametric polymorphism. Parametric polymorphism allows code to be written using generic types represented by variables, which can later be instantiated with specific types as needed.

OCaml extends ML with object-oriented features, which are recognized as classes and objects. Classes in OCaml are denoted by the usage of `#`. For example:

```ocaml
class point =
    object
      val mutable x = 0
      method get_x = x
      method move d = x <- x + d
    end;;

let () =
	let p = new point;;
	let int = p#get_x in

	()

```

OCaml is a statically typed language with inferred types, depending on how the value is used. For example:

```ocaml
let print_message message =
  print_endline message

let () =
  print_message "Hello, OCaml world!"
```

In this example, the compiler knows that `print_endline` requires a string type, which is inferred to `print_message`. This means that `print_message` needs a string and will not compile if provided with a different type.

In another functional language such as Haskell, you need to define the type explicitly:

```haskell
printMessage :: String -> IO ()
printMessage message = putStrLn message

main :: IO ()
main = printMessage "Hello, Haskell world!"
```

> If you want to learn more about functional programming in general, I have written a blog post called "[Concepts of functional programming](https://priver.dev/blog/functional-programming/concepts-of-functional-programming/)" where I discuss topics such as immutability and pure functions.
> 

However, sometimes I still define the return type of a function as it can make it easier to define the function. By explicitly stating the return type, the compiler knows what to expect from the function.

## Basic

Let's start by creating a function and a variable and using them.

To create a variable in Haskell, you can use the following syntax:

```ocaml
let variable = "Hello :D" in
```

Here, we create a variable named `variable` and assign the value "Hello :D" to it. The `in` keyword is used to indicate the end of the variable declaration.

The `in` keyword also allows us to pipe functions and store the result in a variable. For example:

```ocaml
let uppercase_string = "Hello World :D" |> String.uppercase_ascii in

print_endline uppercase_string
```

In this example, we demonstrate how to perform multiple functions on the string "Hello World :D" and store only the necessary information in the `uppercase_string` variable. This allows us to call an HTTP API, parse the output, retrieve a value, convert it to uppercase, and store it.

Creating a function can be done in a similar way using `let`. We define the logic inside the function, as shown in the following code:

```ocaml
let hello what_to_say_hello_to =
  print_endline what_to_say_hello_to;
  ()

let () =
  hello "World";
	(* Write more logic here *)
  ()
```

[*Playground*](https://ocaml.org/play#code=CmxldCBoZWxsbyB3aGF0X3RvX3NheV9oZWxsb190byA9CiAgcHJpbnRfZW5kbGluZSB3aGF0X3RvX3NheV9oZWxsb190bzsKICAoKQoKbGV0ICgpID0KICBoZWxsbyAiV29ybGQiOwoKICAoKQ%3D%3D)

In this code, we create a function called `hello` that takes one argument. We use the argument to print something with `print_endline` and then return a unit. A unit represents "nothing", so when we write a function that returns nothing, we actually return a unit. A bigger example of how to write function exists [here](https://ocaml.org/play#code=KCoKICBXZWxjb21lIHRvIHRoZSBvZmZpY2lhbCBPQ2FtbCBQbGF5Z3JvdW5kIQoKICBZb3UgZG9uJ3QgbmVlZCB0byBpbnN0YWxsIGFueXRoaW5nIC0ganVzdCB3cml0ZSB5b3VyIGNvZGUKICBhbmQgc2VlIHRoZSByZXN1bHRzIGFwcGVhciBpbiB0aGUgT3V0cHV0IHBhbmVsLgoKICBUaGlzIHBsYXlncm91bmQgaXMgcG93ZXJlZCBieSBPQ2FtbCA1IHdoaWNoIGNvbWVzIHdpdGgKICBzdXBwb3J0IGZvciBzaGFyZWQtbWVtb3J5IHBhcmFsbGVsaXNtIHRocm91Z2ggZG9tYWlucyBhbmQgZWZmZWN0cy4KICBCZWxvdyBpcyBzb21lIG5haXZlIGV4YW1wbGUgY29kZSB0aGF0IGNhbGN1bGF0ZXMKICB0aGUgRmlib25hY2NpIHNlcXVlbmNlIGluIHBhcmFsbGVsLgogIAogIEhhcHB5IGhhY2tpbmchCiopCgpsZXQgbnVtX2RvbWFpbnMgPSAyCmxldCBuID0gMjAKCmxldCByZWMgZmliIG4gPQogIGlmIG4gPCAyIHRoZW4gMQogIGVsc2UgZmliIChuLTEpICsgZmliIChuLTIpCgpsZXQgcmVjIGZpYl9wYXIgbiBkID0KICBpZiBkIDw9IDEgdGhlbiBmaWIgbgogIGVsc2UKICAgIGxldCBhID0gZmliX3BhciAobi0xKSAoZC0xKSBpbgogICAgbGV0IGIgPSBEb21haW4uc3Bhd24gKGZ1biBfIC0%2BIGZpYl9wYXIgKG4tMikgKGQtMSkpIGluCiAgICBhICsgRG9tYWluLmpvaW4gYgoKbGV0ICgpID0KICBsZXQgcmVzID0gZmliX3BhciBuIG51bV9kb21haW5zIGluCiAgUHJpbnRmLnByaW50ZiAiZmliKCVkKSA9ICVkXG4iIG4gcmVzCgooKgogIEJ5IHRoZSB3YXksIGEgbXVjaCBiZXR0ZXIsIHNpbmdsZS10aHJlYWRlZCBpbXBsZW1lbnRhdGlvbiB0aGF0IGNhbGN1bGF0ZXMKICB0aGUgRmlib25hY2NpIHNlcXVlbmNlIGlzIHRoaXM6CgogIGxldCByZWMgZmliIG0gbiBpID0KICAgIGlmIGkgPCAxIHRoZW4gbQogICAgZWxzZSBmaWIgbiAobiArIG0pIChpIC0gMSkKCiAgbGV0IGZpYiA9IGZpYiAwIDEKCiAgRm9yIGEgbW9yZSBpbi1kZXB0aCwgcmVhbGlzdGljIGV4YW1wbGUgb2YgaG93IHRvIHVzZQogIHBhcmFsbGVsIGNvbXB1dGF0aW9uLCB0YWtlIGEgbG9vayBhdAogIGh0dHBzOi8vdjIub2NhbWwub3JnL3JlbGVhc2VzLzUuMC9tYW51YWwvcGFyYWxsZWxpc20uaHRtbCNzOnBhcl9pdGVyYXRvcnMKKikK). 

## REPL

REPL, or read-eval-print loop, is an interactive interface that developers can use to debug, test, or understand code within their OCaml projects. When writing code in the REPL, the compiler runs checks on your types, compiles, evaluates, and prints the inferred type and result value. The REPL tool for OCaml is called utop and comes with opam and dune.


![REPL](images/ocaml/repl.png)

In the image above, I create a function called `hello` and execute it. In the output, I can see that the function `hello` takes 1 argument of type string and returns a unit (no return). I also create another function called `another_hello` where I call the `hello` function and print some additional values. 

Even if I am not a big user of REPL is it a tool worth mention if you just want to play around with the language and explore your code.

## Modules

This section discusses modules, which are a concept within OCaml that allow us to call functions from another file or create submodules (modules within a file).

In OCaml, files and folders are referred to as modules. We can use the names of the files to call functions within these files. For example, suppose we have two files in the same folder: `one.ml` and `two.ml`. The `two.ml` file contains a function called `greetings` that we want to call from `one.ml` to greet the user. To do this, we would write `let () = Two.greetings ()` in our `one.ml` file. Alternatively, we can use the `open Two` statement to access the `greetings` function without specifying `Two` before calling it:

```ocaml
open Two

let () = greetings ()
```

In addition to modules, we can also create submodules within a file. Submodules work similarly, but instead of the entire file being a module, we define a part of the file as a module by creating a new `Module` within the file. Here's an example:

```ocaml
module Hello = struct
   let greetings () = print_endline "hello"
end

let () = Hello.greetings ()
```

Modules can also refer to packages installed using opam. For example, if we install Riot using `opam install riot` and later want to use Riot within our code, we can call Riot directly or use `open Riot`. In this particular case, we consider Riot to be a module, even if it was imported from outside the project. Example on how we can use Riot in our code:

```ocaml
open Riot

type Message.t += Hello_world

let () =
  Riot.run @@ fun () ->
  let pid =
    spawn (fun () ->
        match receive () with
        | Hello_world ->
            Logger.info (fun f -> f "hello world from %a!" Pid.pp (self ()));
            shutdown ())
  in
  send pid Hello_world
```

## Functors

While discussing modules, it is also important to mention functors. A functor is a construct that takes a module as a parameter and returns a new module.

> The examples in this part are taken from the functors documentation
> 

To explain it further, imagine you need a specific functionality, such as handling sets. However, the required functionality does not exist for `Sets`. In this case, you can create a module that implements the same functions as a `Set` by using a functor.

```ocaml
module StringCompare = struct
  type t = string
  let compare = String.compare
end

module StringSet = Set.Make(StringCompare)
```

In the above example, we create a new `Set` called `StringCompare`, which has a type of `string` and a method called `compare` that calls `String.compare` when needed. With this code, we can now use `StringSet` and its functions.

*Disclaimer: Some functions in this code intentionally do not exist in the "StringCompare" class. The purpose is to demonstrate how it works, rather than providing a perfect example. Including all the necessary code for a perfect example would result in excessive code.*

```ocaml
module StringCompare = struct
  type t = string
  let compare = String.compare
end

module StringSet = Set.Make(StringCompare)

let _ =
  In_channel.input_lines stdin
  |> List.concat_map Str.(split (regexp "[ \\t.,;:()]+"))
  |> StringSet.of_list
  |> StringSet.iter print_endline
```

## Operators

In OCaml, operators allow you to combine one or more values (operands) to create a new value. These operations can involve mathematical calculations, logical evaluations, or manipulation of data structures, among other actions.

### **Arithmetic Operators**

Developers often use arithmetic operations in OCaml to perform mathematical calculations. Let's explore the two types of arithmetic operations:

- **Integer Arithmetic**: This type of arithmetic involves using the operators **`+`**, **`-`**, **`*`**, **`/`** for addition, multiplication, subtraction, and division, respectively.
- **Floating-point Arithmetic**: On the other hand, floating-point arithmetic uses the operators **`+.`** , **`-.`**, **`*.`**  and **`/.`** for addition, multiplication, subtraction, and division, respectively.

And example usage of these are

```ocaml
let sum = 1 + 2;;          (* Integer addition *)
let difference = 5.0 -. 3.0;;  (* Floating-point subtraction *)
```

### **Comparison Operators**

Comparison operations return either `true` or `false`. The most commonly used operands for comparison are:

- **`=`** (equals)
- **`<>`** (not equals)
- **`<`** (less than)
- **`>`** (greater than)
- **`<=`** (less than or equal to)
- **`>=`** (greater than or equal to)

```ocaml
let isEqual = 3 = 3;;          (* true *)
let isGreater = 5 > 3;;        (* true *)
```

### Binary Operators

Binary operators in OCaml are regular functions, but they are used in a slightly different way. A binary operator allows us to simplify development by assigning logic to an operand, which can then be used instead of calling a function. The operand is defined using parentheses and can use the surrounding arguments. In the example below, the arguments are "hi" and "friend".

It is important to note that if you define the operand name with only one character, the operand function will expect only one argument. Therefore, if you want to achieve a result similar to the example below, you need to use two characters when creating the operand.

```ocaml
let cat s1 s2 = s1 ^ " " ^ s2;;
let ( ^? ) = cat;;
print_endline ("hi" ^? "friend");;

```

In this example, we create a function called `cat` that takes two strings and returns a string. Then, we create an operand and assign the `cat` function to it. Later, we use this operand to add a space between "hi" and "friend".

### Binding Operators

Binding operators are quite handy when writing OCaml code as they provide a way to simplify the code. These operators allow us to create custom `let` bindings by assigning them a value. They can be useful in cases where we only want to handle successful values and don't need to handle negative values that may occur in applications. For example, when dealing with an unsuccessful HTTP call, we may only want to handle an OK response, and a binding operator can be a useful tool.

Let's use an example from the operator documentation on [ocaml.org](http://ocaml.org/):

```ocaml
let ( let* ) = Option.bind;;

let doi_parts s =
  let open String in
  let* slash = rindex_opt s '/' in
  let* dot = rindex_from_opt s slash '.' in
  let prefix = sub s 0 dot in
  let len = slash - dot - 1 in
  if len >= 4 && ends_with ~suffix:"10" prefix then
    let registrant = sub s (dot + 1) len in
    let identifier = sub s (slash + 1) (length s - slash - 1) in
    Some (registrant, identifier)
  else
    None;;

doi_parts "doi:10.1000/182";; (* Some ("1000", "182") *)
doi_parts "<https://doi.org/10.1000/182>";; (* Some ("1000", "182") *)
```

In this code, we create a binding operator called `let*` and assign it to `Option.bind`. This allows us to return early if we don't find `/` in the provided string when running `let* slash = rindex_opt s '/'` within the code. Thanks to the `let*`, we no longer need to match the value on `rindex_from_opt`, as we will already return `None` if there is no `/` in the string.

## End

I hope you enjoyed this article. It covers the topics I found necessary to learn when transitioning to OCaml from a background primarily in Go and Rust. The most challenging aspect of starting with OCaml was not the language itself, but rather breaking free from a non-functional programming mindset. An interesting example of this occurred when I shared my Advent of Code challenge with a colleague. He couldn't resist rewriting the entire code because I had used [refs](https://cs3110.github.io/textbook/chapters/mut/refs.html) to solve it.

I want to express my sincere gratitude to everyone in the Caravan Discord community. When I asked if there was anything else I should cover, people responded happily. If you’re interested in joining a Discord community full of functional programming enthusiasts, here is the link: [Caravan Discord Community](https://discord.gg/cvSTjvxDfU).
