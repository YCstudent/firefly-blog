---
title: "实用主义 Linux 基础——从会用开始"
published: 2026-08-08
description: "不讲内核源码，不谈历史典故，只讲你写代码、连服务器、配环境必须知道的 Linux 知识。"
tags: ["Linux", "命令行", "服务器", "新手向"]
category: "技术笔记"
image: "https://pub-c1824a6cf1a3422a928b777bbe1c7ef6.r2.dev/covers/spider0-cover.jpg"
---

## 为什么学 Linux

写后端要连服务器，用 Docker 要懂命令行，配 CI/CD 绕不开 shell 脚本。Linux 不是选修课，是工具链的一环。这篇的目标很简单——**让你能上手干活**。

> 本文部分内容参考了 AcWing yxc 老师的 Linux 教程，结合个人使用经验整理。

## 怎么学：不求甚解，现用现查

Linux 的命令、工具、配置项多到一辈子都学不完。试图系统地"学完 Linux"是一个陷阱——你会花三个月啃一本手册，然后在连上服务器的第一天就卡在某个从没见过的报错上。

更聪明的方法是**不求甚解，现用现查**：

1. **用到什么学什么**——今天要配 Nginx，就只学 Nginx 的那几个配置项。别翻到前面去"补 HTTP 基础"
2. **先跑通，再理解**——命令能跑就行，原理以后自然会懂。`chmod 755` 是什么意思？先用着，下次碰到了再深究
3. **搜索是你的第一技能**——比记住 100 个命令更重要的是知道怎么找到第 101 个

### 怎么查

遇到不懂的命令，三件套：

```bash
man command          # 官方手册，最权威（q 退出）
command --help       # 快速看常用参数
tldr command         # 比 man 更友好的例子速查（需安装：npm install -g tldr）
```

遇到报错信息，直接把报错复制到 Google / Stack Overflow / GitHub Issues。加上 `ubuntu 20.04` 限定版本号，能过滤掉大量过期答案。

搜索引擎里加 `site:stackoverflow.com` 可以只看 Stack Overflow 的结果；加 `-csdn` 可以过滤 CSDN（如果你不喜欢）。

### 用 AI 当你的助教

现在的 AI 已经足够好用，把它当成随叫随到的 Linux 助教：

> "我要在 Ubuntu 上装 Nginx 并配置一个静态网站，一步一步告诉我怎么做"
> "这个报错什么意思：Permission denied (publickey)"
> "把这段 shell 脚本改成每 5 分钟自动执行一次"

用 AI 的技巧：**把上下文给足**。不要问"Linux 怎么装软件"，而是问"Ubuntu 22.04 怎么装 Python 3.12，不要用 apt 的默认版本"。越具体，答案越能用。

> 我用的是 Claude Code，你用什么 AI 都行——ChatGPT、Kimi、DeepSeek，能聊天的都能帮你查 Linux。

几点注意：

- **隐私**：不要把服务器的真实 IP、密码、密钥、数据库连接字符串发给 AI。脱敏后再问
- **验证**：AI 给出的命令先读一遍再执行。特别是 `rm -rf`、`chmod 777`、`iptables` 这种可能造成破坏的命令——AI 偶尔会"幻觉"，输出的参数可能是错的
- **别跳过理解这一步**：AI 帮你解决了问题，花 30 秒问一句"为什么这样能解决"。不理解的东西下次还会卡住
- **不要形成依赖**：新手期可以多问 AI，但每问一次都试着记住。三个月后还是每次 `ls` 都要问 AI，那就是被 AI 养废了

### 推荐网站

| 场景 | 去哪查 |
|------|--------|
| 记不住命令怎么用 | `tldr` 命令，或者 https://tldr.inbrowser.app |
| 命令的完整参数 | `man` 或 `--help`，或 https://man7.org/linux/man-pages |
| 遇到报错 | Google 搜报错原文，加上 Ubuntu 版本号 |
| 找现成的配置模板 | GitHub 搜关键词 + `gist`，或 https://www.digitalocean.com/community/tutorials |
| Shell 脚本怎么写 | https://devhints.io/bash |
| 快速查某个知识点 | https://linuxize.com 或直接 `curl cht.sh/tar` |

DigitalOcean 的教程社区质量尤其高——每篇都详细、有代码示例、按步骤来，遇到 Ubuntu 上的具体任务先去那搜。

**这篇文章也是一样**——不用从头背到尾。需要的时候 Ctrl+F 搜一下，找到了直接用，忘了再搜。用多了自然就记住了。

## 环境准备：推荐云服务器

我更推荐新手直接买云服务器。原因很简单：

1. **有公网 IP**——你可以从任何地方连上去，用手机都能 SSH。这是 WSL2 和虚拟机做不到的
2. **真实环境**——从一开始就在和真正的服务器打交道，SSH 登录、端口放行、域名配置，以后工作全用得上
3. **不占本地资源**——编译、跑服务都在云端，你的电脑该干嘛干嘛
4. **逼你走出舒适区**——WSL2 太方便了，反而容易让你跳过 Linux 基本功

阿里云/腾讯云/华为云学生机一年几十块，1 核 2GB 起步完全够用。

如果预算实在紧张，WSL2 也能凑合：`wsl --install -d Ubuntu` 一条命令装好。但少了公网 IP，学到的 Linux 是不完整的。

## 命令行思维

GUI 靠「看见 → 点击」，命令行靠「描述 → 执行」。

