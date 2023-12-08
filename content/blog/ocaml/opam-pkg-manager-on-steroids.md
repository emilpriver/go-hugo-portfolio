---
title: "Opam: Package Manager on Steroids?"
date: 2023-10-12T20:38:24+02:00
draft: false
type: "blog"
tags: ["Ocaml"]
images:
  - /og-images/ocaml.jpeg
toc: true
description: "Opam: Package Manager on Steroids?"
---

# Opam

Hey there! I've been exploring OCaml and I have to admit, I don’t know what I feel about opam yet. As far as I understand, opam is a package manager or environment of some kind. We'll discuss opam in more detail and share my thoughts on it later.

But before we dive into that, let me provide you with some information about OCaml.

## Short about OCaml

OCaml, also known as Objective Caml, is a programming language that is widely recognized for its awesome type inference, functional programming features, and static type checking. It was developed in the late 1990s as an improved version of the Caml programming language.

OCaml is rooted in the ML (MetaLanguage) family of programming languages, which are all about static typing and type inference. It combines cool functional programming concepts, like first-class functions and pattern matching, with imperative and object-oriented programming paradigms. This lets developers write code that is both super expressive and concise, while still being fast and efficient.

OCaml has gained popularity in various fields, including compiler development, formal verification, and algorithmic trading. It is well-known for its robust and efficient runtime system, which does native code compilation and even has garbage collection.

In summary, OCaml gives developers a powerful and expressive language for creating reliable and efficient software. This makes it a popular choice among developers who are all about strong static typing and functional programming.

The intial compiler for rust was written in OCaml.

## Opam

Ok, let's talk about opam, the package manager for OCaml. When I started working with opam, I didn't have any particular issues. However, when jumping between projects, I discovered some things:

- There is no lock file.
- Opam is probably not only a package manager.

Regarding the first point, the lack of a lock file means that there isn't a file you can store with the project. This means that each developer working on a project needs to run `opam install x` for the packages defined in the `dune-project` file. Consequently, each developer might end up running different versions of the same package. At least, that's how I think it would be. However, there are some solutions to this problem, and one of them is using [nix with ocaml](https://www.tweag.io/blog/2023-02-16-opam-nix/). 

![Twitter](/images/ocaml/twitter.png)


Regarding this issue, I spoke to [Yawar Amin](https://twitter.com/yawaramin), who mentioned that opam has a "loose" view on the package manager, which means that it's okay not to store a lock on the packages as each package should be backwards compatible. However, I'm not sure if I like this approach. The reason is that there is a smaller guarantee that the package you are working with will work the same way on different versions. With a lock file, you have a greater guarantee that the code will work the same as the deployed version in the cloud and so on.

## A Package Manager on steroids.

Opam is a feature-rich package manager for OCaml. It offers support for simultaneous compiler installations, flexible package constraints, and a developer-friendly git workflow. Additionally, Opam can be used to install different compilers or different versions of OCaml.

As I delved deeper into Opam, I discovered that it combines the functionalities of Python's virtualenv and pip. Essentially, Opam provides a developer environment where you can create named environments to manage different versions of packages and the packages themselves.

During my journey of learning OCaml, I decided to create my first OCaml package: a Discord bot. To get started, I executed the following command:

```bash
opam switch create 5.1.0 ocaml-base-compiler

```

I believed that this command would create a new OCaml installation using version 5.1.0. Later, I used `opam switch x` to switch to what I thought would be a different OCaml version. However, upon recompiling my project after the switch, I was prompted to reinstall the missing packages. It was only when I switched back to the initially created "5.1.0" environment that all the previously installed packages became available and everything worked as expected.

I came to the realization that creating a switch with Opam actually generates a new environment with the specified name after `create`. For example, I named the environment created for my Discord bot "discordbot" using the command `opam switch create discordbot ocaml-base-compiler`. Each switch also enables the usage of different versions of the OCaml compiler.

In my opinion, Opam is comparable to virtualenv + pip but lacks the locking capability.

## End

This post was more about my thoughts on opam. I hope you enjoyed it. If you have any feedback, you can easily find me on [Twitter](https://twitter.com/emil_priver).

Shout out to Ryan Winchester for generating the cover image. His Twitter can be found here: https://x.com/ryanrwinchester

