---
title: Linux 管道符
mathjax: true
date: 2019-12-03 08:05:56
tags:
categories:
---

内容来自[实验楼](https://www.shiyanlou.com/)

##### stdio

对于 Linux 内核中的标准 I/O 库 stdio 提供了一个高效的缓存 I/O 流接口。

一般情况下，每个程序在启动时都会有三个 stream（流）在启动时被预定义，一个用于输入，一个用于输出，还有一个用于打印诊断或者错误信息。

对于 linux 系统中来说，读取标准输入和打印标准输出的地方默认情况下都是所使用的终端。对应 shell 中常使用的三种标准 I/O 流：

- `stdin`
- `stdout`
- `stderr`

<!--more-->

###### stdin

输入流（input stream）被称作标准输入（standard input），缩写形式即为 `stdin`。在程序启动时，与 `stdin` 关联的整数文件描述符为 `0`。

这里我们引入文件描述符的概念(百度百科的定义)：

- 内核（kernel）利用文件描述符（file descriptor）来访问文件。
- 文件描述符是非负整数。打开现存文件或新建文件时，内核会返回一个文件描述符。读写文件也需要使用文件描述符来指定待读写的文件。
- 实际上，它是一个索引值，指向内核为每一个进程所维护的该进程打开文件的记录表。当程序打开一个现有文件或者创建一个新文件时，内核向进程返回一个文件描述符。

###### stdout

输出流（output stream）被称作标准输出（standard output），缩写形式即为 `stdout`。在程序启动时，与 `stdout` 关联的整数文件描述符为 `1`。

###### stderr

错误流（error stream）被称作标准错误输出（standard error），缩写形式即为 `stderr`。在程序启动时，与 `stderr` 关联的整数文件描述符为 `2`。

##### 管道符

对于 Linux 管道来说可以用于 Linux 程序之间，Linux 命令之间以及 Linux 程序和命令之间的通信。 在 shell 中，管道符（pipeline）是 shell 编程中众多控制操作符其中的一个，用来分隔一个或多个命令的序列。shell 编程中管道符号是竖杠符号 `|`（但是有时会使用到 `|&` 符号，该用法将在后面的内容中详细描述）

在 shell 中使用管道的格式如下，代表着 `command1` 的标准输出作为 `command2` 的标准输入使用，而 `command2` 的标准输出又作为 `command3` 的标准输入使用：

```
command1 | command2 | command3
```

简单示例，匹配字符串 `shiyanlou`：

```
$ echo "shiyanlou001" | grep "shiyanlou"
```

##### 重定向

在执行命令之前，我们可以使用 shell 解释的特殊符号重定其输入和输出。

###### 重定向输入

重定向输入的一般格式为：

```
[n] < file
```

这里代表的意思是将输入从文件描述符为 `n` 的文件重定向到 `file`。

不指定 `n` 时，文件描述符 `n` 为 `0`，为标准输入。代表着将输入从标准输入重定向到 `file` 中。

###### 重定向输出

重定向输出的一般格式为:

```
[n] > file
```

这里代表的意思是将输出从文件描述符为 `n` 的文件重定向到 `file`。

不指定 `n` 时，文件描述符 `n` 为 `1`，为标准输出。代表着将输出从标准输出重定向到 `file` 中。

这里需要注意的是，如果 `file` 不存在，将会创建 `file`，如果 `file` 存在，文件大小将被设为 `0`，然后输出，即覆盖原有文件的内容。如果需要将输出内容附加到文件中，需要使用 `>>` 来替代 `>` 符号。

如下，命令示例说明，及运行截图。

```
$ ls

# 这里我向其中写入文本内容 `this is test1`
$ vim test1

# 使用 cat 命令查看 test1 的内容，并打印到标准输出下
$ cat test1

# 使用管道符将 test1 的内容作为标准输入，输出到 test2 中
$ cat test1 | cat > test2

# 查看 test2 的内容
$ cat test2

# 通过重定向将 test1 的内容作为标准输入，重定向到 test3 中
$ cat > test3 <test1

# 查看 test3 的内容
$ cat test3
```

###### 重定向 stdout 和 stderr

首先，我们回顾一下，管道符部分提到的 `|&` 符号，使用的格式如下：

```
command1 |& command2
```

代表着将 `command1` 命令的标准输出和标准错误作为 `command2` 的标准输入。不同于 `|`，这里多了一个标准错误的选项。

如下示例，我们查看一个当前目录下不存在的文件 `test4`。将给出的错误信息重定向到 `test5`中：

```
$ ls test4
$ ls test4 |& cat > test5
$ cat test5
```

上述方式是使用管道符的方式，在这里，我们还可以使用重定向的方式来达到相同的效果。重定向标准输出和标准错误的格式如下：

```
&> file

或者

>& file
```

对于第一种方式，在语义上等同于 `>file 2>&1`。意思是将标准错误（文件描述符为 `2`） 重定向到标准输出（文件描述符为 `1`），然后将标准输出重定向到 `file`。

对于附加 `stdout` 和 `stderr` ，使用如下的格式:

```
&>>file

或者

>>file 2>&1 
```

更常用的一种用法是将标准输入和标准错误分别重定向到两个文件，例如 `command 2>err.log 1>info.log` 这个命令表示 `err.log` 和 `info.log` 分别用来存储 command 命令的标准错误和标准输出。

###### tee

`tee` 命令用于读取标准输入，并将其写入到标准输出和文件中。

`tee` 命令的格式为：

```
tee [option].. [file]...
```

常用参数有：

- `-a` 或 `--append` 附加到已有文件内容的后面，而不是覆盖。
- `-i` 忽略中断信号

如下示例：

```
$ tee test1 test2
```

退出 `tee` 用 `Ctrl+d`。

还可以在终端打印 stdout 同时重定向到文件中。

```
$ ls | tee out.txt
```

##### 文本处理

对于保存文本文件时，我们可以按照一定的结构去保存文本内容。类似于我们常使用的表。

例如，如下为 test1 的文本内容保存着实验楼的账号信息，分别为 ID，性别，年龄，并且由空格分隔

```
shiyanlou200 man 30
shiyanlou001 man 23
shiyanlou010 woman 30
shiyanlou002 woman 20
shiyanlou004 man 18
```

###### 排序

`sort` 命令可用于将文本内容以行为单位进行排序。

关于 `sort` 命令的详细用法可以使用 `sort --help` 查看，这里我们简单介绍一些常用的参数。

- `-u` 去除重复行
- `-t` 指定分隔字符，例如上面我们使用的空格字符，默认为空格
- `-o` 输出到指定文件
- `-k` 指定使用某一列进行排序
- `-r` 修改默认的升序排序为降序

如下，我们使用 `test1` 中的年龄进行排序，并保存到 `test2` 中。

```
$ cat test1

$ sort -k 3 -o test2 test1

$ cat test2
```

###### 合并

`paste` 命令可以将多个文件以列对列的方式加以合并。

如下示例：

```
$ cat num2
1
2
$ cat let3
a
b
c
$ paste num2 let3
1       a
2       b
        c
```

`join` 命令则可以将多个文件中有相同特征的行以类似于 `paste` 的方式进行组合。

如下示例：

```
$ cat file1
a 1
b 2
e 5

$ cat file2
a X
e Y
f Z

$ join file1 file2
a 1 X
e 5 Y
```

###### tr

Linux `tr` 命令将标准输入复制到标准输出，在这个过程中可以执行转译或删除操作。

`tr` 命令的格式如下：

```
tr [option] set1 [set2]
```

`set1` 代表需要转换的或删除的原字符集。`set2` 为转换的目标字符集。例如，我们将打印到标准输入的 `shiyanlou` 的小写字母全部转换为大写字母：

```
$ echo "shiyanlou" | tr a-z A-Z
SHIYANLOU
```

在上面的示例中 `a-z` 和 `A-Z` 都是属于集合，分别代表所有的小写字母和所有的大写字母。集合通常可以自己定义。需要注意的是，这里的字符集并不是正则表达式，只是字符列表。

例如，`m-n` 代表从 m 到 n 的所有的字符，按升序排序， `0-9` 代表的是字符集合 `0123456789`

###### xargs

`xargs` 命令可以从标准输入构建和执行命令。

`xargs` 常用来给其他命令传递参数，从标准输入读取数据，默认情况下使用空格或者换行符作为默认定界符，忽略空白行，并且在没有指定命令的时候，默认将数据传递给 `/bin/echo` ，即我们常用的 `echo` 命令作为参数。例如：

```
# 使用 tail 命令查看 /etc/hosts 的后五行
$ tail -5 /etc/hosts

# 使用 xargs 处理，默认使用 xargs echo
$ tail -5 /etc/hosts | xargs
```

运行结果如下所示，使用 xargs 后换行和空白都被一个空格所取代，即使用命令行参数的标准格式:

<img width="600" src="https://raw.githubusercontent.com/zhanyeye/Figure-bed/win-pic/img/20191203090030.png">

下面我们将介绍一些常用的参数

- `-a` 使用该参数指定从文件中读取，而不是标准输入。
- `-d` 自定义定界符
- `-n` 每行的最多参数个数

简单示例，自定义定界符为字符 `x` ，并且设定每行参数的最大参数个数为 2:

```
$ echo "shiyanlou001xshiyanlou002xshiyanlou003" | xargs -n 2 -d x

shiyanlou001 shiyanlou002
shiyanlou003
```