```bash
# GUI：找到文件夹 → 右键 → 新建文件
# 命令行：
touch README.md
```

刚开始不习惯很正常。两周之后你会觉得敲命令比点鼠标快。

## 终端快捷键

这几个键每天都要用：

| 快捷键 | 作用 | 场景 |
|--------|------|------|
| `Ctrl + C` | 取消当前命令，换行 | 命令打错了，终止重来 |
| `Ctrl + U` | 清空本行 | 写了一长串全删掉 |
| `Tab` | 补全命令 / 文件名 | 省时间，自动补全 |
| `Tab × 2` | 显示备选选项 | 补全不了时列出所有可能 |
| `↑` / `↓` | 切换历史命令 | 不用重新敲 |

**复制粘贴**：
- Windows / Linux：`Ctrl + Insert` 复制，`Shift + Insert` 粘贴
- Mac：`Cmd + C` 复制，`Cmd + V` 粘贴

## 文件与目录

```bash
ls          # 列出当前目录所有文件
            # 蓝色 = 文件夹，白色 = 普通文件，绿色 = 可执行文件
ls -la      # 详细信息 + 隐藏文件

pwd         # 显示当前路径
            # 输出类似 /home/user/projects

cd xxx      # 进入 xxx 目录
cd ..       # 返回上层目录
cd ~        # 回到用户主目录
cd -        # 回到上一次所在的目录
```

**场景**：你刚连上服务器，想知道自己在哪、有什么：
```bash
pwd && ls -la
```

## 增删改查

```bash
# 创建
touch README.md          # 新建空文件
mkdir my-project         # 新建目录

# 复制
cp a.txt b.txt           # 把 a.txt 复制成 b.txt
cp a.txt ../dir_c/       # 复制到上层目录的 dir_c 文件夹里

# 移动 / 重命名
mv old.txt new.txt       # 重命名
mv file.txt ../dir_c/    # 移动文件

# 删除
rm file.txt              # 删除普通文件
rm -r folder/            # 删除文件夹（递归删除）
rm -rf node_modules/     # 强制递归删除，慎用！
```

`mv` 兼任重命名和移动——两个功能用同一个命令，Linux 的设计哲学就是简洁。

## 查看文件内容

```bash
cat package.json    # 全量展示，适合短文件
less app.log        # 翻页查看，q 退出
head -20 app.log    # 只看前 20 行
tail -20 app.log    # 只看后 20 行
tail -f app.log     # 实时追踪日志，排查故障必用
```

**场景**：服务报错，看最后 50 行日志找原因：
```bash
tail -50 /var/log/nginx/error.log
```

## 管道与搜索

管道 `|` 是 Linux 的精髓——把前一个命令的输出交给后一个处理。

```bash
grep "Error" app.log              # 在文件里找 Error
grep -r "TODO" ./src              # 递归搜索整个目录
find . -name "*.ts"               # 找当前目录下所有 .ts 文件

# 管道组合
cat app.log | grep Error | wc -l  # 统计有多少行 Error
ps aux | grep node                # 找所有 Node 进程
```

## 文件权限

```bash
ls -l     # 第一列就是权限，像这样：-rwxr-xr-x
```

拆开：`-`（文件类型）`rwx`（你的权限）`r-x`（同组用户）`r-x`（其他人）

- `r` = 读（4），`w` = 写（2），`x` = 执行（1）

最常用的两个：
```bash
chmod +x script.sh            # 让脚本可执行
chmod 600 ~/.ssh/id_rsa       # 私钥只让自己读写
```

## 包管理

```bash
# Ubuntu / Debian
sudo apt update               # 先更新源
sudo apt install nginx        # 安装
sudo apt remove nginx         # 卸载

# 新服务器到手，一次性装完常用工具
sudo apt update && sudo apt install -y \
  git curl wget build-essential \
  nodejs npm python3
```

`-y` 跳过所有确认提示，脚本里常用。

## 进程管理

```bash
ps aux | grep node            # 找 Node 进程的 PID
top                           # 实时看 CPU / 内存，q 退出
htop                          # top 的彩色版（可能需要安装）

kill 12345                    # 优雅终止进程 12345
kill -9 12345                 # 强制杀死（kill 不掉再用）
```

**场景**：Node 服务卡死了：
```bash
ps aux | grep "node server.js"   # 拿到 PID
kill -9 12345                    # 强制结束
node server.js &                 # 后台重启
```

## SSH：连接服务器

### 基本用法

```bash
ssh user@hostname           # 默认端口 22
ssh user@hostname -p 2222  # 指定端口
```

第一次登录会提示确认指纹，输入 `yes`，信息会存入 `~/.ssh/known_hosts`。

### 免密登录（密钥）

```bash
ssh-keygen              # 一路回车，生成 ~/.ssh/id_rsa（私钥）和 id_rsa.pub（公钥）
ssh-copy-id myserver    # 把公钥拷贝到服务器
ssh myserver            # 之后免密登录
```

### 配置文件

在 `~/.ssh/config` 里给服务器取别名：

```
Host myserver
    HostName 123.57.47.211
    User root

Host blog-server
    HostName 192.168.1.100
    User ubuntu
```

之后直接 `ssh myserver` 就行，不需要记 IP。

### 远程执行命令

```bash
ssh myserver ls -a                          # 在服务器上执行一条命令
ssh myserver 'for ((i=0;i<10;i++)); do echo $i; done'  # 执行脚本
```

