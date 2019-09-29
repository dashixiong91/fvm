#!/usr/bin/env bash

alias fvm="`brew --prefix`/opt/fvm/fvm.sh"

for element in `fvm init`
do
  local export_cmd="export $element"
  eval $export_cmd
done
