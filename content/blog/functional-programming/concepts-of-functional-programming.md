---
title: "Concepts of Functional Programming"
date: 2024-01-16T20:01:38+01:00
draft: false
toc: true
description: "This post explores the concepts of functional programming, including immutability, pure functions, higher-order functions, recursion, and more. It also delves into the history of functional programming and introduces Lambda Calculus. If you're new to functional programming or want to deepen your understanding, this post is for you." 
type: "blog"
tags: ["ocaml", "functional programming"]
series:
- OCaml
cover:
  image: "images/ocaml.jpeg"
---
Hello and welcome to this post about the concepts of functional programming. This article is written for developers who want to be introduced to functional programming. The idea is to describe some important concepts within functional programming and then continue discussing OCaml in future posts. The topics covered in this post are:

- Immutability
- Pure functions (isolated functions)
- Higher-order functions
- First-class functions
- Recursion
- Referential transparency
- Statements and Expressions
- Currying and Partial Application

## History

Before we dive into these concepts, let's explore the history of functional programming. Understanding the purpose of functional programming can make it easier for you to write code in a functional style.

Functional programming is based on a mathematical foundation called Lambda Calculus, which was introduced by Alonzo Church in the 1930s. Lambda Calculus provides a formal system for expressing computation through function abstraction and application, using variable binding. This concept goes beyond functional programming and is also used in mathematics, physics, and philosophy.

Lambda Calculus can be understood using the following principles:

- Variable: A variable holds a value and is often represented by equations in math. For example, `x = y * 6` means that `x` is equal to `y` multiplied by 6. In programming, this could be written as `let t = 5 * 6`, where `t` holds the value of `5 * 6`.
- Lambda Abstraction: Lambda abstraction is a way to define a function in Lambda Calculus. A function is written as λx.M, where "λ" represents a function, "x" is the input or parameter, and "M" defines what the function does with that input.
- Application: This is how you use a function. If you have a function M and you want to apply it to an input N, you write it as (M N), similar to calling a function with an argument in programming.

There are also rules for simplifying or 'reducing' expressions in Lambda Calculus:

- **α-conversion**: This involves renaming variables to avoid confusion. If two different functions use the same variable name, you rename them to prevent clashes.
- **β-reduction**: This is where the actual computation happens. β-reduction involves replacing the variable in the function with the actual input value and then simplifying the result.

For example, if your function is λx.(x+2) and your input is 3, applying the function to the input would mean replacing x with 3, resulting in (3+2), which simplifies to 5.

Lastly, there's a concept called De Bruijn indexing, which is an alternative way of writing things to avoid the need for α-conversion. By repeatedly applying these reduction rules, you can reach a point where you can no longer simplify further, known as the β-normal form.

In simpler terms, lambda calculus provides a minimalistic way to describe functions and how they are applied, with specific rules for manipulating these descriptions to obtain results.

However, not all functional programming languages strictly adhere to these rules. For example, LISP, created back in the 1950s, had a limited impact from Lambda Calculus on the language.

## Immutability

The concept of immutability is straightforward: it refers to the inability to change the initial state of a variable. This means that once we create a variable, we cannot modify its initial state. Instead, we need to take the data, use it, and return a new state.

The following code is an example that could work in a non-functional language like Rust (although the code provided is not in Rust, but rather in OCaml, imagine it as an example of how it could look in Rust).

```ocaml
let x = 5 in
x := 10 (* This will result in a compile-time error *)
```

And the example below demonstrates how we can work with data when the language enforces immutability.

```ocaml
let x = 5 in
let y = x + 10 in
```

## Pure functions (isolated functions)

I refer to purge functions as "isolated" functions. By isolated, I mean that nothing outside of the function should be able to alter its output. If you use the same arguments for a function, it should always return the same output. The concept of a pure function is that its output should remain unchanged if the arguments provided to the function are the same. In other words, nothing external to the function should have the ability to modify the output.

An example of a non-pure function is the one below, written in JavaScript:

```jsx
function calculate(input) {
  return input * externalFactor;
}

let externalFactor = 10;

console.log(calculate(5)); // Output will be 50

// Changing the external variable
externalFactor = 20;

console.log(calculate(5)); // Output will be 100
```

And this is an example of a pure function in OCaml:

```ocaml
let square x = x * x

let result = square 5
(* result will always be 25 whenever square 5 is called *)
```

Another characteristic of pure functions is that they don't change any global or local variables, or input/output streams.

## Higher-order and First-class functions

First-class functions are a feature of programming languages that allow functions to be treated as values. This means that functions can be passed as arguments to other functions, returned from functions, or assigned to variables. This concept is often referred to as "first-class citizens" or "first-class objects."

Here is an example in OCaml:

```ocaml
(* Define a simple function *)
let multiply x y = x * y in

(* Assigning a function to a variable *)
let double = multiply 2 in

(* Using the first-class function *)
let result = double 5 in
(* result will be 10, as double is a partial application of multiply with 2 *)
print_int result;
```

On the other hand, higher-order functions rely on the existence of first-class functions. A higher-order function is a function that either takes functions as arguments and executes them or returns a new function.

Here is an example in OCaml:

```ocaml
(* A high-order function that takes a function 'f' and applies it to the number 3 *)
let apply_to_three f = f 3 in

(* A simple function to be used with apply_to_three *)
let square x = x * x in

(* Using the high-order function *)
let result = apply_to_three square in
(* result will be 9, as square is applied to 3 *)

print_int result;
```

## Recursion

Recursion in a functional programming language refers to a function that calls itself within the function until it reaches a base case or condition.