### 传文件（scp）

```bash
scp file.txt myserver:/home/           # 上传单个文件
scp a.txt b.txt myserver:/home/        # 一次传多个

scp -r ~/project myserver:/home/       # 上传整个文件夹
scp -r myserver:project ./             # 下载文件夹到本地

scp -P 2222 file.txt myserver:/home/   # 指定端口
```

参数 `-r` 和 `-P` 尽量放在 source 和 destination 前面。一个小技巧：把本地的 vim 和 tmux 配置同步到服务器：

```bash
scp ~/.vimrc ~/.tmux.conf myserver:
```

## tmux：终端分屏与持久会话

连上服务器跑一个长时间任务——训练模型、下载大文件、编译代码——网络一断，任务就挂了。因为你的 shell 是挂在 SSH 连接上的，连接断了 shell 就没了。

tmux 解决两个问题：
1. **分屏**——一个窗口同时看代码、跑命令、看日志
2. **持久化**——断开 SSH 后，tmux 里的进程继续跑，下次连回来接着看

### 结构

```
tmux
├── session 0          → 一个会话，比如「工作区」
│   ├── window 0       → 一个窗口，比如「写代码」
│   │   ├── pane 0     → 左半边，编辑器
│   │   └── pane 1     → 右半边，终端
│   ├── window 1       → 另一个窗口，比如「看日志」
│   └── window 2       → 再一个窗口，比如「跑脚本」
├── session 1          → 另一个会话，比如「杂项」
└── ...
```

### 启动与退出

```bash
tmux            # 新建 session，包含一个 window，window 里一个 pane
tmux a          # attach，恢复之前挂起的 session
```

退出一个 pane / window / session 都用同一个键：`Ctrl + D`。关掉最后一个 pane 时自动关 window，关掉最后一个 window 时自动关 session。

### 分屏

| 操作 | 效果 |
|------|------|
| `Ctrl + A` 松开，按 `%` | 左右平分 |
| `Ctrl + A` 松开，按 `"` | 上下平分 |

鼠标点击选中的 pane，拖动分割线调整大小。也可以用键盘：`Ctrl + A` 松开后按方向键，或按住 `Ctrl + A` 同时按方向键微调分割线。

`Ctrl + A` 松开后按 `Z`：当前 pane 全屏 / 取消全屏。

### 挂起与恢复

```bash
Ctrl + A, D          # detach，挂起当前 session
tmux a               # 重新连接
```

这是 tmux 最大的价值——训练模型、跑数据处理时挂起，关电脑回家，到家 ssh 回去 `tmux a`，进度还在。

### 切换

| 操作 | 作用 |
|------|------|
| `Ctrl + A`, `S` | 选择其他 session（方向键 ↑↓ 选择，→ 展开，← 收起） |
| `Ctrl + A`, `C` | 新建 window |
| `Ctrl + A`, `W` | 选择其他 window |

### 翻阅与复制

```bash
Ctrl + A, PageUp      # 翻阅当前 pane 的历史输出
```

鼠标滚轮也可以翻。tmux 里复制文本：

```bash
Ctrl + A, [           # 进入复制模式
# 鼠标选中文本（自动复制到 tmux 剪贴板）
Ctrl + A, ]           # 粘贴
```

> 在 tmux 里用鼠标选中文本时，**Windows / Linux 需要按住 Shift**。Mac 不支持 Shift 选文本，但这不是必须的操作。

## Vim：命令行里的文本编辑器

服务器上改配置文件，GUI 编辑器用不了，只有 vim。第一次打开你可能连退出都不会——没关系，看完这段你就会了。

```bash
vim filename    # 有则打开，无则新建
```

### 三种模式

```
┌──────────────┐  按 i   ┌──────────────┐
│  一般命令模式  │ ──────→ │   编辑模式    │
│  (默认模式)    │ ←────── │  (正常打字)   │
└──────┬───────┘   ESC   └──────────────┘
       │ 按 : / ?
       ↓
┌──────────────┐
│  命令行模式    │  保存、退出、查找替换
└──────────────┘
```

**一般命令模式**——默认模式，每个按键都是一个命令，类似游戏里放技能。

**编辑模式**——按 `i` 进入，正常打字。按 `ESC` 退出。

**命令行模式**——按 `:` `/` `?` 进入，在底部输入命令。

### 移动光标

别用鼠标。记住这几个，两周就肌肉记忆了：

| 键 | 移动 |
|----|------|
| `h` / `j` / `k` / `l` | ← / ↓ / ↑ / → |
| `0` / `$` | 行首 / 行尾 |
| `gg` / `G` | 文件开头 / 文件末尾 |
| `:n` | 跳到第 n 行 |
| `n<Enter>` | 向下移动 n 行 |

### 查找替换

```bash
/word            # 向下查找 word
?word            # 向上查找 word
n                # 重复上一次查找
N                # 反向重复上一次查找

:1,$s/old/new/g      # 全文替换
:1,$s/old/new/gc     # 全文替换，每次确认
:noh                 # 关闭高亮
```

### 复制粘贴删除

```bash
v            # 进入选中模式，移动光标选中文本
y            # 复制选中内容
yy           # 复制当前行
d            # 删除选中内容
dd           # 删除当前行
p            # 在光标下一行 / 下一个位置粘贴
u            # 撤销
Ctrl + R     # 取消撤销
```

### 保存退出

