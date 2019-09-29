#!/usr/bin/env bash

THIS_DIR="$(cd "$(if [[ "${0:0:1}" == "/" ]]; then echo "$(dirname $0)";else echo "$PWD/$(dirname $0)";fi)"; pwd)"
FVM_SCRIPT="${THIS_DIR}/fvm.sh"
alias fvm="${FVM_SCRIPT}"

for element in `fvm init`
do
  local export_cmd="export $element"
  eval $export_cmd
done