```ocaml
(* A recursive function to calculate the factorial of a number *)
let rec factorial n =
  if n <= 1 then 1
  else n * factorial (n - 1) in

(* Using the recursive function *)
let result = factorial 5 in
(* result will be 120, as the factorial of 5 is 5 * 4 * 3 * 2 * 1 *)

```

Using recursion can be more computationally expensive than using iteration due to the overhead of function calls and control shifting from one function to another. However, there are recursive patterns, such as tail recursion, that the compiler can optimize. A tail recursive function is a function where the only recursive call is the last one in the function.

```ocaml
(* A tail-recursive function to calculate the factorial of a number *)
let factorial n =
  let rec aux n acc =
    if n <= 1 then acc
    else aux (n - 1) (n * acc)
  in
  aux n 1 in

(* Using the tail-recursive function *)
let result = factorial 5 in
(* result will be 120, as factorial of 5 is 5 * 4 * 3 * 2 * 1 *)

```

Recursive functions were created as an alternative to `while` and `for` loops in order to eliminate the need for them. However, it seems that most functional languages still support them, such as [OCaml](https://ocaml.org/docs/if-statements-and-loops#for-loops-and-while-loops).

## Referential transparency

The concept of referential transparency in a functional language is that the initial value of a variable remains constant throughout the program. Instead of directly modifying a variable when we need to change its value, we create a new variable. The benefit of referential transparency is that it helps prevent any side effects that could occur.

### **Equational reasoning**

Equational reasoning is a concept that is often discussed when working with referential transparency. The reason for this is that equational reasoning requires referential transparency in order to be valid. This means that expressions can be replaced with their corresponding values or equivalent expressions without changing the program's behavior. Let's illustrate this with a code example:

```ocaml
let square x = x * x in
let sum_of_squares a b = square a + square b in
```

In this simple code, we define a function called `square` that takes one argument and squares it. Then, we define another function called `sum_of_squares` that takes two arguments and squares both of them. If we later call `sum_of_squares` with the arguments 3 and 4, we get the result of 25.

```ocaml
let res = sum_of_squares 3 4 in
print_int res; (* prints 25 *)
```

So what is the equivalent reasoning of this concept? Well, now that we know that `sum_of_squares` summarizes two `square` function invocations, could we replace `let res = sum_of_squares 3 4 in` with `let res = square 3 + square 4 in` and then continue to break down the function even more with `let res = (3 * 3) + (4 * 4) in` and so on. This only works if the function we work with is a pure function (no side effects) and immutability, as otherwise a variable somewhere else could modify the output every time we run the function with the same arguments, resulting in different output.

## Statements and Expressions

Another topic that I've heard might be good to talk about in relation to functional programming is statements and expressions.

Expressions are elements in programming that are expected to yield a value. Examples include:

- A string with content: "Hello World"
- Function invocations: `square 4 5`

```ocaml
let square x = x * x in
let result = square 5 in
```

Statements are actions that a program takes, but they do not yield a value. A good example of this is if/else statements, which allow the program to operate within the program.

```ocaml
let x = 5 in
if x > 10 then
	print_string "Hello World";
```

## Currying and Partial Application

Currying and partial application is also 2 terms that I’ve heard might be something good to add and they also seem to be easy to mix up. Currying means pretty much that you are able to transform multiple arguments into sequence of functions. Example:

```ocaml
(* Define a function that takes two arguments *)
let add x y = x + y in

(* Currying: Transform 'add' into a function that takes one argument and returns another function *)
let add_curried x = (fun y -> add x y) in

(* Usage *)
let add_to_5 = add_curried 5 in (* This is now a function that adds 5 to its argument *)
let result = add_to_5 7 in      (* result is 12 *)
print_int result;
```

Currying is a useful technique when we want to pre-load a function before running it step-by-step, especially when we don't know all the arguments yet. Essentially, currying means "taking one argument at a time, no more, no less".

One example of currying in OCaml is `Array.iter`, where the function passed to `Array.iter` is executed with each element of the array.

```ocaml
let ids = Array.init 10 (fun i -> i + 2) in
Array.iter
  (fun i ->
    Printf.printf "%d" i;
    print_newline ())
  ids;

(* This would print *)
2
3
4
5
6
7
8
9
10
11
```

In the example above, the variable `i` in `fun i ->` changes with each iteration of the array `ids`.

Partial application, on the other hand, allows us to provide the available arguments instead of one argument at a time. This means that if we have a function that takes 3 arguments and we only have 2 of them, we can pre-load the function by passing in the 2 arguments we have and add the third argument later when we have it.

Code example

```ocaml
(* A function that takes three arguments *)
let multiply x y z = x * y * z in

(* Partially applying the first argument *)
let multiply_by_2 = multiply 2 in

(* Now 'multiply_by_2' is a function that takes two arguments. *)
(* We can apply the remaining arguments *)
let result = multiply_by_2 3 4 (* This will be 2 * 3 * 4 = 24 *) in
print_int result;

```

## The end

Thank you for reading this. The purpose of this post is to prepare for more OCaml content. I believe it is easier to grasp the concept of functional programming before actually writing functional code. Many things become clearer when you start coding, but reading about it also helps to make sense of it all.

I want to express my sincere gratitude to everyone in the Caravan Discord community. When I asked if there was anything else I should cover, people responded happily. If you're interested in joining a Discord community full of functional programming enthusiasts, here is the link: [Caravan Discord Community](https://discord.gg/cvSTjvxDfU).

Sometimes I post about OCaml and Rust on my Twitter page, https://twitter.com/emil_priver. If you find that interesting, feel free to check it out! And if you think there's something missing in this post, don't hesitate to reach out to me.