```bash
:w            # 保存
:q            # 退出
:wq           # 保存并退出
:q!           # 不保存强制退出（改错了想放弃）
:w!           # 强制保存（只读文件）
```

新手最容易崩溃的就是不知道 `:q!`。记住这一条就能活着出来。

### 实用配置

```bash
:set nu           # 显示行号
:set nonu         # 隐藏行号
:set paste        # 粘贴模式，关掉自动缩进
:set nopaste      # 恢复自动缩进
```

从网页往终端粘贴代码的时候，先 `:set paste`，否则 vim 的自动缩进会让代码层级越来越深。

### 异常处理

每次用 vim 编辑文件，会自动生成一个 `.filename.swp` 的临时文件。如果 vim 异常退出，swp 还在，下次打开会报错。

两种解决方式：
1. 找到之前打开这个文件的 vim 进程，退出
2. 直接删掉 swp 文件

## Shell 脚本入门

shell 是你和操作系统之间的翻译官——你在命令行敲的命令，本质上就是在写 shell 脚本，不过是一行一行地执行。

把它写进文件、加上逻辑，就变成了可复用的脚本。

### 什么是 Shell

Linux 默认的 shell 是 **bash**。市面上还有 zsh、fish 等变体，但 bash 最通用——你连上的任何一台服务器基本都有 bash。

```bash
#! /bin/bash
echo "Hello World!"
```

第一行 `#! /bin/bash` 告诉系统用 bash 来执行这个脚本。必须写在文件开头。

### 运行脚本

两种方式：

```bash
# 方式一：作为可执行文件
chmod +x test.sh     # 加执行权限
./test.sh            # 当前路径执行
~/test.sh            # 或绝对路径

# 方式二：用解释器执行（不需要执行权限）
bash test.sh
```

### 注释

```bash
# 单行注释：井号之后的内容会被忽略
echo "Hello"    # 这也是注释，写在一行命令后面
```

多行注释用 `:<<` 包裹：

```bash
:<<EOF
第一行注释
第二行注释
第三行注释
EOF
```

其中 `EOF` 是标识符，可以换成任意字符串：

```bash
:<<!
注释内容
!
```

### 定义与使用

```bash
name1='john'      # 单引号定义字符串
name2="john"      # 双引号定义字符串
name3=john        # 也可以不加引号，同样是字符串
```

使用变量时加 `$` 或 `${}`：

```bash
name=john
echo $name          # john
echo ${name}        # john
echo ${name}blog    # johnblog，花括号帮解释器识别边界
```

### 只读与删除

```bash
name=john
readonly name           # 设为只读
declare -r name         # 同样效果

name=abc                # 报错，只读变量不可修改

unset name              # 删除变量
echo $name              # 输出空行
```

### 局部变量 vs 环境变量

| 类型 | 能否被子进程访问 |
|------|:---:|
| 局部变量 | ✗ |
| 环境变量 | ✓ |

互转：

```bash
name=john
export name             # 局部 → 环境
declare -x name         # 同上

export name=john         # 直接定义环境变量
declare +x name         # 环境 → 局部
```

区别在哪？你在终端定义的普通变量，子 shell（比如你在 shell 里再开一个 bash）读不到。但环境变量可以。配 `PATH`、`JAVA_HOME` 这类系统配置时必须是环境变量。

### 字符串

单引号与双引号的区别：

```bash
name=john
echo 'hello, $name \"hh\"'    # 单引号：原样输出 → hello, $name \"hh\"
echo "hello, $name \"hh\""    # 双引号：解析变量 → hello, john "hh"
```

记住一条：**不想解析就用单引号，想解析变量就用双引号。**

```bash
name="john"
echo ${#name}           # 获取长度 → 4

str="hello, john"
echo ${str:0:5}         # 提取子串 → hello
```

### 数组

Shell 只支持一维数组，元素用空格分隔，下标从 0 开始，不限制大小。

**定义：**

```bash
array=(1 abc "def" john)        # 一行定义

array[0]=1                     # 逐个赋值
array[1]=abc
array[2]="def"
array[3]=john
```

**读取：**

```bash
echo ${array[0]}        # 单个元素
echo ${array[@]}        # 所有元素，写法一
echo ${array[*]}        # 所有元素，写法二
echo ${#array[@]}       # 数组长度
```

### if 语句

```bash
# 单层
if [ condition ]; then
    # ...
fi

# if-else
if [ condition ]; then
    # ...
else
    # ...
fi

# if-elif-else
if [ condition ]; then
    # ...
elif [ condition ]; then
    # ...
else
    # ...
fi
```

示例：

```bash
a=3
b=4

if [ "$a" -lt "$b" ] && [ "$a" -gt 2 ]; then
    echo "${a}在范围内"           # 3在范围内
fi
```

### case 语句

类似 C 的 switch：

```bash
case $变量 in
    值1)
        # ...
        ;;              # 相当于 break
    值2)
        # ...
        ;;
    *)                  # 相当于 default
        # ...
        ;;
esac
```

示例：

```bash
a=4

case $a in
    1)  echo "等于1" ;;
    2)  echo "等于2" ;;
    3)  echo "等于3" ;;
    *)  echo "其他"   ;;
esac
# 输出：其他
```

### 循环

**for...in：**

```bash
for i in a 2 cc; do echo $i; done       # 遍历列表

for file in `ls`; do echo $file; done   # 遍历当前目录文件名

for i in $(seq 1 10); do echo $i; done  # 1 到 10

for i in {a..z}; do echo $i; done       # a 到 z
```

