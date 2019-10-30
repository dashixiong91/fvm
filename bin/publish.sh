#!/usr/bin/env bash

set -e

THIS_DIR="$(cd "$(if [[ "${0:0:1}" == "/" ]]; then echo "$(dirname $0)";else echo "$PWD/$(dirname $0)";fi)"; pwd)"
HOMEBREW_PROJECT="${THIS_DIR}/../packages/homebrew-fvm"

function main(){
  local pkg_file="${THIS_DIR}/../package.json"
  local pkg_version=`cat ${pkg_file} | grep "\"version\"" | awk 'NR==1' | awk -F '\"' '{print $4}'`
  echo -e "\033[32m publish version:${pkg_version} to homebrew... \033[0m"
  git push --tag
  sh "${THIS_DIR}/update_formula.sh" $pkg_version
  echo -e "\033[36m publish version:${pkg_version} success! \033[0m"
}
main "$@"
