---
title: Linux 日志系统
mathjax: true
date: 2020-01-02 14:21:21
tags:
categories:
---

内容来自[实验楼](https://www.shiyanlou.com/)

##### 日志文件

###### 常见的日志文件

```bash
$ sudo service rsyslog start
$ ll /var/log 
```

| 日志名称           | 信息说明                                                     |
| ------------------ | ------------------------------------------------------------ |
| `alternatives.log` | 系统的更新替代信息                                           |
| `apport.log`       | 应用程序崩溃信息记录                                         |
| `apt/history.log`  | 使用 apt-get 安装卸载软件的信息记录                          |
| `apt/term.log`     | 使用 apt-get 时的具体操作                                    |
| `auth.log`         | 登录认证的 log 信息                                          |
| `boot.log`         | 系统启动时的日志信息                                         |
| `btmp`             | 记录所有失败启动信息                                         |
| `dmesg`            | 内核缓冲信息，在系统启动时，显示屏幕上的与硬件有关的信息     |
| `dpkg.log`         | 安装或 dpkg 命令清除软件包的日志                             |
| `kern.log`         | 内核产生的日志，有助于在定制内核时解决问题                   |
| `lastlog`          | 记录所有用户的最近信息。这不是一个 ASCII 文件，因此需要用 lastlog 命令查看内容 |
| `faillog`          | 用户登录失败信息。此外，错误登录命令也会记录在本文件中       |
| `wtmp`             | 包含登录信息。使用 wtmp 可以找出谁正在登陆进入系统，谁使用命令显示这个文件或信息等 |
| `syslog`           | 系统信息记录                                                 |

<!--more-->

###### 日志格式

日志内容的一般格式

- 事件发生的时间
- 发生的主机名
- 启动的服务名称
- 实际信息内容

`cat` 命令来查看一下几个常见日志文件的格式：

```bash
# 系统的更新替代信息
$ cat /var/log/alternatives.log.1
```

```bash
...
update-alternatives 2019-12-17 14:08:49: link group serialver updated to point to /usr/lib/jvm/java-11-openjdk-amd64/bin/serialver
update-alternatives 2019-12-17 14:08:49: run with --install /usr/bin/jaotc jaotc /usr/lib/jvm/java-11-openjdk-amd64/bin/jaotc 1111
update-alternatives 2019-12-17 14:08:49: link group jaotc updated to point to /usr/lib/jvm/java-11-openjdk-amd64/bin/jaotc
update-alternatives 2019-12-17 14:08:49: run with --install /usr/bin/jhsdb jhsdb /usr/lib/jvm/java-11-openjdk-amd64/bin/jhsdb 1111
update-alternatives 2019-12-17 14:08:49: link group jhsdb updated to point to /usr/lib/jvm/java-11-openjdk-amd64/bin/jhsdb
# alternatives.log 中得到信息有程序作用，日期，命令，成功与否的返回码等信息。
```

```bash
# 从 dpkg.log 文件中可以知道 dpkg 命令安装或清除软件包的时间、安装包版本等日志信息。
$ cat /var/log/dpkg.log.1
```

```bash
...
2019-12-17 14:08:50 status half-configured systemd:amd64 237-3ubuntu10.33
2019-12-17 14:08:50 status installed systemd:amd64 237-3ubuntu10.33
2019-12-17 14:08:50 trigproc man-db:amd64 2.8.3-2ubuntu0.1 <none>
2019-12-17 14:08:50 status half-configured man-db:amd64 2.8.3-2ubuntu0.1
2019-12-17 14:08:52 status installed man-db:amd64 2.8.3-2ubuntu0.1
2019-12-17 14:08:52 trigproc ca-certificates:all 20180409 <none>
2019-12-17 14:08:52 status half-configured ca-certificates:all 20180409
2019-12-17 14:08:52 status installed ca-certificates-java:all 20180516ubuntu1~18.04.1
2019-12-17 14:08:52 status installed ca-certificates:all 20180409
```

在 `apt` 文件夹中的日志信息，其中有两个日志文件 `history.log` 与 `term.log` ，两个日志文件的区别在于 `history.log` 主要记录了进行了什么操作，相关的依赖有哪些，而 `term.log` 则是较为具体的一些操作，主要就是下载包，打开包，安装包等等的细节操作。

先来看 `var/log/apt/history.log` 文件：

```bash
Start-Date: 2020-01-02  14:56:07
Commandline: apt install tree
Requested-By: ubuntu (500)
Install: tree:amd64 (1.7.0-5)
End-Date: 2020-01-02  14:56:09
```

然后来看 `var/log/apt/term.log` 文件：

```bash
Log started: 2020-01-02  14:56:07
Selecting previously unselected package tree.
(Reading database ... 116069 files and directories currently installed.)
Preparing to unpack .../tree_1.7.0-5_amd64.deb ...
Unpacking tree (1.7.0-5) ...
Setting up tree (1.7.0-5) ...
Processing triggers for man-db (2.8.3-2ubuntu0.1) ...
Log ended: 2020-01-02  14:56:09
```

像上面几个日志的格式内容大部分都是时间，操作这样。不过还有有两个比较特殊的日志，它们的查看的方式也比较与众不同，因为这两个日志并不是 `ASCII 文件` 而是被编码成了`二进制文件`，所以不能直接使用 `less、cat、more` 这样的工具命令来查看，这两个日志文件是 **wtmp，lastlog**。

查看的方法是使用 `last` 和 `lastlog` 工具来提取其中的信息。

- last

```bash
$ last
```

- lastlog

```bash
$ lastlog --help
用法：lastlog [选项]

选项：
   -b, --before DAYS     仅打印早于 DAYS 的最近登录记录
   -h, --help         显示此帮助信息并推出
   -R, --root CHROOT_DIR chroot 到的目录 
   -t, --time DAYS 仅打印晚于 DAYS 的最近登录记录
   -u, --user LOGIN     打印 LOGIN 用户的最近登录记录
```

```bash
$ last
ubuntu   pts/0        1.190.238.60     Thu Jan  2 14:42   still logged in

$ lastlog -u ubuntu
Username         Port     From             Latest
ubuntu           pts/0    1.190.238.60     Thu Jan  2 14:42:05 +0800 2020
```

##### rsyslog 系统日志

###### rsyslog 系统日志概述


日志产生的方式一般存在两种方式：

- 一种是由软件开发商自己来自定义日志格式然后指定输出日志位置；
- 一种方式就是 Linux 提供的日志服务程序，而我们这里系统日志是通过 syslog 来实现，提供日志管理服务。

syslog 是一个系统日志记录程序，在早期的大部分 Linux 发行版都是内置 syslog，让其作为系统的默认日志收集工具，虽然时代的进步与发展，syslog 已经跟不上时代的需求，所以他被 rsyslog 所代替了，较新的 Ubuntu、Fedora 等等都是默认使用 rsyslog 作为系统的日志收集工具。

rsyslog 的全称是 rocket-fast system for log，它提供了高性能，高安全功能和模块化设计。rsyslog 能够接受从各种各样的来源，将其输入，输出的结果到不同的目的地。

其默认的 `rsyslog` 配置文件是：

- `/etc/rsyslog.conf` 文件：该配置文件主要决定需要加载的模块、文件所属者等
- `/etc/rsyslog.d/50-default.conf`。该文件主要是配置 `Filter Conditions`，详细内容后续会涉及。）

###### rsyslog 的结构框架

先通过一个简单的流程图来了解一下 `rsyslog`的结构框架和数据流走向。

 <img width="400" src="https://raw.githubusercontent.com/zhanyeye/Figure-bed/win-pic/img/20200102151850.png">

通过上面的图片可以看出`rsyslog` 主要是由

- `Input`
- `Output`
- `Parser`

三个模块构成的。

其流程是首先通过 `Input module` 来收集消息，然后将得到的消息传给`Parser module`，通过分析模块的层层处理，将真正需要的消息传给 `Output module`，然后便输出至日志文件中。

官方的 Rsyslog 架构如图中所示，rsyslog 还有一个核心的功能模块是 `Queue`，便是它的存在使得 rsyslog **高并发**优势的突出：

![此处输入图片的描述](https://doc.shiyanlou.com/document-uid276733labid3921timestamp1509882827692.png/wm)

[官方 Rsyslog 架构手册](http://www.rsyslog.com/doc/queues_analogy.html)

**Input 模块**：主要功能就是从各种各样的来源收集 messages，通过这些接口实现：

| 接口名    | 作用                                              |
| --------- | ------------------------------------------------- |
| im3195    | RFC3195 Input Module                              |
| imfile    | Text File Input Module                            |
| imgssapi  | GSSAPI Syslog Input Module                        |
| imjournal | Systemd Journal Input Module                      |
| imklog    | Kernel Log Input Module                           |
| imkmsg    | /dev/kmsg Log Input Module                        |
| impstats  | Generate Periodic Statistics of Internal Counters |
| imptcp    | Plain TCP Syslog                                  |
| imrelp    | RELP Input Module                                 |
| imsolaris | Solaris Input Module                              |
| imtcp     | TCP Syslog Input Module                           |
| imudp     | UDP Syslog Input Module                           |
| imuxsock  | Unix Socket Input                                 |

**Output 模块**，也有许多可用的接口来实现。

`Output` 也被称为 `actions`。 一个组操作内容都是预先加载的（比如输出文件编写器，几乎在每个 `rsyslog.conf` 中都使用）。

通过 action（type =“type”...）对象调用一个动作。Type 是强制性的，并且必须包含要调用的插件的名称（例如 “omfile” 或 “ommongodb”）。 其他参数可能存在。 他们的类型和使用取决于问题的输出插件。

> 补充： 这些模块接口的都需要通过 `$ModLoad` 指令来加载，在下文中会为大家展示 `/etc/rsyslog.conf` 的内容，大家可以注意前两行，其意思就是默认加载了 `imklog`、`imuxsock` 这两个模块。

在配置中 rsyslog 支持三种配置语法格式：

- sysklogd
- legacy rsyslog
- RainerScript

`sysklogd` 是比较老的简单格式，一些新的语法特性不支持。

`legacy rsyslog` 是以 `dollar 符($)`开头的语法，在 v6 及以上的版本还支持，如上文所说的 `$ModLoad` 还有一些插件和特性只在此语法下支持。而以 `$` 开头的指令是全局指令，全局指令是 `rsyslogd` 守护进程的配置指令，每行只能有一个指令。

`RainnerScript` 是最新的语法。在官网上 rsyslog 大多推荐这个语法格式来配置。

注：老的语法格式（`sysklogd & legacy rsyslog`）是以**行**为单位。新的语法格式（`RainnerScript`）可以**分割多行**。

注释有两种语法:

- 井号 `#`
- C-style`/* .. */`

执行顺序: 指令在 rsyslog.conf 文件中是**从上到下的顺序**执行的。

> 对于 `rsyslog` 环境的配置文件想要深入了解的朋友可以参看一下 [官方文档](http://www.rsyslog.com/doc/v8-stable/configuration/index.html)

###### 配置文件内容

```bash
$ cat /etc/rsyslog.conf
```



##### rsyslog 系统日志的配置

查看系统中的配置

```bash
$ vim /etc/rsyslog.d/50-default.conf 
```

**配置文件格式说明:** **日志设备(类型).(连接符号)日志级别 日志处理方式**

###### 日志设备(类型)

| 设备           | 说明                                     |
| -------------- | ---------------------------------------- |
| `auth`         | pam 产生的日志                           |
| `authpriv`     | ssh,ftp 等登录信息的验证信息，即权限系统 |
| `cron`         | 时间任务相关，计划安排                   |
| `kern`         | 内核消息                                 |
| `lpr`          | 打印                                     |
| `mail`         | 邮件系统消息                             |
| `mark(syslog)` | rsyslog 服务内部的信息,时间标识          |
| `news`         | 新闻组消息                               |
| `user`         | 用户程序产生的相关信息                   |
| `uucp`         | unix 主机之间相关的通讯                  |
| `local 1~7`    | 自定义的日志设备                         |

###### 日志级别

从上到下，日志级别由高到低，记录的信息越来越少。

| priority 取值 | 值   | 说明                                                         |
| ------------- | ---- | ------------------------------------------------------------ |
| `emerge`      | 0    | 发生严重事件，并有导致系统崩溃的潜在危险。报告软件或者硬件问题 |
| `alert`       | 1    | 严重错误消息，会导致程序关闭并可能影响其他程序               |
| `crit`        | 2    | 错误消息，可能会导致程序关闭的事件重                         |
| `err`         | 3    | 程序中存在错误的通告                                         |
| `warning`     | 4    | 程序中存在潜在问题的警告信息                                 |
| `notice`      | 5    | 程序运行中产生了值得注意的事件                               |
| `info`        | 6    | 关于程序当前状态的报告信息                                   |
| `debug`       | 7    | 编程人员或测试人员使用的调试信息                             |

> 注：基本上，`info`，`notice`，`warn` 这三个讯息都是在告知一些基本信息，应该还不至于造成一些系统运作困扰。

- 优先级（priority）可参照[ syslog 命令手册](https://wenku.baidu.com/view/71b68835ee06eff9aef80777)

###### 连接符号

- `.xx` : 表示大于等于 xx 级别的信息
- `.=xx`：表示等于 xx 级别的信息
- `.!xx`：表示在 xx 之外的等级的信息



可以从上面的文件中看到几项系统配置：

```bash
# kern 的所有优先级信息异步写入 /var/log/kern.log 日志中

kern.*      -/var/log/kern.log
：q
(`- `代表异步写入，也就是说日志写入时不需要等待系统缓存的同步，即日志还在内存中缓存也可以继续写入无需等待完全写入硬盘后再写入。通常用于写入数据比较大时使用)
```

**举例**

通过命令行向日志文件写入信息：

```bash
#首先将syslog启动起来
sudo service rsyslog start

#向 syslog 写入数据
ping 127.0.0.1 | logger -it logger_test -p local3.notice &

#查看是否有数据写入
sudo tail -f /var/log/syslog
```



##### 日志文件的转储

###### logrotate 管理日志文件

在本地的机器中每天都会有成百上千条日志被写入文件中，而服务器中每天更是有数十兆甚至更多的日志信息被写入文件中，那么每天日志文件就会不断的膨胀，就会占用许多的空间，这个时候 `logrotate` 的出现正好就解决了这样一个问题。

`logrotate` 程序是一个日志文件管理工具。用来把旧的日志文件删除，然后创建新的日志文件。可以根据日志文件的大小，也可以根据其天数来切割日志、管理日志，这个过程又叫做“转储”。

大多数 Linux 发行版使用 `logrotate` 或 `newsyslog`对日志进行管理。`logrotate` 程序不但可以压缩日志文件，减少存储空间，还可以将日志发送到指定 `E-mail`，方便管理员及时查看日志。

其中 `logrotate` 是基于 `CRON` 来运行的，脚本是 `/etc/cron.daily/logrotate`；同时配置文件在 `/etc/logrotate.conf` 和 `/etc/logrotate.d` 中找到。

首先，我们一起来看看 `/etc/logrotate.conf` 这个文件中的内容。

```bash
$ cat /etc/logrotate.conf
# see "man logrotate" for details  //可以查看帮助文档
# rotate log files weekly
weekly                             //设置每周转储一次(daily、weekly、monthly当然可以使用这些参数每天、星期，月 )
# keep 4 weeks worth of backlogs
rotate 4                           //最多转储4次
# create new (empty) log files after rotating old ones
create                             //当转储后文件不存在时创建它
# uncomment this if you want your log files compressed
compress                          //通过gzip压缩方式转储（nocompress可以不压缩）
# RPM packages drop log rotation information into this directory
include /etc/logrotate.d           //其他日志文件的转储方式配置文件，包含在该目录下
# no packages own wtmp -- we'll rotate them here
/var/log/wtmp {                    //设置/var/log/wtmp日志文件的转储参数
    monthly                        //每月转储
    create 0664 root utmp          //转储后文件不存在时创建它，文件所有者为root，所属组为utmp，对应的权限为0664
    rotate 1                       //最多转储一次
}
```

###### logrotate 日志转储

logrotate 的配置文件是 `/etc/logrotate.conf`，是一个只读文件，通常不需要对它进行修改。而日志文件的转储设置在独立的配置文件中，放在 `/etc/logrotate.d/`目录下。

我们先通过 `cat` 命令来简单查看一下实验环境中已经配置的一些文件。

```bash
$ ll /etc/logrotate.d/
```

```bash
total 40
drwxr-xr-x  2 root root 4096 Dec 17 14:06 ./
drwxr-xr-x 99 root root 4096 Dec 23 10:35 ../
-rw-r--r--  1 root root  120 Nov  3  2017 alternatives
-rw-r--r--  1 root root  126 Nov 21  2017 apport
-rw-r--r--  1 root root  173 Apr 20  2018 apt
-rw-r--r--  1 root root  112 Nov  3  2017 dpkg
-rw-r--r--  1 root root  146 Jun  6  2018 lxd
-rw-r--r--  1 root root  586 May 29  2019 rsyslog
-rw-r--r--  1 root root  178 Aug 16  2017 ufw
-rw-r--r--  1 root root  235 Jul 18  2018 unattended-upgrades
```

```bash
$ cat /etc/logrotate.d/apt
```

```bash
/var/log/apt/term.log {
  rotate 12
  monthly
  compress
  missingok
  notifempty
}

/var/log/apt/history.log {
  rotate 12
  monthly
  compress
  missingok
  notifempty
}
```

举一个例子来详细说明一下日志是如何进行转储的。

首先创建一个日志文件，然后快速生成文件在其中填入一个 10MB 的随机比特流数据。

```bash
$ sudo touch /var/log/log-file
$ sudo chmod 777 /var/log/log-file
$ sudo head -c 10M /dev/urandom > /var/log/log-file
```

然后，我们为这个文件创建一个配置文件

```bash
$ sudo touch /etc/logrotate.d/log-file
$ sudo vim /etc/logrotate.d/log-file
/var/log/log-file {
    monthly
    rotate 5
    compress
    delaycompress
    missingok
    notifempty
    postrotate
        /usr/bin/killall -HUP rsyslogd
    endscript
}
```

**说明：**

- `monthly` : 日志文件按月转储。可以换成 `daily`，`weekly` 或者 `yearly` 。
- `rotate 5` : 一次转储 最近的 5 个归档日志。
- `compress` : 在转储任务完成后，已转储的日志将使用 `gzip` 进行压缩。
- `delaycompress` : 和 `compress` 选项一起使用，`delaycompress` 表示 `logrotate` 不会将最近的压缩，压缩将在下一次转储周期进行。
- `missingok` : 在日志转储的时候，任何错误将被忽略，例如“文件无法找到”之类的错误。
- `notifempty` : 如果日志文件为空，转储不会进行。
- `create 644 root root` : 以指定的权限创建全新的日志文件，同时 `logrotate` 也会重命名原始日志文件。
- `postrotate/endscript` : 在所有其它指令完成后，`postrotate` 和 `endscript` 里面指定的命令将被执行。`rsyslogd` 进程将立即再次读取其配置并继续运行。

*上面的配置比较的全面，可以当做一个模板，在实际中的配置参数根据你的需求来进行调整。*

例如，当文件满足 10M 就转储一个日志文件。

```bash
$ sudo vim /etc/logrotate.d/log-file
/var/log/log-file{
    su root root
    size=10M
    rotate    5
    create 644 root root 
    postrotate
        /usr/bin/killall   -HUP rsyslogd
    endscript

}
```

在配置文件的开始部分 `su root root` 来指定进行转储的用户，否则会报错：“parent directory has insecure permissions (It's world writable or writable by group which is not "root") Set "su" directive in config file to tell logrotate which user/group should be used for rotation.”。

保存退出后，通过 `logrotate` 命令来调用日志。

**注：编写的配置文件的权限必须为：`-rw-r--r--` ，否则`logrotate` 就无法正常工作。执行时就会提示：`Ignoring mosquitto because of bad filemode`。**

```bash
$ sudo su root
# logrotate -d /etc/logrotate.d/log-file 
```

使用 `-d` 选项是以预演方式运行 `logrotate`。不用实际转储任何日志文件，可以模拟演练日志轮循并显示其输出。