**C 风格 for：**

```bash
for (( i=1; i<=10; i++ )); do
    echo $i
done
```

**while：**

```bash
while read name; do
    echo $name          # 读一行输出一行，Ctrl+D 结束
done
```

**until：** 条件为真时结束，和 while 相反。

```bash
until [ "${word}" == "yes" ] || [ "${word}" == "YES" ]; do
    read -p "输入 yes/YES 停止: " word
done
```

**break 与 continue：**

```bash
# continue：跳过本次循环
for (( i=1; i<=10; i++ )); do
    if [ `expr $i % 2` -eq 0 ]; then
        continue        # 跳过偶数
    fi
    echo $i             # 只输出奇数
done
```

> break 跳出当前循环（注意 shell 中 break 不能跳出 case）。

死循环处理方法：`Ctrl + C` 终止，或 `top` 找到 PID → `kill -9 PID`。

### 参数传递

运行脚本时可以传参，在脚本里用 `$1`、`$2` 获取：

```bash
#! /bin/bash
echo "文件名：$0"
echo "第一个参数：$1"
echo "第二个参数：$2"
```

```bash
$ ./test.sh hello world
文件名：./test.sh
第一个参数：hello
第二个参数：world
```

### 特殊变量

| 变量 | 含义 |
|------|------|
| `$#` | 传入的参数个数 |
| `$*` | 所有参数拼成的字符串（空格分隔） |
| `$@` | 每个参数分别用双引号括起来 |
| `$$` | 脚本当前运行的进程 ID |
| `$?` | 上一条命令的退出状态（0 = 正常，非 0 = 错误） |
| `$(cmd)` | 获取命令 `cmd` 的标准输出（可嵌套） |
| `` `cmd` `` | 同上（不可嵌套，老式写法） |

最常用的是 `$?`——判断上一步有没有出错：

```bash
git pull
if [ $? -ne 0 ]; then
    echo "拉取失败，终止部署"
    exit 1
fi
```

`$(command)` 用于把命令结果赋给变量：

```bash
today=$(date +%Y%m%d)
echo "今天是 $today"
```

### 函数

Shell 函数的 `return` 返回的是 exit code（0-255），不是值。想返回值用 `echo` + `$()` 捕获。

```bash
func() {
    name=john
    echo "Hello $name"
    return 123
}

output=$(func)      # 捕获 stdout
ret=$?              # 获取 return 值

echo "output = $output"   # output = Hello john
echo "return = $ret"      # return = 123
```

函数的 `$1`、`$2` 是传入参数（注意 `$0` 仍然是脚本文件名，不是函数名）。

**局部变量：**

```bash
func() {
    local name=john     # 只在函数内有效
    echo $name
}
func
echo $name             # 空——外部访问不到
```

递归求和示例：

```bash
func() {
    if [ $1 -le 0 ]; then
        echo 0
        return 0
    fi
    sum=$(func $(expr $1 - 1))
    echo $(expr $sum + $1)
}

echo $(func 10)          # 55
```

### read 命令

`read` 从标准输入读取一行，赋给变量：

```bash
read name              # 等待输入，输入的内容赋给 name
echo $name             # 打印刚刚输入的内容
```

```bash
read -p "请输入用户名: " -t 30 username
```

`-p` 显示提示信息，`-t` 设置超时秒数。30 秒不输入就跳过。

### echo 命令

```bash
echo "Hello World"
echo Hello World        # 引号可省略
```

**转义与变量：**

```bash
echo "\"Hello\""        # 双引号里可以转义 → "Hello"
echo "My name is $name" # 取变量

echo '$name\"'          # 单引号：原样输出 → $name\"
```

**换行与不换行：**

```bash
echo -e "Hi\n"          # -e 开启转义，\n 换行
echo -e "Hi \c"         # \c 不换行
echo "world"            # 输出 Hi world（同一行）
```

**重定向与命令结果：**

```bash
echo "Hello" > output.txt   # 覆盖写入文件
echo `date`                 # 输出命令执行结果
```

### printf 命令

类似 C 语言的 `printf`，格式化输出，默认不换行：

```bash
printf "%10d.\n" 123              # 占10位，右对齐 → "       123."
printf "%-10.2f.\n" 123.123       # 占10位，2位小数，左对齐 → "123.12    ."
printf "My name is %s\n" "john"    # 字符串
printf "%d * %d = %d\n" 2 3 `expr 2 \* 3`  # 2 * 3 = 6
```

### expr 命令

`expr` 用于求表达式的值，输出到 stdout。规则：

- 每一项用**空格**隔开
- 特殊字符用**反斜杠**转义
- 含空格的字符串用**引号**括起来

```bash
str="Hello World!"

echo `expr length "$str"`       # 字符串长度 → 12
echo `expr index "$str" aWd`    # a/W/d 中任意字符首次出现的位置（下标从1开始）→ 7
echo `expr substr "$str" 2 3`   # 从第2个字符开始取3个 → ell
```

算术运算：

```bash
a=3
b=4

echo `expr $a + $b`             # 7
echo `expr $a - $b`             # -1
echo `expr $a \* $b`            # 12（* 需转义）
echo `expr $a / $b`             # 0（整除）
echo `expr $a % $b`             # 3
echo `expr \( $a + 1 \) \* \( $b + 1 \)`  # 20
```

