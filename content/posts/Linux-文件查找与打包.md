---
title: Linux 文件查找与打包
mathjax: true
date: 2019-11-30 21:03:21
tags:
categories:
---

内容来自[实验楼](https://www.shiyanlou.com/)

##### find

`find` 命令用于在目录下查找文件，并且会打印所找到文件的有关信息，`find` 的使用情况如下所示：

```
find [path...] [expression]
```

这里的 `[expression]` 由下面四种类型组成：

- `options` 配置项

  影响整体的操作

- `tests` 测试项

  返回一个 `true` 或 `false` 值，这些取决于文件的属性

- `actions` 操作项

  根据对应的操作，

- `operators` 运算符

  连接其它的参数。

例如下面的这个例子，查找 `/etc` 目录下，文件大小大于 100k 的文件

```
$ sudo find /etc/ -size +100k   
```

<img width="300" src="https://raw.githubusercontent.com/zhanyeye/Figure-bed/win-pic/img/20191130211036.png">

这里需要说明的是，对于数值参数，可以指定为：

- `+n` 大于 n
- `-n` 小于 n
- `n` 等于 n

<!--more-->

###### 文件名

通配符

对于常用的 `find` 和 `locate` 命令来说，可以通过一个包含特殊字符串的 `shell 模式（Shell Pattern）` 去比较文件名或者部分文件名。 这里的特殊字符串又被称为 `通配符(wildcards)` ，通配符是一些特殊字符，又被称为 `元字符(metacharacters)`，在后面的内容中我们统一称为 `通配符`

下面我们介绍常见的 `shell pattern` 中用到的通配符：

- `*` ： 匹配 0 个 或多个字符
- `?` ： 匹配任意 1 个字符
- `[string]` ：匹配 `string` 字符串中的任意一个字符，如 `[abc]` 匹配 `abc` 三个字符中的任意一个，`[a-z0-9]` 匹配小写字母和数字。
- `\` ：移除特殊字符的特殊含义，转义。如：空格



基础名称模式

- `-name` ：指定名称
- `-iname` ：指定名称忽略大小写

基础名称是指删除文件的前导目录，如果能够匹配到，则为 `True` ，我们知道 `find` 会打印所找到文件的有关信息，但是默认情况下，`find` 命令只会打印符合给定条件的文件名称到标准输出下。

如下的简单示例，查找 `/usr` 目录下以字母 `r` 开头， `.txt` 结尾的文件：

```
$ find /usr -name "r*.txt"
```

如下所示，使用 `-iname` 参数，不区分大小写。

```
$ find /usr -iname "r*.txt"
```



全名模式

- `-path` ：指定路径
- `-wholename` ：功能同 `-path` 类似

同 `-name` 一样，`-path` 和 `-wholename` 也有对应的忽略大小写的参数，即 `-ipath` 和 `-iwholename` 。在使用 `-path` 参数时，需要指定从被搜索目录开始的 `全名`，也就是 `-path` 参数值的前缀需要跟被搜索目录一致。

例如，在 `/usr/bin` 目录下搜索 `python` 文件，使用绝对路径可以这样写：

```
$ find /usr/bin -path /usr/bin/python
```

如果当前目录为 `/usr`，也可以使用相对路径：

```
$ find bin -path bin/python
```



正则表达式

- `-regex`
- `-iregex`

正如 `regex` 的中文释义一样，这里代指 `正则表达式`，与上面所说的通配符并不一样。`-regex` 可以通过正则表达式去匹配，并且我们可以通过 `-regextype` 选项去指定正则表达式的类型，常用的选项有（`emace`, `posix-awk`, `posix-egrep`），如使用 `-regextype posix-awk` ，代表与 `POSIX awk` 命令兼容的正则表达式。



###### 链接

符号链接

符号链接 （symbolic links）是引用其他文件的名称。`find` 命令对符号链接的处理方式一般为检查链接本身或者检查链接所指向的文件。默认情况下， `find` 检查符号链接本身，即默认的 `-P` 选项。如果想要检查链接所指向的文件，可以使用 `-L` 参数。而 `-H` 参数，则代表除了处理命令行参数之外，不遵循符号链接。需要注意的是 `-P`，`-H`，`-L` 参数都必须在命令行上使用文件名之前指定此选项。

- `-lname`
- `-ilname`

`-lname` 属于测试项，用于匹配文件是否为一个符号链接，与对应的 `-ilname` 参数的区别同上面的大多数参数一样，不区分大小写。

如下所示，我们分别查找 `/usr/bin` 目录下文件名包含 `python3` 的文件，和使用 `-lname` 参数，对得到的结果进行筛选，仅列出符号链接：

```
$ find /usr/bin -name "*python3*"
```

![此处输入图片的描述](https://doc.shiyanlou.com/document-uid377240labid3903timestamp1509355442069.png/wm)

```
$ find /usr/bin -lname "*python3*"
```

![此处输入图片的描述](https://doc.shiyanlou.com/document-uid377240labid3903timestamp1509355467324.png/wm)

硬链接

- `-samefile` 测试项

  如下示例，我们使用 `-samefile` 参数来得到当前目录下和 `file1` 文件 inode 相同的硬链接。

  ```bash
  $ find -samefile file1
  ```

- `-inum n` 测试项

  文件的 `inode` 号 `n`，`n` 是数值参数，可以是 `-n` 和 `+n`

  每个 inode 都有一个号码，我们可以通过数值参数 `n` 来匹配相应的文件。

- `-links n` 测试项

  文件有 `n` 个硬链接，`n` 是数值参数，可以是 `-n` 和 `+n`

  除此之外，硬链接的数目，也可以作为 `find` 的参数进行使用我们可以查看文件的硬链接数目，来判断与我们使用的 `-inum` 参数得到的结果是否一致。如下所示，匹配当前目录下硬链接数为 `3` 的文件。

  ```
  $ find -links 3
  ```



###### Time

每个文件都有三个时间戳，分别为：

- 访问（上一次访问文件的时间）
- 更改（改变文件或其属性的时间）
- 修改（修改文件内容的时间）

注：部分系统还会有文件的创建时间，例如 (windows)。

下面我们将介绍 `find` 命令中使用到这些时间戳的参数

- `-atime n` 测试项

文件上一次访问时间是在 `n*24` 小时之前。需要注意的是，如果我们使用的 `n` 值为 `0`，则向下取整，意味着距离上一次访问文件时间不足 `24` 小时。同样 `n` 是数值参数，可以是 `-n` 和 `+n`

- `-ctime n` 测试项

  这里代表的是状态的改变

- `-mtime n` 测试项

  这里代表文件内容被修改

为了方便记忆，我们可以将英文单词关联起来，这里的 `a` 是`access`，`c` 为 `change` ，而 `m` 则为 `modify`。

除了用 `24` 小时计数之外，我们还可以细化到 `minute` 多少分钟，与上面对应的参数应该为：

- `-amin n`
- `-cmin n`
- `-mmin n`

如下示例，我们查找当前目录下，修改文件的时间在 `5` 分钟 到 `24` 小时之间：

```bash
$ find -mtime 0 -mmin +5
```

###### Size

文件的大小也是文件的属性中很重要的一栏，

- `-size n[bckwMG]`

这里的 `n` 是数据参数，`b` 代表块 `block`，`c` 代表字节，`k` 代表 1024 字节，即 kb，`w` 代表字符数量（2-byte 的字符），`M` 代表兆字节，`G` 代表千兆字节。

例如，查找当前目录下的大于 `100k` 的文件。

```bash
$ find -size +100k
```

###### type

这里我们仅介绍一些常用的文件类型

- `-type c` 测试项

这里代表 `c` 可以是以下的文件类型（仅列出部分文件类型）：

- `d` 目录
- `f` 普通文件
- `l` 符号链接

例如，查找 `/etc` 目录下，文件大小大于 `30k` 并且为普通文件的文件：

```
sudo find /etc -type f -size +30k
```

###### Owner

- `-user uname`

- `-group gname`

  如上所示，`uname` 代表文件所属用户的名字，`gname` 代表文件所属组的名字

- `-uid n`

- `-gid n`

  这里的 n 分别代指用户 `id` 和 组 `id`

如下所示，分别查找当前目录下所属用户为 `shiyanlou` 的文件，以及所属用户为 `root` 的文件

```
$ find -user shiyanlou

# root 用户的 id 为 0
$ find -uid 0
```

###### Exec

我们一般查找出来文件并不仅仅是看看而已，还会有进一步的操作，这个时候就要用到 `-exec` 选项。

+ 用法

  `-exec` 选项后面紧跟要执行的命令或脚本，然后是 `{}`、空格和 `\;`。考虑到各个系统中 `;` 有不同的意义，所以前面要加反斜杠。有时使用这一选项是为了查找文件并删除它们。建议在真正执行删除之前，先确认一下。

  `-ok` 选项的作用与上面的 `-exec` 一样，但它会增加一个额外的确认环节，对于查询结果的下一步操作，如果确认则输入 `y` 回车，如果否认则输入 `n` 回车。

+ 实例 1

  目标：显示查找出来的文件的详细信息

  命令：`find . -type f -exec ls -l {} \;`

  find 命令匹配到了当前目录下的所有普通文件，在 -exec 选项中使用 `ls -l` 命令将它们列出。

+ 实例 2

  目标：删除当前目录下修改时间在 14 天前的文件

  命令：`find . -type f -mtime +14 -exec rm {} \;`

  删除文件之前，应先查看要删除的文件，一定要小心！

+ 实例 3

  目标：删除当前目录下后缀为 log 的文件，并在删除之前确认

  命令：`find . -name '*.log' -ok rm {} \;`

  删除之前需要确认，按 `y` 键删除文件，按 `n` 键不删除。

+ 实例 4

  目标：查找 `/etc` 目录下以 `passwd` 打头，并且内容包含 root 的文件

  命令：`find /etc -name 'passwd*' -exec grep 'root' {} \;`

  find 命令首先匹配所有文件名为 `passwd*` 的文件，例如 `passwd、passwd.old、passwd.bak` 等，然后执行 `grep` 命令查看这些文件中是否存在 root 用户。



##### locate

除了使用 `find` 命令外，我们也可以使用 `locate` 命令来实现快速查找。但是不同于 `find` 命令，`locate` 命令其实是在一个保存有系统中所有文件名和目录名的数据库中去查找。而数据库中的内容并不是实时更新的，该数据库的更新操作可以使用 `updatedb` 命令来执行。

如下，我们查找文件名中含有 `/usr/bin/python` 的文件

```
$ locate /usr/bin/python
```

也可以使用 `--basename` 参数，查找基础名称，如下所示，查找基础名称中带有 `shiyanlou` 的文件

```
$ locate --basename shiyanlou
```

##### whereis

`whereis` 命令同 `locate` 类似，也是在一个保存有系统中所有文件名和目录名的数据库中去查找。不同的在于`whereis` 命令查找的是二进制文件，源，或者 man 手册的文件。

下面我们将会介绍一些该命令的常用参数并简单示例：

- `-f` 定义搜索范围
- `-b` 仅搜索二进制文件
- `-m` 仅搜索 `man` 手册
- `-s` 仅搜索源

例如，搜索 `python` 相关的帮助手册:

```
$ whereis -m python
```

##### which

`which` 命令一般用于查找 `shell` 命令的完整路径。该命令在环境变量`PATH`中列出的目录中搜索可执行文件或脚本进行匹配查找。

常用的如 `-a` 参数，代表列出所有匹配的查找结果，而不仅仅是第一个。

示例如下，查找 `python` 可执行文件的路径：

```
$ which python
```

##### 文件打包和解压

###### gzip

`gzip` 命令用于对文件进行压缩，生成的压缩文件会以 `.gz` 结尾。而对应的解压缩的命令则是 `gunzip`。两个命令的使用格式情况如下：

```
 gzip -v file
 gunzip -v file
```

简单示例，这里我们创建一个 `file4` 文件：

```
$ touch file4
$ gzip file4
$ ls
```

结果如下图，`file4` 文件消失，取而代之的是被压缩过的文件 `file4.gz`:

解压文件 `file4`:

```
$ gunzip file4.gz
```

 <img width="500" src="https://raw.githubusercontent.com/zhanyeye/Figure-bed/win-pic/img/20191201090607.png">

###### tar

`tar` 是用于创建文件档案的命令行工具，多用于备份文件。顾名思义，`tar` 命令可以将一系列的文件打包到一个大文件中，也可以将大文件解包以恢复数据。下面，我们将介绍 `tar` 的常用参数，并简单示例。

**注意：打包时一般使用相对路径，不然解压时会解压到绝对路径下面，可能会覆盖文件！**

tar 命令的格式大致如下

```
tar [OPTION...] [FILE]
```

- `-c` 或 `--create` ：创建一个存档
- `-r` ：将文件附加到档案文件末尾
- `-z` 或 `--gzip` ：指定 `gzip` 格式
- `-v` 或 `--verbose` ：显示文件处理的详细过程
- `-f` ：指定档案文件名称
- `-x` ：还原档案文件

我们使用 `tar` 命令将四个文件归档到 `test.tar` 中：

```
$ tar -cvf test.tar file1 file2 file3 file4

$ ls
```

这时我们可以看见 `test.tar` 已经创建成功，接着我们删除四个文件，并从 `test.tar` 恢复文件：

```
$ rm file1 file2 file3 file4

$ ls

$ tar -xvf test.tar
```

 <img width="500" src="https://raw.githubusercontent.com/zhanyeye/Figure-bed/win-pic/img/20191201091459.png">