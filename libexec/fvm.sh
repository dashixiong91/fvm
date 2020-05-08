#!/usr/bin/env bash

set -e

THIS_DIR="$(cd "$(if [[ "${0:0:1}" == "/" ]]; then echo "$(dirname $0)";else echo "$PWD/$(dirname $0)";fi)"; pwd)"

FVM_DIR="${FVM_DIR:-"$HOME/.fvm"}"
FVM_VERSIONS_DIR="${FVM_DIR}/versions"
FVM_CURRENT_LINK="${FVM_DIR}/current"

FLUTTER_STORAGE_BASE_URL="${FLUTTER_STORAGE_BASE_URL:-"https://storage.flutter-io.cn"}"
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
    echo "  list-remote [release_type]      Print flutter-sdk release versions."
    echo "                                  [release_type] should be stable|beta|dev|all."
    echo "  list|ls                         Print flutter-sdk installed versions."
    echo "  install <version_key>           Install flutter-sdk version that matched <version_key>."
    echo "  remove <version>                Remove flutter-sdk version or alias."
    echo "  alias <name> <version_key>      Set an alias named <name> pointing to version that"
    echo "                                  matched <version_key>."
    echo "  latest-dev                      Create a latest-dev version copy from latest."
    echo "  use <version_key>               Switch flutter-sdk to version that matched <version_key>."
    echo "  --version                       Display fvm version."
    echo "  --help                          Display help information."
    echo ""

}
function print_version(){
    local pkg_file="${THIS_DIR}/package.json"
    if [[ ! -f $pkg_file ]];then
      pkg_file="${THIS_DIR}/../package.json"
    fi
    local pkg_version=`cat ${pkg_file} | grep "\"version\"" | awk 'NR==1' | awk -F '\"' '{print $4}'`
    echo "$pkg_version"
}

function init(){
  if [[ ! -d ${FVM_VERSIONS_DIR} ]];then
    mkdir -p ${FVM_VERSIONS_DIR}
  fi
  echo FLUTTER_ROOT="$FVM_CURRENT_LINK"
  echo PATH="$FVM_CURRENT_LINK/bin:$PATH"
}