逻辑运算：

```bash
echo `expr $a \> $b`            # 0（false）
echo `expr $a '<' $b`           # 1（true，引号也可以防转义）
echo `expr $a \& $b`            # 3（都非零，返回第一个）
echo `expr $a \| $b`            # 3（第一个非零，返回第一个）
```

### 逻辑运算符

```bash
expr1 && expr2     # 与：expr1 为假时，短路跳过 expr2
expr1 || expr2     # 或：expr1 为真时，短路跳过 expr2
```

Shell 中 exit code = 0 表示真，非 0 表示假（和 C 相反，别搞混）。

```bash
test -e test.sh && echo "存在" || echo "不存在"
```

### test 与 []

`test` 和 `[]` 用法几乎一样，用于判断文件类型、比较变量。用 exit code 返回结果，0 = true。

**文件判断：**

| 参数 | 含义 |
|------|------|
| `-e` | 文件是否存在 |
| `-f` | 是否为普通文件 |
| `-d` | 是否为目录 |
| `-r` | 是否可读 |
| `-w` | 是否可写 |
| `-x` | 是否可执行 |
| `-s` | 是否为非空文件 |

```bash
test -e file.txt && echo "存在" || echo "不存在"
[ -d /var/log ] && echo "是目录"
```

**整数比较：**

```bash
[ $a -eq $b ]   # 等于
[ $a -ne $b ]   # 不等于
[ $a -gt $b ]   # 大于
[ $a -lt $b ]   # 小于
[ $a -ge $b ]   # 大于等于
[ $a -le $b ]   # 小于等于
```

**字符串比较：**

```bash
[ -z "$str" ]           # 是否为空
[ -n "$str" ]           # 是否非空
[ "$a" == "$b" ]        # 是否相等
[ "$a" != "$b" ]        # 是否不等
```

**多重条件：**

```bash
[ -r file ] -a [ -x file ]    # -a 同时成立
[ "$a" -gt 0 ] -o [ "$b" -gt 0 ]  # -o 至少一个成立
[ ! -x file ]                 # 取反
```

**重要**：`[]` 内每一项用空格隔开，变量用双引号括起来：

```bash
name="hello world"
[ "$name" == "hello world" ]    # ✓ 正确
[ $name == "hello world" ]      # ✗ 错误，变量展开后变成多个参数
```

### 文件重定向

每个进程有三个默认文件描述符：

| 描述符 | 名称 | 说明 |
|--------|------|------|
| 0 | stdin | 标准输入 |
| 1 | stdout | 标准输出 |
| 2 | stderr | 标准错误输出 |

**重定向命令：**

| 命令 | 效果 |
|------|------|
| `cmd > file` | stdout 覆盖写入 file |
| `cmd >> file` | stdout 追加写入 file |
| `cmd < file` | 从 file 读取 stdin |
| `cmd n> file` | 文件描述符 n 重定向到 file（如 `2> err.log`） |

**示例：**

```bash
echo "Hello" > output.txt      # 写入
echo "World" >> output.txt     # 追加

read str < output.txt           # 从文件读取
echo $str                      # Hello World
```

同时重定向 stdin 和 stdout：

```bash
# test.sh
read a
read b
echo $(expr "$a" + "$b")
```

```bash
$ ./test.sh < input.txt > output.txt
$ cat output.txt
7
```

### 管道

管道 `|` 把前一个命令的 stdout 传给下一个命令的 stdin。

要点：

- 只传 stdout，不传 stderr
- 右边命令必须能接收 stdin
- 多个管道可以串联

```bash
# 统计当前目录下所有 .py 文件的总行数
find . -name '*.py' | xargs cat | wc -l
```

管道 vs 文件重定向：

- 重定向：左边是命令，**右边是文件**
- 管道：左右两边都**是命令**，左边有 stdout，右边有 stdin

### 环境变量

环境变量是全局配置，所有进程都能访问。

**查看：**

```bash
env               # 当前用户的所有环境变量
echo $PATH        # 查看某个变量的值
```

**永久生效：**

把修改写到 `~/.bashrc`，然后 `source ~/.bashrc`。每次启动 bash、SSH 登录、tmux 新开 pane 都会自动加载。

**常用环境变量：**

| 变量 | 含义 |
|------|------|
| `HOME` | 用户家目录 |
| `PATH` | 可执行文件的搜索路径，`:` 分隔，从左到右匹配 |
| `LD_LIBRARY_PATH` | 动态链接库 `.so` 的路径 |
| `C_INCLUDE_PATH` | C 头文件路径 |
| `PYTHONPATH` | Python 包的搜索路径 |
| `JAVA_HOME` | JDK 安装目录 |
| `CLASSPATH` | Java 类路径 |

### 引入外部文件

类似 C 的 `#include`，bash 可以用 `.` 或 `source` 引入其他脚本：

```bash
. filename       # 注意点和文件名之间有空格
source filename  # 等效
```

示例：

```bash
# test1.sh
#! /bin/bash
name=john
```

```bash
# test2.sh
#! /bin/bash
source test1.sh
echo "My name is: $name"    # 可以使用 test1.sh 的变量
```

```bash
$ ./test2.sh
My name is: john
```

### exit 命令

`exit` 退出当前 shell，返回 exit code（0-255，0 表示成功，其余表示失败）。用 `$?` 获取。

