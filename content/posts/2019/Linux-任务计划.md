---
title: Linux 任务计划
mathjax: true
date: 2019-12-07 08:41:05
tags:
categories:
---

内容来自[实验楼](https://www.shiyanlou.com/)

我们经常会需要安排脚本在某个时间或每隔一段时间来运行，如周期性的清理一下／tmp，周期性的去备份一次数据库，周期性的分析日志等等。而且有时候因为某些因素的限制，执行该任务的时间会很尴尬。Linux 调度通过 crontab 与 at 这两个工具。

- at：处理仅执行一次就结束调度的指令。这次做完以后就没有。
- crontab：周期性需要执行的任务。

<!--more-->

##### at

设置 at 命令很简单，只是运行的时间，就会在那个时候运行。类似于打印进程，会把任务放到 `/var/spool/at` 目录中，到指定时间运行它。

`/etc/at.allow`和 `/etc/at.deny` 管理使用限制，写在 `/etc/at.allow` 中的用户才能使用 at，写在 `/etc/at.deny` 中的用户不能使用 at。若这两个文件不存在，则只有 root 用户可以使用 at。

###### at 准备

使用单一工作调度，首先应启动 atd 服务。实验环境默认没有此服务，需要安装并启动

```bash
# 更新软件包列表
sudo apt-get update
#安装
sudo apt-get install at
#启动atd
sudo service atd start
```

> service 是 Linux 中非常常用的命令，用户启动已安装的服务，其主要是读取 `/etc/init.d` 中的脚本，并执行相关的脚本，通过参数来控制相关服务的状态，如启动、关闭，重启等等。

关于一些 service 常用的操作有：

- start //启动服务
- stop //关闭服务
- restart //重启服务
- reload //重新载入配置
- status //查看服务状态

###### at 使用

```
at (选项) （参数）
```

选项：

| 选项 | 意思                          |
| ---- | ----------------------------- |
| `-f` | 指定包含具体指令的任务文件    |
| `-q` | 指定新任务的队列名称          |
| `-l` | 显示待执行任务的列表          |
| `-d` | 删除指定的待执行任务          |
| `-m` | 任务执行完成后向用户发送email |

参数：

参数为日期时间，格式如下：

1. 绝对计时

   （1）midnight（深夜），noon（中午），teatime（饮茶时间，一般是下午4点）

   （2）hh:mm today , hh:mm tomorrow 。例如：`14:30 today` 今天下午两点半，`14:30 tomorrow` 明天下午两点半

   （3）12小时制 ，时间后面加am（上午），pm（下午）。例如：`2:30 am` 上午两点半，`2:30 pm` 下午两点半

   （4）日期的表示的方式有：月日或者 mm/dd/yy（月/日/年）或者 dd.mm.yy（日.月.年）或者 yy-dd-mm（年-月-日）。例如 `14:30 17.10.25` 或者 `14:30 25.10.17` 或者 `14:30 2017/10/25`（2017 年 10 月 25 日下午两点半）

2. 相对计时

   `at now + 时间数量 时间单位`。时间单位可以是 minutes（分钟），hours（小时），days（天），weeks（星期）。例如 `at now + 3 minutes`（3 分钟后）

#### 2.3.2 at 的应用

下面我们开始进入到实践环节：

（1）两分钟后写 hello shiyanlou 到 my.txt 中

首先

```bash
$ at now + 2 minutes
```

然后按 `enter` 键，输入以下

```bash
at> echo "hello shiyanlou" > my.txt

at> <EOT> //这里按ctrl + D 自动出现<EOT>

job 1 at Wed Oct 25 18:01:00 2017
```

上面的最后一句意为第一个 at 工作将在 2017 年 10 月 25 日星期三的 18:01:00 运行

可以使用 `atq` 或者 `at -l`查看

```bash
$ atq
1    Wed Oct 25 18:18:00 2017 a shiyanlou
```

> atq 如果没查到，那是因为过了两分钟了，该任务已经执行了。

（2）在今天 18:28 输出时间到 time.log 中

```bash
$ at 18:28 today                                     
at> date > time.log
at> <EOT>
job 2 at Wed Oct 25 18:28:00 2017
#可以使用如下命令将第2项工作内容列出来
$ at -c 2
```

（3）在固定时间添加一个用户

```bash
$ at 06:39pm                                            
at> sudo useradd aaa
at> <EOT>
job 3 at Wed Oct 25 18:36:00 2017
```

可以看到最后有个aaa的用户

（4）在2017年10月26日 18:00关机

```bash
$ at 18:00 2017-10-26                                   
at> sudo /bin/sync
at> sudo /bin/sync
at> sudo /sbin/shutdown -h now
at> <EOT>
job 5 at Thu Oct 26 18:00:00 2017
```

要是发现写错了，想删除怎么办，可以使用 `atrm` 命令，该命令的作用是删除待执行的任务队列中的指定任务。

其命令的格式是： `atrm 任务号`

##### crontab

这个工具非常有用，例如我们需要在半夜执行数据库的 patch 脚本，例如我们需要半夜升级我们的站点，有了 crontable 我们就不需要半夜起来执行脚本，亦或者是因为睡过头而错过该执行的任务。

和 at 相似，使用限制的配置文件在 `/etc/cron.allow` 和 `/etc/cron.deny` 中。当使用者使用 crontab 后，该项工作会被记录到`/var/spool/cron/` 里。不同用户执行的任务记录在不同用户的文件中。

通过 crontab 命令，我们可以在固定的间隔时间或指定时间执行指定的系统指令或脚本。时间间隔的单位可以是分钟、小时、日、月、周的任意组合。

这里我们看一看crontab 的格式

```bash
# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * command to be executed
```

其中特殊字符的意义：

| 特殊字符 | 意义                                                         |
| -------- | ------------------------------------------------------------ |
| *        | 任何时刻                                                     |
| ,        | 分隔时段，例如`0 7,9 * * * command`代表7:00和9:00            |
| -        | 时间范围，例如`30 7-9 * * * command` 代表7点到9点之间每小时的30分 |
| /n       | 每隔n单位间隔，例如`*/10 * * * *` 每10分钟                   |

###### crontab 准备

+ 基本语法

  ```bash
  crontab [-u username] [-l|-e|-r]
  ```

  其常用的参数有：

  | 选项 | 意思                                                         |
  | ---- | ------------------------------------------------------------ |
  | `-u` | 只有root才能进行这个任务，帮其他使用者创建/移除crontab工作调度 |
  | `-e` | 编辑crontab工作内容                                          |
  | `-l` | 列出crontab工作内容                                          |
  | `-r` | 移除所有的crontab工作内容                                    |

+ crontab 的应用

  添加一个计划任务

  ```bash
  crontab -e
  ```

  第一次启动会是让我们选择编辑的工具，选择第一个基本的 vim 就可以了

  在文档的最后一行加上这样一行命令，该命令的意思是每分钟我们会在 /home/shiyanlou 目录下创建一个以当前的年月日时分秒为名字的空白文件

  ```bash
  */1 * * * * touch /home/shiyanlou/$(date +\%Y\%m\%d\%H\%M\%S)
  ```

  > **注意**
  >
  > “ % ” 在 crontab 文件中，有结束命令行、换行、重定向的作用，前面加 ” \ ” 符号转义，否则，“ % ” 符号将执行其结束命令行或者换行的作用，并且其后的内容会被做为标准输入发送给前面的命令。

  添加成功后我们会得到 installing new crontab 的一个提示.

  为了确保我们任务添加的正确与否，我们会查看添加的任务详情：

  ```
  crontab -l
  ```

  虽然我们添加了任务，但是如果 cron 的守护进程并没有启动，当然也就不会帮我们执行，我们可以通过以下 2 种方式来确定我们的 cron 是否成功的在后台启动，若是没有则需要启动一次。

  ```bash
  ps aux | grep cron
  
  #或者使用下面
  
  pgrep cron
  ```

  > ps 的相关命令会在后续详细讲解，这里主要是为了查看 crontab 的后台程序是否正确执行。

  同样我们通过这样一个命令可以查看到执行任务命令之后在日志中的信息反馈：

  ```bash
  sudo tail -f /var/log/syslog
  ```

  从中我们同样可以验证所添加的任务又被执行，可以按`ctrl + c` 可以退出当前的状态。

  当我们并不需要某个任务的时候我们可以通过 `-e` 参数去配置文件中删除相关命令，若是我们需要清除所有的计划任务，我们可以使用这么一个命令去删除任务：

  ```bash
  crontab -r
  ```

+ 练习

  下面将通过一下例子来巩固大家对 crontab 的学习：

  （1）每天中每小时的第5分钟执行脚本 test.sh

  首先在 /home/shiyanlou 下创建 test.sh 脚本

  ```bash
  vim test.sh
  ```

  并在其中输入以下内容：

  ```bash
  #!/bin/bash
  touch /home/shiyanlou/$RANDOM
  ```

  按 `esc` 然后输入 `:wq` 保存退出，完成脚本的编辑。

  紧接着添加一个计划任务：

  ```bash
  crontab -e
  ```

  输入以下内容：

  ```bash
  05 * * * * /home/shiyanlou/test.sh
  ```

  （2）每天的凌晨的 3、4、5 点执行 test.sh

  ```bash
  00 3,4,5 * * * /home/shiyanlou/test.sh
  ```

  （3）周日每隔 3 小时执行 test.sh

  ```bash
  00 */3 * * 0 /home/shiyanlou/test.sh
  ```

  （4）每天的下午 7 点关闭计算机

  ```bash
  00 19 * * * /sbin/shutdown -h
  ```

###### crontab 的深入

每个用户使用 `crontab -e` 添加计划任务，都会在 `/var/spool/cron/crontabs`中添加一个该用户自己的任务文档，这样目的是为了隔离。

如果是系统级别的定时任务，应该如何处理？只需要以 sudo 权限编辑 `/etc/crontab` 文件就可以。

cron 服务监测时间最小单位是分钟，所以 cron 会每分钟去读取一次 /etc/crontab 与 /var/spool/cron/crontabs 里面的內容。

在 /etc 目录下，cron 相关的目录有下面几个：

1. /etc/cron.daily，目录下的脚本会每天执行一次，在每天的6点25分时运行；
2. /etc/cron.hourly，目录下的脚本会每个小时执行一次，在每小时的17分钟时运行；
3. /etc/cron.monthly，目录下的脚本会每月执行一次，在每月1号的6点52分时运行；
4. /etc/cron.weekly，目录下的脚本会每周执行一次，在每周第七天的6点47分时运行；

系统默认执行时间可以根据需求进行修改。