---
title: Linux 系统备份与恢复
mathjax: true
date: 2019-12-06 21:58:57
tags:
categories:
---

内容来自[实验楼](https://www.shiyanlou.com/)

##### 备份

###### 概述

几乎所有的备份工具都支持两种不同的备份类型：完整备份和增量备份。

对于完整备份而言，包含的是一个文件系统的全部内容。而增量备份只包括相对于上一次备份之后，发生变化的文件。

<!--more-->

###### dump

Linux `dump` 命令用于备份文件系统。对于 GNU 版本的 `dump` 来说，默认支持的是 `ext2/3/4` 文件系统的备份。如果需要备份其它文件系统，需要下载指定版本的 `dump`。

在当前实验环境中，需要安装 `dump` ，使用如下命令：

```
$ sudo apt-get install dump
```

在使用 dump 命令的时候，需要指定一个备份级别。对于以前的 `dump` 程序最多支持 0~9 级备份。在最新的版本中已经没有这个限制。

对于 `dump` 的备份等级为 `0` 时，将会把整个文件系统进行备份，称为`完整备份` 。而 `1` 则是相对与备份等级为 `0` 时所有修改的文件进行备份，这时备份方式被称为`增量备份`。

下面我们简单介绍一些常用的参数：

- `-level#` 指定备份等级，例如 `-0` 备份整个文件系统
- `-f` 指定备份设备
- `-n` 当备份工作需要管理员介入时，向所有"operator"群组中的使用者发出通知
- `-T` 指定备份的时间

将当前系统的整个文件系统进行备份，即 `/` 目录，备份到 `/home/test.dump` 中：

```
$ sudo dump -0 -f /home/test.dump  /
```

> 由于实验环境是 Docker 容器，缺乏必要的权限，dump 时会失败。如果有本地环境，可在本地操作。

进入到`/home` 目录下，我们可以看到对应的备份文件：

```
$ cd /home
$ ls
$ file test.dump
```

##### 恢复

从备份的文件中提取文件，我们称为恢复，而对于恢复而言，也可以指定仅恢复一小部分文件和恢复整个文件系统

###### restore

与 `dump` 命令对应的命令为 `restore`，在安装了 `dump` 后，就可以使用 `restore` 命令了。

`restore` 命令有几种常用的模式，并且不能混用，下面简单说明：

- `-C` 比较备份的内容与当前实际的内容的区别
- `-i` 交互模式，可以仅还原部分内容
- `-r` 还原整个文件系统
- `-t` 可以查看备份的内容

除了几种模式外，还有一些其它的参数，将会通过示例介绍。

例如，我们可以通过 `-C` 参数来比较备份的文件系统与当前文件系统的区别。

```
# -f 指定备份文件，-D 指定需要比较的文件系统
$ sudo restore -C -f test.dump -D /
```

此时，我们将备份的内容进行恢复，使用如下命令（`不建议运行，参考示例运行截图`）

```
# -T 指定需要恢复的路径

$ sudo restore -r -f test.dump -T /home
```

除了恢复整个文件系统，我们还可以仅恢复部分文件，例如，我在 `/home` 目录下创建了一个文件，进行增量备份后，然后将其删除，通过备份文件将其恢复：

```
# 创建示例文件
sudo touch shiyanlou.txt

# 进行增量备份
sudo dump -1 -f /test1.dump /

# 删除示例文件
sudo rm shiyanlou.txt

# 部分恢复
sudo restore -i -f test1.dump
```

##### 其它备份工具

在大多数时候，对于一个Linux 系统来讲，并不是所有的内容都是需要备份的。有些时候我们只需要对于一些关键数据进行备份。

例如 `/tmp` 临时目录，这里面的数据我们是没有必要去备份的。而对于需要备份的数据可能会根据实际的情况有所不同，例如，当前系统主要提供的是数据库存储等服务，那么重要的就是你的数据库文件，以及一些重要的配置信息。

而对于仅仅备份部分内容，这里我们将不再介绍使用 `dump` 工具进行操作，介绍一些其它的内容

###### tar

`tar` 命令在前面的课程中我们就已经简单介绍过，`tar` 是用于创建文件档案的命令行工具，也用于备份文件。

`tar` 命令也可以进行 `增量备份`，这里我们当前用户 `shiyanlou` 的用户目录的内容进行简单示例。

进行增量备份时 ，`tar` 需要使用到 `-g` 参数。

- `-g` 或者 `--listed-incremental` 参数指示 `tar` 进行增量归档操作，并且将额外的元数据存储在快照文件中，而此文件的作用是记录上次归档以来，哪些文件被更改，添加或者删除，以便下一次增量备份时将只包含已经修改的文件。

这时，我们将 `/home/shiyanlou/Desktop` 目录的内容进行增量备份

```
# 查看 Desktop 的内容
$ ls Desktop

# 如下所示，-g 指定快照文件，-c 指示建立归档，-f 指定归档文件名称，-v 显示详情
$ sudo tar -c -v -f shiyanlou1.tar -g metadata /home/shiyanlou/Desktop
```

执行命令后，当前 `/home/shiyanlou` 目录会有对应的归档文件和快照文件。

 <img width="400" src="https://raw.githubusercontent.com/zhanyeye/Figure-bed/win-pic/img/20191206222225.png">

接下来我们在 `/home/shiyanlou/Desktop` 目录中创建两个测试文件，进行增量备份，命令如下所示：

```
# 创建测试文件
$ touch /home/shiyanlou/Desktop/test1.txt  /home/shiyanlou/Desktop/test2.txt

# 查看创建的测试文件
$ ls Desktop

$ 创建增量备份
$ sudo tar -c -v -f shiyanlou2.tar -g metadata /home/shiyanlou/Desktop

$ ls
```

 <img width="600" src="https://raw.githubusercontent.com/zhanyeye/Figure-bed/win-pic/img/20191206223834.png">

命令执行结束后，上图中的 `shiyanlou2.tar` 则为相对于 `shiyanlou1.tar` 的增量备份，即包含创建的两个测试文件。最后，我们可以还原 `shiyanlou2.tar` 的内容，来确认这一结果。

```
$ sudo tar -xvf shiyanlou2.tar -C ./test/  
```

如下所示，在最后我们可以看到刚刚创建的测试文件出现:

 <img width="400" src="https://raw.githubusercontent.com/zhanyeye/Figure-bed/win-pic/img/20191206223139.png">

##### dd

Linux `dd` 命令是用于复制和转换**文件**。利用 `dd` 命令我们可以复制文件系统，这里我们只是简单介绍 `dd` 命令的使用。

`dd` 命令默认从标准输入读取，并且输出到标准输出。但是可以通过 `if` 和 `of` 分别重定向输入和输出到文件。

如下示例，我们将 `/etc/hosts` 复制到当前目录下的 `hosts` 中，就可以使用：

```
$ sudo dd if=/etc/hosts of=hosts
```

而对于复制文件系统，只需要将 `if=` 的参数修改为 `dev` 下对应文件系统的设备即可。

除此之外，对于 `dd` 命令，有时我们还用于临时创建 `swap` 交换分区。命令如下：

```
$ sudo dd if=/dev/zero of=test_swap bs=1M count=1024

$ sudo mkswap test_swap

$ sudo swapon test_swap  #在线环境中不能启用交换分区，这个命令无须输入
```

`dd` 命令可以使用 `bs` 设置输入输出块的大小，而`count`则是复制对应数目的块。这里的 `/dev/zero` 在Linux中属于一个特殊的文件，对应的有 `/dev/null`。`/dev/zero` 会不断输出 of= `0`，即为 `空`，而对应的 `/dev/null` 会将所有重定向到 `/dev/null` 的输出全部抛弃。对于上面的命令而言，则是通过 `/dev/zero` 复制创建一个文件大小为 `1M*1024=1024M=1G` 的名为 `test_swap` 的空文件。