function list_local(){
    print_green "current => `current`"
    print_blue "installed versions:"
    for version in `ls -1 "${FVM_VERSIONS_DIR}"`
    do
      local version_dir="${FVM_VERSIONS_DIR}/${version}"
      local version_file="${version_dir}/version"
      local color="37"
      if [[ -h $version_dir ]];then
        color="35"
      fi
      local print_line=""
      if [[ ! -f $version_file ]];then
        print_line="\033[${color}m${version}\033[0m => unkonw"
      else
        print_line="\033[${color}m${version}\033[0m => `cat ${version_file}`"
      fi
      echo -e "$print_line"
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

function use(){
    local version_key="${1:-default}"
    local version=`ls -1 ${FVM_VERSIONS_DIR} | grep "${version_key}" | awk 'NR==1'`
    if [[ -z ${version} ]];then
      print_red "Error: version:${version_key} has not installed!!"
      exit 1
    fi
    print_blue "Switch flutter to => version:${version}"
    local target_version_dir=$FVM_VERSIONS_DIR/$version
    if [[ ! -f ${target_version_dir}/bin/flutter ]];then
      print_red "Error: version:${version} is not a valid flutter-sdk !!"
      exit 2
    fi
    rm -rf $FVM_CURRENT_LINK
    ln -s $target_version_dir $FVM_CURRENT_LINK
    print_blue "Now using flutter version:`current`...(Please wait a moment when first switch to it!!!)"
    flutter --version
}

function alias(){
  local alias_name="${1}"
  local version_key="${2}"
  if [[ -z ${alias_name} ]];then
     print_red "Error: \$name is required !!" 
     exit 1
  fi
  if [[ -z ${version_key} ]];then
     print_red "Error: \$version is required !!" 
     exit 2
  fi
  local version=`ls -1 ${FVM_VERSIONS_DIR} | grep "${version_key}" | awk 'NR==1'`
  if [[ -z ${version} ]];then
      print_red "Error: version:${version_key} has not installed!!"
      exit 1
  fi
  local target_version_dir=$FVM_VERSIONS_DIR/$version
  local alias_version_dir=$FVM_VERSIONS_DIR/$alias_name
  rm -rf $alias_version_dir
  ln -s $target_version_dir $alias_version_dir
  print_blue "alias $alias_name to $version!"
}

function list_remote(){
    local release_type="${1:-"/"}"
    local full_path="$2"
    local release_info_url="${FLUTTER_RELEASE_BASE_URL}/releases_linux.json"
    if [[ darwin ]];then
      release_info_url="${FLUTTER_RELEASE_BASE_URL}/releases_macos.json"
    fi
    local short_format="awk -F '_' '{print \$3}' | awk -F '.zip' '{print \$1}'"
    if [[ -n $full_path ]];then
      short_format=""
    fi
    local remote_print_cmd="curl -Ss ${release_info_url} | grep 'archive\"' | grep '${release_type}' | awk -F ': ' '{print \$2}' | awk -F '\"' '{print \$2}'"
    if [[ -n $short_format ]];then
      eval "$remote_print_cmd | $short_format | sort -n -t . -k 1 -k 2 -k 3"
    else 
      eval "$remote_print_cmd"
    fi
}

function install(){
  local version_key="$1"
  local version_zip=""
  if [[ -z ${version_key}  ]];then
    print_red "Error: \$version is required !!" 
    exit 1
  fi
  version_zip=`list_remote / 1 | grep "$version_key" | awk 'NR==1'`
  if [[ -z ${version_zip}  ]];then
    print_red "Error: no flutter version matched $version_key !!"
    exit 1
  fi
  local version_short=`echo $version_zip | awk -F '_' '{print $3}' | awk -F '.zip' '{print $1}'`
  local download_url="${FLUTTER_RELEASE_BASE_URL}/${version_zip}"
  local temp_dir="${TMPDIR}fvm"
  local temp_zip="${temp_dir}/flutter.zip"
  local target_dir="${FVM_VERSIONS_DIR}/${version_short}"
  if [[ -d ${target_dir} ]];then
    print_green "flutter $version_short seems to has installed,skipted it!"
    return
  fi
  rm -rf $temp_zip
  mkdir -p `dirname $temp_zip`
  print_green "flutter $version_short is downloading..."
  curl --progress-bar -o $temp_zip $download_url
  unzip -oq $temp_zip -d $temp_dir
  mv "${temp_dir}/flutter" $target_dir
  print_blue "flutter $version_short has installed to $target_dir!"
  rm -rf $temp_zip

  if [[ ! -f "$FVM_VERSIONS_DIR/default/version" ]];then
    alias default $version_short
  fi
  if [[ ! -f "$FVM_VERSIONS_DIR/latest/version" ]];then
    alias latest $version_short
  fi
  list_local
}

function remove(){
  local version="$1"
  if [[ -z ${version}  ]];then
    print_red "Error: \$version is required !!" 
    exit 1
  fi
  local version_dir="${FVM_VERSIONS_DIR}/${version}"
  if [[ ! -d ${version_dir} ]];then
      print_red "Error: version:${version} has not installed!!"
      exit 1
  fi
  rm -rf $version_dir
  print_blue "flutter version(alias):$version has remove!"
}

function latest_dev(){
  local latest_dev_dir="${FVM_VERSIONS_DIR}/latest-dev"
  if [[ -d $latest_dev_dir ]];then
    print_yellow "Warn: version:latest-dev has created!! please don't recreate, you should upgrade it by execution \`flutter upgrade\`!"
    return
  fi
  local latest_dir="${FVM_VERSIONS_DIR}/latest"
  if [[ ! -d $latest_dir ]];then
    print_red "Error: version:latest has not installed!! "
    exit 1
  fi
  print_green "latest-dev version create..."
  cp -R `readlink ${latest_dir}` ${latest_dev_dir}
  use latest-dev
  flutter channel dev && flutter upgrade
  print_blue "flutter version:latest-dev has created!"
}

function main(){
    local cmd args
    cmd="$1"
    args="${@#$cmd}"
    case ${cmd} in
        "init")init;;
        "list-remote"|"ls-remote")list_remote $args;;
        "list"|"ls")list_local;;
        "install")install $args;;
        "remove")remove $args;;
        "alias")alias $args;;
        "latest-dev")latest_dev $args;;
        "use")use $args;;
        "--version")print_version;;
        "--help"|*)print_help;;
    esac
}
main "$@"
