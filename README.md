# Required Libraries

You will need to run the following to first switch to OCaml 4.11.0 (if you don't already have it)

```
opam switch create 4.11.0
```

otherwise you can simply switch by doing

```
opam switch 4.11.0
```

Then you should install the relevant libraries using opam

```
opam install ocamlfind ocamlbuild merlin yojson ppx_deriving
```

# Compiling the Program

I am using OCamlBuild for this project (its probably out of fashion I know!). If you want to compile to byte code run

```
./build.sh byte
```

and if you want native code run

```
./build.sh native
```

To clear the build directory (sometimes this is necessary) run

```
./build.sh clean
```

# Running the Program

For now there is no command line interface (this is on my to-do list) so the program reads a file in JSON format called `test.json`. It then applies the following trivial trasnformation on the program

* if an operation is a binary comparison, arithmetic or logical operation then do the following:
  * map (+ -> -, - -> +, * -> /, / -> \*, > -> <=, < -> >=, >= -> <, <= -> >, = -> =, and -> or, or -> and) and flip the arguments around
* if an operation is an unary logical operation (not) or id then do the following:
  * map (not -> id, id -> id)
* otherwise do nothing.

In a way, this transformation does some sort of self-defined inverse on the above selected instructions. Then, the program will print the result back out onto the screen in JSON format (so I have both a JSON to OCaml types translation and then a OCaml types to JSON translation).

Finally, the basic blocks and cfg extractor are implemented but I need to test them to make sure everything works.
