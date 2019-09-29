#!/usr/bin/env bash

alias fvm="`brew --prefix`/opt/fvm/fvm.sh"

for element in `fvm init`
do
  export $element
done
