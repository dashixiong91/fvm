#!/usr/bin/env bash

set -e

THIS_DIR="$(cd "$(if [[ "${0:0:1}" == "/" ]]; then echo "$(dirname $0)";else echo "$PWD/$(dirname $0)";fi)"; pwd)"

FVM_DIR="${FVM_DIR:-"$HOME/.fvm"}"
FVM_VERSIONS_DIR="${FVM_DIR}/versions"
FVM_CURRENT_LINK="${FVM_DIR}/current"

FLUTTER_STORAGE_BASE_URL="${FLUTTER_STORAGE_BASE_URL:-"http://mirrors.cnnic.cn/flutter"}"
FLUTTER_RELEASE_BASE_URL="${FLUTTER_STORAGE_BASE_URL}/flutter_infra/releases"

darwin=false
case "`uname`" in
    Darwin*) darwin=true;;
esac

function print_blue(){
  echo -e "\033[36m$1\033[0m"
}
function print_green(){
  echo -e "\033[32m$1\033[0m"
}
function print_yellow(){
  echo -e "\033[33m$1\033[0m"
}
function print_red(){
  echo -e "\033[31m$1\033[0m"
}


function print_help(){
    print_blue "Flutter SDK versions Manager."
    echo ""
    echo "Usage: fvm <command> [arguments]"
    echo ""
    echo "Available commands:"
    echo "  use             Switch flutter-sdk to version."
    echo "  list|ls         Print flutter-sdk installed versions."
    echo "  list-remote     Print flutter-sdk release versions."
    echo "  install         Install flutter-sdk version."
    echo "  help|*          Display help information."
    echo ""

}
function init(){
  export FLUTTER_ROOT="$FVM_CURRENT_LINK"
  export PATH="$FLUTTER_ROOT/bin:$PATH"
  if [[ ! -d ${FVM_VERSIONS_DIR} ]];then
    mkdir -p ${FVM_VERSIONS_DIR}
  fi
}
function list(){
    print_green "current => `current`"
    echo ""
    print_blue "installed versions:"
    for version in `ls -1 "${FVM_VERSIONS_DIR}"`
    do
      local version_file="${FVM_VERSIONS_DIR}/${version}/version"
      if [[ ! -f $version_file ]];then
        echo "unkonw"
      else
        echo "${version} => `cat ${version_file}`"
      fi
    done
}

function current(){
   if [[ ! -d $FVM_CURRENT_LINK ]];then
     echo "unset"
     return
   fi
   local current=`readlink $FVM_CURRENT_LINK`
   current=${current#${FVM_VERSIONS_DIR}/}
   echo ${current}
}

function print_current_version(){
    print_blue "Now using flutter => version:`current`"
    flutter --version
}

function use(){
    local version_key="${1:-default}"
    local version=`list | awk -F ' =>' '{print $1}' | grep "${version_key}" | awk 'NR==1'`
    if [[ -z ${version} ]];then
      version='default'
    fi
    print_blue "Switch flutter to => version:${version}"
    local target_version_dir=$FVM_VERSIONS_DIR/$version
    if [[ ! -d ${target_version_dir} ]];then
      print_red "Error: version:${version} has not installed!!"
      exit 1
    fi
    if [[ ! -f ${target_version_dir}/bin/flutter ]];then
      print_red "Error: version:${version} is not a valid flutter-sdk !!"
      exit 2
    fi
    rm -rf $FVM_CURRENT_LINK
    ln -s $target_version_dir $FVM_CURRENT_LINK
    print_current_version
}
function list_remote(){
    local release_info_url="${FLUTTER_RELEASE_BASE_URL}/releases_linux.json"
    if [[ darwin ]];then
      release_info_url="${FLUTTER_RELEASE_BASE_URL}/releases_macos.json"
    fi
    curl -Ss ${release_info_url} | grep 'stable/' | awk -F ': ' '{print $2}' | awk -F '"' '{print $2}'
}
function install(){
  local version_key="$1"
  local version_zip=""
  version_zip=`list_remote | grep "$version_key" | awk 'NR==1'`
  if [[ -z ${version_zip}  ]];then
    print_red "Error: no flutter version match $version_key !!"
    exit 1
  fi
  local version_short=`echo $version_zip | awk -F '_v' '{print $2}' | awk -F '.zip' '{print $1}'`
  local download_url="${FLUTTER_RELEASE_BASE_URL}/${version_zip}"
  local temp_zip="${TMPDIR}fvm/flutter.zip"
  local target_dir="${FVM_VERSIONS_DIR}/${version_short}"
  if [[ -d ${target_dir} ]];then
    print_red "Error: flutter $version_short seems to has installed ,please check it!!"
    exit 1
  fi
  rm -rf $temp_zip
  mkdir -p `dirname $temp_zip`
  print_green "flutter $version_short is downloading..."
  curl --progress-bar -o $temp_zip $download_url
  unzip -o $temp_zip -d $target_dir
  print_blue "flutter $version_short has installed to $target_dir!"
  rm -rf $temp_zip
}

function main(){
    local cmd args
    cmd="$1"
    args="${@#$cmd}"
    case ${cmd} in
        "init")init;;
        "use")use $args;;
        "list"|"ls")list;;
        "list-remote")list_remote;;
        "install")install $args;;
        "help"|*)print_help;;
    esac
}
main "$@"


