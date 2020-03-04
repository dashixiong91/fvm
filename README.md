# fvm
[![MIT Licence](https://dashixiong91.gitee.io/assets/badge/mit.svg)](https://opensource.org/licenses/mit-license.php) 
<!-- [![Awesome Flutter](https://dashixiong91.gitee.io/assets/badge/awesome-flutter-blue.svg)](https://github.com/Solido/awesome-flutter) -->

README [English](README.md) | [中文](README-zh.md)

> Flutter SDK versions Manager

## Installation

1. First, add homebrew's tap:
```shell
brew tap dashixiong91/fvm
```

2. Once the tap has added, you can install `fvm`
```shell
brew install fvm
```

3. Copy the following content in to your `.bashrc|.zshrc ...` file

```shell
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
export FVM_DIR="$HOME/.fvm"
source "/usr/local/opt/fvm/init.sh"

export PATH="$PATH:$FVM_DIR/current/bin/"
export PATH="$PATH:$FVM_DIR/current/bin/cache/dart-sdk/bin"
```
## Usage

### Print `fvm` command help info
```shell
fvm
# or `fvm --help`
```

### Install Flutter,take 1.9.1 as an example
```shell
fvm install 1.9.1
```

### Use Flutter installed above
```shell
fvm use 1.9.1
```

### Set aliases
```shell
fvm alias latest 1.9.1
```

### List all installed versions
```shell
fvm list
```

### List published versions
```shell
fvm list-remote all
```

## Preview

 <img src="https://dashixiong91.gitee.io/assets/fvm/terminal_v3.png" alt="terminal">