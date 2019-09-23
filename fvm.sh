#!/usr/bin/env bash

set -e

THIS_DIR="$(cd "$(if [[ "${0:0:1}" == "/" ]]; then echo "$(dirname $0)";else echo "$PWD/$(dirname $0)";fi)"; pwd)"
FLUTTER_STORAGE_BASE_URL=${FLUTTER_STORAGE_BASE_URL:-"http://mirrors.cnnic.cn/flutter"}
FLUTTER_RELEASE_BASE_URL="${FLUTTER_STORAGE_BASE_URL}/flutter_infra/releases"

darwin=false
case "`uname`" in
    Darwin*) darwin=true;;
esac

function print_help(){
    echo "Flutter SDK versions Manager."
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
    echo "Error: no flutter version match $version_key !!"
    exit 1
  fi
  local version_short=`echo $version_zip | awk -F '_v' '{print $2}' | awk -F '.zip' '{print $1}'`
  local download_url="${FLUTTER_RELEASE_BASE_URL}/${version_zip}"
  local temp_path="${TMPDIR}/flutter.zip"
  local target_dir="${THIS_DIR}/versions/${version_short}"
  if [[ -d ${target_dir} ]];then
    echo "Error: flutter $version_short seems to has installed ,please check it!!"
    exit 1
  fi
  echo "flutter $version_short has downloading..."
  curl --progress-bar -o $temp_path $download_url
  unzip -o $temp_path -d $target_dir
  echo "flutter $version_short has installed to $target_dir!"
}

function main(){
    local cmd args
    cmd="$1"
    args="${@#$cmd}"
    case ${cmd} in
        "use")use $args;;
        "list"|"ls")list;;
        "list-remote")list_remote;;
        "install")install $args;;
        "help"|*)print_help;;
    esac
}
main "$@"


