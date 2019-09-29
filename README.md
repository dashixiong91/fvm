# fvm
> Flutter SDK versions Manager

## Installation

Then, run the following in your command-line:
```
brew tap xinfeng-tech/fvm
```

Once the tap is installed, you can install `fvm`
```
brew install fvm
```

Copy the following content in to your `.bashrc|.zshrc ...` file

```
export PUB_HOSTED_URL=http://mirrors.cnnic.cn/dart-pub
export FLUTTER_STORAGE_BASE_URL=http://mirrors.cnnic.cn/flutter 
export FVM_DIR="$HOME/.fvm"
. "/usr/local/opt/fvm/init.sh"
```
## Usage

1. Print `fvm` command help
```
fvm
# or `fvm help`
```

2. Install Flutter@1.9.1
```
fvm install 1.9.1
```

3. Use Flutter@1.9.1
```
fvm use 1.9.1
```
