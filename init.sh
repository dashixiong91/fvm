#!/usr/bin/env bash

set -e

THIS_DIR="$(cd "$(if [[ "${0:0:1}" == "/" ]]; then echo "$(dirname $0)";else echo "$PWD/$(dirname $0)";fi)"; pwd)"

FVM_SCRIPT="${THIS_DIR}/fvm.sh"
alias fvm="${FVM_SCRIPT}"
fvm init
