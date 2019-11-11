# fvm
[![MIT Licence](https://xinfeng-tech.gitee.io/assets/badge/mit.svg)](https://opensource.org/licenses/mit-license.php) 
<!-- [![Awesome Flutter](https://xinfeng-tech.gitee.io/assets/badge/awesome-flutter-blue.svg)](https://github.com/Solido/awesome-flutter) -->

> Flutter SDK versions Manager

## Installation

First, run the following in your command-line:
```shell
brew tap xinfeng-tech/fvm
```

Once the tap is installed, you can install `fvm`
```shell
brew install fvm
```

Copy the following content in to your `.bashrc|.zshrc ...` file

```shell
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
export FVM_DIR="$HOME/.fvm"
source "/usr/local/opt/fvm/init.sh"
```
## Usage

1. Print `fvm` command help
```shell
fvm
# or `fvm --help`
```

2. Install Flutter@1.9.1
```shell
fvm install 1.9.1
```

3. Use Flutter@1.9.1
```shell
fvm use 1.9.1
```

## Preview

 <img src="https://xinfeng-tech.gitee.io/assets/fvm/terminal_v3.png" alt="terminal">