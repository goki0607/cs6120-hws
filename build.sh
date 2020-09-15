#!/bin/bash

set -e

DIRS="-Is src/types,src/trivial,src/cfg,src/main -use-ocamlfind"
YOJSON="yojson"
SHOW="ppx_deriving.std"
TARGET="src/main/main "
FLAGS="-cflag -g -lflag -g -libs str -pkgs $SHOW -pkgs $YOJSON $DIRS"
OCAMLBUILD=ocamlbuild
MENHIR=menhir

ocb ()
{
  $OCAMLBUILD -use-ocamlfind $FLAGS $*
}

if [ $# -eq 0 ]; then
    action=byte
else
    action=$1;
    shift
fi

case $action in
    clean)    ocb -clean;;
    native)   ocb ${TARGET//" "/".native "} ;;
    byte)     ocb ${TARGET//" "/".byte "} ;;
    debug)    ocb -tag debug ${TARGET//" "/".native"} ;; # or .byte?
    all)      ocb ${TARGET//" "/".native "} ${TARGET//" "/".byte "} ;;
    help)     help ;;
    *)        printf "Unknown action $action.";;
esac;