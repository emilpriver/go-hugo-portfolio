---
title: "Bye Opam, Hello Nix"
date: 2024-05-13T16:20:18+02:00
draft: false
type: "blog"
tags: ["Ocaml", "nix", "opam"]
cover:
  image: "images/ocaml.jpeg"
series:
  - Ocaml
toc: true
description: "Article about replacing opam with nix for a easier life"
---
I've been writing OCaml since November 2023 and I enjoy the language; it's fun to write and has some features I really appreciate. However, you may have noticed I only mentioned the "language" in the first sentence. That's because I have issues with Opam, the package manager for OCaml. It has been a pain in my development workflow and I want to eliminate it.

Not long ago, I was browsing Twitch and saw some content on Nix hosted by [BlackGlasses](https://twitter.com/thealtf4stream) ([altf4stream](https://www.twitch.tv/altf4stream)), [Metameeee](https://twitter.com/metameeee) and [dmmulroy](https://twitter.com/dillon_mulroy). They discussed how to use Nix to manage your workspace, which intrigued me. Around the same time, I started working at CarbonCloud, my current employer, where we use Haskell with Nix for some apps. Having seen how they utilize Nix and its potential, I decided to try it out with OCaml.

## Why?

In short, I've experienced numerous frustrations with OPAM when working on multiple projects that use different versions of a library. This scenario often necessitates creating new switches and reinstalling everything. Though I've heard that OCaml libraries should be backward compatible, I've never found this to be the case in practice. For instance, if we need to modify a function in version 2.0.0 due to a security issue, it challenges the notion of "backward compatibility".

Challenges may arise when opening the same folder in different terminal sessions, such as whether the command `opam install . --deps-only` needs to be run again to update the terminal to use the local switch instead of the global one. To clarify, a standard OPAM installation puts all packages globally in `$HOME/.opam`. To avoid using this global environment, a local environment can be created by running `opam install . --deps-only` in the desired folder. This command creates an `_opam` folder in the directory, which can help avoid some complications. Furthermore, OPAM allows you to set a specific package version in your `.opam` files. This is useful even for packages that strive for backward compatibility, as it allows for two repositories to require different versions of the same package. However, it can also lead to version conflicts as packages are typically installed in the global environment.

Another difficulty is the time it takes to release something on the OPAM repository. As a result, you may find yourself installing some packages directly from OPAM, while pinning others directly to a Git reference.

Another issue I noticed is that Opam sometimes installs non-OCaml libraries, like PostgreSQL, without asking, if a specific library requires it. This situation feels a bit odd.

Therefore, I replaced Opam with Nix.

## Moving to nix flakes

I've started transitioning to Nix, which allows me to completely remove Opam from my system, since OCaml can function without it. Another approach to achieve this is by cloning libraries using Git to a folder within the library, as Dune handles monorepo very efficiently.

If you're unfamiliar with Nix, I recommend reading this article: https://shopify.engineering/what-is-nix. It provides a good summary.

I use Nix across several projects, but I will demonstrate examples and code from my project "ocamlbyexample", which is similar to [https://gobyexample.com](https://gobyexample.com/) but for OCaml. I am using Nix for two purposes in this project:

- To create an easily reproducible developer environment. If a new developer wants to contribute, they can simply clone the repo and run `nix develop` to get an environment with everything they need.
- To build the project. I also wanted the ability to build the project in CI using Nix so that I would get the HTML, CSS, and JS files ready to be published to the internet.

Nix handles these tasks very efficiently for me.

### Installing ocaml compiler and more

Integrating this is fairly straightforward because the work has already been accomplished in the `nix-ocaml/nix-overlay` repository. Additionally, some OCaml packages have already been published to [nix](https://search.nixos.org/packages?channel=23.11&from=0&size=50&sort=relevance&type=packages&query=ocamlpackages). Therefore, I just need to specify the dependencies I require to nix.

```nix
{
  description = "A development environment for ocamlbyexample";

  inputs = {
    nixpkgs.url = "github:nix-ocaml/nix-overlays";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}".extend (self: super: {
          ocamlPackages = super.ocaml-ng.ocamlPackages_5_1;
        });
        ocamlPackages = pkgs.ocamlPackages;
        };
        packages = [
          ocamlPackages.brr # I inform nix that I need the brr library
          ocamlPackages.utop
        ];
      in
      {
        formatter = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
        defaultPackage = pkgs.stdenv.mkDerivation {
          name = "ocamlbyexample";
          src = ./.:
          # My code for when I need to build the project
        };

        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs.ocamlPackages; [ cppo findlib ];
          buildInputs = with pkgs; [
            packages
            caddy # Local http server
          ];
        };
      }
    );
}
```

*Please note that this code may not work perfectly as it could be missing some steps.*

Instead of using `opam install brr`, you can replace it with `ocamlPackages.brr` as an argument for nix `buildInputs`. This installs the package when I run either `nix develop` or `nix build` 

### Libraries that don’t exist on nix yet

However, not all packages exists on nix yet but it’s possible to install the packages directly from source using `builtins.fetchurl` as in the example below:

```nix
{
  description = "A development environment for ocamlbyexample";

  inputs = {
    nixpkgs.url = "github:nix-ocaml/nix-overlays";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}".extend (self: super: {
          ocamlPackages = super.ocaml-ng.ocamlPackages_5_1;
        });
        ocamlPackages = pkgs.ocamlPackages;
        packages = [
          ocamlPackages.brr # I inform nix that I need the brr library
          ocamlPackages.utop
        ];
      in
      {
        formatter = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
        defaultPackage = pkgs.stdenv.mkDerivation {
          name = "ocamlbyexample";
          src = ./.;
        };

        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs.ocamlPackages; [ cppo findlib ];
          buildInputs = with pkgs; [
            packages
            caddy # Local http server
          ];
        };
      }
    );
}```

Since `dune` supports the installation and building of multiple packages, we utilize it here to build the package as seen in `ocamlPackages.buildDunePackage`.

> Dune is the build system for OCaml. It uses ocamlc under the hood to run and compile your project. The homepage can be found at: https://dune.build/
> 

There's a difference between using `ocamlPackages` and installing a package from the source. In the latter, a `sha256` hash of the downloaded file is required. Fortunately, you can easily obtain this hash.

By setting `sha256` to an empty string, Nix will calculate the hash for you, returning it in the terminal as an error message.

```bash
 error: hash mismatch in file downloaded from '<https://github.com/emilpriver/js_top_worker/archive/refs/tags/v0.0.1.tar.gz>':
         specified: sha256:0000000000000000000000000000000000000000000000000000
         got:       sha256:1xkmq70lf0xk1r0684zckplhy9xxvf8vaa9xj6h1x2nksj717byy

```

Simply copy the entire `got` value and input it into `sha256`, as demonstrated in the example, to have the correct hash ready.

## What does this mean for other developers

Of course, other developers aren't required to use Nix if they prefer not to. However, if you want to contribute to the project with as little hassle as possible, simply run `nix develop`. This command provides you with the exact environment I'm using, because Nix operates with reproducible environments. My devShell config for [ocamlbyexample.com](http://ocamlbyexample.com) is

```nix
 devShell = pkgs.mkShell {
	nativeBuildInputs = with pkgs.ocamlPackages; [ cppo findlib ];
	buildInputs = with pkgs; [
	  packages
	  caddy # Add Caddy as a local http server
	];
	
	shellHook = ''
	  echo "Welcome to your ocamlbyexample dev environment!"
	  echo "Run 'dune build' to build the project. Or during development run 'dune build -w' for re-building on change."
	
	  # Write a Caddyfile if it does not exist
	  echo "Writing Caddyfile..."
	  if [ ! -f Caddyfile ]; then
	    echo "
	    :3333 {
	      root * _build/default/ocamlbyexample/dist
	      file_server browse
	    }" > Caddyfile
	    echo "Caddyfile written."
	  fi
	
	  echo "Starting Caddy server on http://localhost:3333"
	  # Start Caddy in the background and trap exit to kill it
	  caddy start --config ./Caddyfile --adapter caddyfile
	  trap "pkill -9 caddy" EXIT
	
	  echo "There is a Caddy server running on port 3333 (http://localhost:3333) which is hosting the project"
	'';
	};
```

This implies that the developer only needs to execute `dune build` to generate CSS, HTML, and JS files, and then preview the changes at `http://localhost:3333`.

## Building for production

The advantage of using 'nix' is that it enables me to build the project both locally and in the CI using `nix build`. This ensures consistent output, simplifying the entire build process in the CI.

Previously, I had to install opam, ocaml, make a switch, and install the library. Now, all these steps are replaced with a simple `nix build`. Here is my configuration for `nix build`:

```nix
defaultPackage = pkgs.stdenv.mkDerivation {
  name = "ocamlbyexample";
  src = ./.;
  nativeBuildInputs = with pkgs.ocamlPackages; [ cppo findlib ];
  buildInputs = with pkgs; [
    packages
  ];
  buildPhase = ''
    dune build
  '';

  installPhase = ''
    cp -r _build/default/ocamlbyexample/dist $out
  '';
};
```

This means I can directly use the files in the `result` folder, created by `nix build`, and publish them to my CDN.

## The end

Will I use Nix for all my OCaml projects? Not likely, as using Nix can sometimes seem excessive for small, short-term projects. Additionally, the team building Dune is adding package management, which I might use. However, I appreciate the simplicity of `nix build` in continuous integration (CI).

While not all packages are available on Nix, there's a concerted effort to increase the number of libraries installable with Nix Flakes. For example, there's now a `flake.nix` in the [Riot GitHub repo](https://github.com/riot-ml/riot) that we can use to add Riot to our stack.

The only downside i've found so far is that it sometimes take some time to setup a new dev environment when running `nix develop`.

I hope this article was inspiring. If you wish to contact or follow me, you can do so on Twitter: https://twitter.com/emil_priver

