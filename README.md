<!-- markdownlint-configure-file
{
  "line-length": {
    "line_length": 100
  }
}
-->

# Local NixOS Configs

This repo contains the set up of my local system using [nix expressions](https://wiki.nixos.org/wiki/Overview_of_the_Nix_Language).

One may have to face many perspectives to understand what Nix is.
Nix is a novel paradigm that provides a wat to programmatically declare a system.
It's also the pure functional (domain specific) language used to declare nix expressions.
These expressions describe derivations (assets, packages, applications, etc) that compose a desired
system or development environment.
Nixpkgs is a collection of packages and a concrete production example of how nix can be used to
build packages. NixOS is the linux distribution that sits on top of Nixpkgs.

At first glance, it's not simple to catch up with Nix and NixOS. It has a steep learning curve.
Anyway, the most relevant point is: forget about imperative way of doing things.
No more *apt-get install this* or *rpm -i that*. Just use nix expressions to declare what is your
need and (hopefully) it'll be there available in your system.
This repository is based in two major components of Nix ecossystem: Nix Flakes and Home Manager.

[Nix Flakes](https://wiki.nixos.org/wiki/Flakes) is a directory tree with a nix file named *flake.nix*
that follows a specific schema to describe inputs and outputs. Inputs are the dependencies of your build
and outputs are your packages, systems, development environments, etc.

<!-- Write about Home Manager -->

# Organization

TBD

## Acknowledgments

This structure in the repo, some expressions and tools used are heavily by Misterio's [nix config](https://github.com/Misterio77/nix-config)
awesome work. If you're going into Nix path be sure to check his getting starter [repo](https://github.com/Misterio77/nix-starter-configs).
