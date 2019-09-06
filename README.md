# fvm
> Flutter SDK versions Manager

# 使用方法

1. 克隆本项目到`$HOME`目录
2. 将以下内容粘贴到你的shell启动文件中`.bash_profile|.zshrc` ...

```
export PUB_HOSTED_URL=http://mirrors.cnnic.cn/dart-pub
export FLUTTER_STORAGE_BASE_URL=http://mirrors.cnnic.cn/flutter 
export FLUTTER_ROOT="$HOME/fvm/current"
alias fvm="`dirname $FLUTTER_ROOT`/fvm.sh"
export PATH="$FLUTTER_ROOT/bin:$PATH"
```

3. 打开终端执行fvm命令
```
fvm
```