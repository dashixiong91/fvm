#!/usr/bin/env bash

set -e

OLD_PWD="$PWD"
THIS_DIR="$(cd "$(if [[ "${0:0:1}" == "/" ]]; then echo "$(dirname $0)";else echo "$PWD/$(dirname $0)";fi)"; pwd)"
cd ${OLD_PWD}

function print_help(){
    echo "Flutter SDK versions Manager."
    echo ""
    echo "Usage: fvm <command> [arguments]"
    echo ""
    echo "Available commands:"
    echo "  list|ls     Print flutter-sdk installed versions."
    echo "  use         Switch flutter-sdk to version."
    echo "  install     Install flutter-sdk version."
    echo "  help|*      Display help information."
    echo ""

}

function list(){
    echo "current => `current`"
    echo ""
    echo "可用的版本："
    for version in `ls -1 "${THIS_DIR}/versions"`
    do
      echo "${version} => `cat ${THIS_DIR}/versions/${version}/version`"
    done
}
function current(){
   local current=`readlink $THIS_DIR/current`
   current=${current#$THIS_DIR/versions/}
   echo ${current}
}

function print_current_version(){
    echo "Now using flutter => version:`current`"
    flutter --version
}

function use(){
    local version=${1:-default}
    echo "Switch flutter to => version:${version}"
    local current_dir=$THIS_DIR/current
    local target_version_dir=$THIS_DIR/versions/$version
    if [[ ! -d ${target_version_dir} ]];then
      echo "Error: version:${version} has not installed!!"
      exit 1
    fi
    if [[ ! -f ${target_version_dir}/bin/flutter ]];then
      echo "Error: version:${version} is not a valid flutter-sdk !!"
      exit 2
    fi
    rm -rf $current_dir
    ln -s $target_version_dir $current_dir
    print_current_version
}

function install(){
  echo "TODO: it is not implements.."
}

function main(){
    local cmd args
    cmd="$1"
    args="${@#$cmd}"
    case ${cmd} in
        "use")use $args;;
        "list"|"ls")list;;
        "install")install;;
        "help"|*)print_help;;
    esac
}
main "$@"


