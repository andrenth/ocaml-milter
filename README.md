# OCaml-Milter

## Introduction

This library provides OCaml bindings to [libmilter](https://www.milter.org/).

## Build and installation

After cloning the repository, run the commands below to build OCaml-Milter.

    $ ocaml setup.ml -configure
    $ ocaml setup.ml -build

Documentation can be generated with the command below.

    $ ocaml setup.ml -doc

To install OCaml-Milter, run

    # ocaml setup.ml -install

## Limitations

Since libmilter uses pthreads internally, this module is thread-safe. However,
due to the current OCaml implementation, each of the milter callbacks must
acquire a global runtime lock while being executed, meaning that effectively
only a single thread will be running at a given time.