```bash
#! /bin/bash

if [ $# -ne 1 ]; then
    echo "参数个数错误"
    exit 1
else
    echo "参数正确"
    exit 0
fi
```

```bash
$ ./test.sh hello
参数正确
$ echo $?           # 0

$ ./test.sh
参数个数错误
$ echo $?           # 1
```

### 一个实用脚本

自动备份项目目录，以日期命名：

```bash
#! /bin/bash
# backup.sh —— 备份指定目录

src=$1
dst="./backup/$(date +%Y%m%d_%H%M%S)"

if [ -z "$src" ]; then
    echo "用法: ./backup.sh <目录路径>"
    exit 1
fi

if [ ! -d "$src" ]; then
    echo "错误: $src 不是有效目录"
    exit 1
fi

mkdir -p "$dst"
cp -r "$src"/* "$dst/"
echo "备份完成: $dst"
```

这个脚本就是你以后写自动化任务的基础模板——检查参数 → 验证条件 → 执行 → 反馈结果。

### 学习技巧

shell 脚本不要死记硬背。不清楚某个语法的行为，直接在终端里跑一下——bash 的特性就是即时反馈，边试边学最快。

## Git：版本控制

### 三个区域

```
工作区          暂存区          版本库
(写代码)  ──→  (git add)  ──→  (git commit)
  ↑                              │
  └──────── git checkout ────────┘
```

工作区和暂存区独立于分支，切换分支不影响暂存区的内容。

### 基础配置

```bash
git config --global user.name "Ustinus"
git config --global user.email "2917321268@qq.com"
```

### 高频命令

```bash
git init                          # 初始化仓库
git add file.txt                  # 添加文件到暂存区
git add .                         # 添加所有改动
git commit -m "提交说明"           # 提交到版本库
git status                        # 查看当前状态
git diff                          # 查看未暂存的改动
git log                           # 查看提交历史
git reflog                        # 查看 HEAD 移动历史（包含被回滚的）
```

### 版本回退

```bash
git reset --hard HEAD^            # 回退一个版本
git reset --hard HEAD~100         # 回退 100 个版本
git reset --hard 版本号            # 回退到指定版本
git checkout -- file.txt          # 撤销工作区改动（未 add 的）
```

### 远程仓库

```bash
git remote add origin git@github.com:user/repo.git   # 关联远程仓库
git push -u origin master         # 首次推送（-u 建立追踪）
git push                          # 之后直接 push
git clone git@github.com:user/repo.git  # 克隆仓库
git pull                          # 拉取并合并
```

### 分支

```bash
git branch                        # 查看所有分支
git checkout -b feature           # 创建并切换到新分支
git checkout master               # 切换分支
git merge feature                 # 合并 feature 到当前分支
git branch -d feature             # 删除本地分支
git push -d origin feature        # 删除远程分支
```

### 暂存工作现场

```bash
git stash                         # 暂存当前改动
git stash list                    # 查看暂存列表
git stash pop                     # 恢复最近的暂存并删除
git stash apply                   # 恢复但不删除
```

## Thrift

Apache Thrift 是一个跨语言的 RPC 框架，由 Facebook 开发后贡献给 Apache。用一套 IDL（接口定义语言）写接口，自动生成多语言的客户端和服务端代码。

官网：https://thrift.apache.org

### 核心概念

```
┌──────────┐                    ┌──────────┐
│  Client  │ ──── RPC 调用 ───→ │  Server  │
│ (任意语言) │ ←──  返回结果  ──── │ (任意语言) │
└──────────┘                    └──────────┘
         ↑                          ↑
         └────────  Thrift IDL ─────┘
              (统一的接口定义)
```

你写一个 `.thrift` 文件定义接口，Thrift 编译器自动生成对应语言的代码。client 和 server 可以用不同语言——比如 client 是 Python，server 是 C++。

### 安装

```bash
# Ubuntu / Debian
sudo apt install thrift-compiler

# macOS
brew install thrift
```

### 示例

定义一个服务：

```thrift
// calc.thrift
service Calculator {
    i32 add(1: i32 a, 2: i32 b),
    i32 multiply(1: i32 a, 2: i32 b),
}
```

生成代码：

```bash
thrift --gen py calc.thrift     # 生成 Python 代码
thrift --gen cpp calc.thrift    # 生成 C++ 代码
thrift --gen java calc.thrift   # 生成 Java 代码
```

### 基本类型

| Thrift 类型 | 说明 |
|-------------|------|
| `i32` | 32 位有符号整数 |
| `i64` | 64 位有符号整数 |
| `double` | 64 位浮点数 |
| `string` | 字符串 |
| `bool` | 布尔值 |
| `list<T>` | 有序列表 |
| `set<T>` | 无序集合 |
| `map<K,V>` | 键值对映射 |

### 传输协议

Thrift 支持多种传输层：

- **TSocket**：阻塞式 TCP（最常用）
- **TFramedTransport**：带帧头，非阻塞服务端用
- **TMemoryBuffer**：内存读写，用于测试

### 序列化协议

- **TBinaryProtocol**：二进制（默认，性能好）
- **TCompactProtocol**：紧凑二进制（节省带宽）
- **TJSONProtocol**：JSON 格式（可调试）

## 常用命令速查

### 系统状态

```bash
top               # 任务管理器，M=按内存排序，P=按CPU排序，q=退出
df -h             # 硬盘使用情况
free -h           # 内存使用情况
du -sh            # 当前目录占用空间
ps aux            # 所有进程
kill -9 pid       # 强制终止进程
netstat -nt       # 网络连接
w                 # 当前登录用户
ping baidu.com    # 检查网络
```

