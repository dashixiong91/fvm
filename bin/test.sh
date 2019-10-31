#!/usr/bin/env bash

set -e

THIS_DIR="$(cd "$(if [[ "${0:0:1}" == "/" ]]; then echo "$(dirname $0)";else echo "$PWD/$(dirname $0)";fi)"; pwd)"
PROJECT_DIR="${THIS_DIR}/.."
HOMEBREW_PROJECT="${THIS_DIR}/../packages/homebrew-fvm"
FORMULA_FILE="${HOMEBREW_PROJECT}/fvm.rb"

function check_git_dirty(){
  local is_clean=`git status | grep 'working tree clean'`
  if [[ -z $is_clean ]];then
    echo -e "\033[31m your working tree is not clean, please add and commit your code !!!\033[0m"
    exit 1
  fi
  pushd $PROJECT_DIR
    git push
  popd
}

function run_test(){
  if [[ -d /usr/local/opt/fvm ]];then
    brew uninstall fvm
  fi
  HOMEBREW_NO_AUTO_UPDATE=true brew install --HEAD --force $FORMULA_FILE
  brew test --HEAD -d $FORMULA_FILE
  echo -e "\033[32m All tests passed! \033[0m"
}

function main(){
  check_git_dirty
  run_test
}
main "$@"