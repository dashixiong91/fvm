# fvm
> Flutter SDK versions Manager

# 使用方法

1. Download 

```
git clone https://github.com/xinfeng-tech/fvm.git $HOME/fvm
```

2. Copy the following content in to your `.bash_profile|.zshrc ...` file

```
export PUB_HOSTED_URL=http://mirrors.cnnic.cn/dart-pub
export FLUTTER_STORAGE_BASE_URL=http://mirrors.cnnic.cn/flutter 
export FLUTTER_ROOT="$HOME/fvm/current"
alias fvm="`dirname $FLUTTER_ROOT`/fvm.sh"
export PATH="$FLUTTER_ROOT/bin:$PATH"
```

3. Open terminal and type `fvm` command
```
fvm
```