### 文件检索

```bash
find . -name '*.py'           # 搜索 .py 文件
grep xxx                      # 过滤匹配的行
wc -l                         # 统计行数（-w 单词，-c 字节）
tree                          # 目录树（-a 显隐藏文件）
cut -d ':' -f 1,3            # 按冒号分割，取第1、3列
sort                          # 按字典序排序
xargs                         # stdin 转命令行参数
```

### 文件浏览

```bash
head -3 file.txt              # 前3行
tail -3 file.txt              # 后3行
tail -f app.log               # 实时追踪
more / less file.txt          # 翻页浏览（q 退出）
```

### 实用工具

```bash
md5sum file.txt               # 计算 MD5
time command                  # 计时
history                       # 历史命令
diff a.txt b.txt              # 比较文件差异

tar -zcvf xxx.tar.gz dir/     # 打包压缩
tar -zxvf xxx.tar.gz          # 解压

watch -n 0.1 command          # 每0.1秒执行一次
```

### 安装软件

```bash
sudo apt install xxx          # 系统软件
pip install xxx --user        # Python 包
```

## 云服务器

云平台的作用：跑 Docker 容器，获得公网 IP 让外界访问。

推荐配置：

- **1 核 2GB**（前期够用，后期动态扩容）
- 带宽选**按量付费**，最大带宽拉满（费用看实际用量，不是看上限）
- 系统：**Ubuntu 20.04 LTS**（统一版本，避免兼容问题）

阿里云、腾讯云、华为云任选。学生机一年几十块。

- 阿里云：https://www.aliyun.com（首次登录用 root）
- 腾讯云：https://cloud.tencent.com（首次登录用 ubuntu，不是 root）
- 华为云：https://www.huaweicloud.com（首次登录用 root）

### 新服务器初始化

拿到服务器后，先创建日常使用的用户（不要直接用 root）：

```bash
ssh root@公网IP

adduser acs                    # 创建用户
usermod -aG sudo acs           # 添加 sudo 权限
```

退回本地，配置别名和免密登录（参考上文 SSH 部分），然后把本地的配置文件同步过去：

```bash
scp ~/.bashrc ~/.vimrc ~/.tmux.conf myserver:
```

### 安装 tmux 和 Docker

```bash
ssh myserver

sudo apt update
sudo apt install tmux

tmux    # 以后所有操作都在 tmux 里做，防止断连丢进度
```

在 tmux 里安装 Docker（参考 Docker 官方文档）。养成习惯：ssh 进服务器第一件事就是开 tmux。

## Docker 基础

### 权限

```bash
sudo usermod -aG docker $USER   # 免 sudo 执行 docker
# 执行后需要退出重新登录才生效
```

### 镜像

```bash
docker pull ubuntu:20.04        # 拉取镜像
docker images                   # 列出本地镜像
docker rmi ubuntu:20.04         # 删除镜像
docker save -o ubuntu.tar ubuntu:20.04   # 导出
docker load -i ubuntu.tar                # 导入
```

`save/load` 保留完整历史，体积更大；`export/import` 只保留快照。

### 容器

```bash
docker run -itd ubuntu:20.04              # 创建并启动
docker ps -a                              # 查看所有容器
docker start / stop / restart CONTAINER   # 启停
docker attach CONTAINER                   # 进入容器（Ctrl+P, Ctrl+Q 挂起不退出）
docker exec CONTAINER command             # 在容器中执行命令
docker rm CONTAINER                       # 删除容器
docker container prune                    # 删掉所有已停止的容器

docker cp file.txt CONTAINER:/path/       # 本地 → 容器
docker cp CONTAINER:/path/file.txt ./     # 容器 → 本地
```

### 容器管理

```bash
docker top CONTAINER        # 容器内进程
docker stats                # CPU / 内存 / 网络统计
docker rename old new       # 重命名
docker update CONTAINER --memory 500MB  # 限制内存
```

### 实战：Docker 里跑 SSH 服务

```bash
docker run -p 20000:22 --name myserver -itd ubuntu:20.04
docker attach myserver
passwd                      # 设 root 密码
```

去云平台安全组放行端口 20000。之后就能 SSH 进容器：

```bash
ssh root@公网IP -p 20000
```

### apt 加速

下载慢的话，换清华源：https://mirrors.tuna.tsinghua.edu.cn

## 实战：部署代码到服务器

这是你以后会反复做的流程：

```bash
ssh user@my-server              # 1. 连上
cd /var/www/my-app              # 2. 进目录
git pull                        # 3. 拉代码
npm install                     # 4. 装依赖
pm2 restart app.js              # 5. 重启
pm2 logs app.js --lines 20      # 6. 确认日志正常
```

## 接下来

这篇文章会持续更新。我自己也在学习 Linux，写博客本身就是一种最好的学习方式——这其实就是费曼学习法的核心：把学到的东西用自己的话讲出来，讲到别人能听懂，才算真的懂了。希望能和你一起把 Linux 学透、讲透。

后续打算补充：`systemd` 服务管理、`cron` 定时任务、Docker Compose 编排、Shell 脚本实战。有想先看的，评论区告诉我。

---

*部分内容参考了 AcWing yxc 的 Linux 基础、tmux/vim、shell 语法教程，结合个人使用经验整理。*
