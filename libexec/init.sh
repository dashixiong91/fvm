#!/usr/bin/env bash

function main(){
  local OLD_IFS="$IFS"
  IFS=$'\n'
  for element in `fvm init`
  do
    export $element
  done
  IFS="$OLD_IFS"
}

main "$@"
