#!/usr/bin/env bash

set -e

THIS_DIR="$(cd "$(if [[ "${0:0:1}" == "/" ]]; then echo "$(dirname $0)";else echo "$PWD/$(dirname $0)";fi)"; pwd)"
PROJECT_DIR="${THIS_DIR}/.."
HOMEBREW_PROJECT="${THIS_DIR}/../packages/homebrew-fvm"

function main(){
  if [[ ! -d $HOMEBREW_PROJECT ]];then
    git clone https://github.com/dashixiong91/homebrew-fvm.git $HOMEBREW_PROJECT
  fi
  pushd $HOMEBREW_PROJECT
    git pull
  popd
}
main "$@"
