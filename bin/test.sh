#!/usr/bin/env bash

set -e

THIS_DIR="$(cd "$(if [[ "${0:0:1}" == "/" ]]; then echo "$(dirname $0)";else echo "$PWD/$(dirname $0)";fi)"; pwd)"
HOMEBREW_PROJECT="${THIS_DIR}/../packages/homebrew-fvm"
FORMULA_FILE="${HOMEBREW_PROJECT}/fvm.rb"

if [[ -d /usr/local/opt/fvm ]];then
  brew uninstall fvm
fi
HOMEBREW_NO_AUTO_UPDATE=true brew install --HEAD --force $FORMULA_FILE
brew test --HEAD -d $FORMULA_FILE
