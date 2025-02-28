---
title: Linux 用户与权限
mathjax: true
date: 2019-11-28 19:17:44
tags:
categories:
---

内容来自[实验楼](https://www.shiyanlou.com/)

用户概念

###### 用户和用户组

- **用户**

  > 因为 Linux 是个`多用户多任务的分时操作系统`，想要调用系统资源必须先向系统管理员申请一个账号，通过用户身份进入系统。用户的账号一方面能帮助系统管理员对使用系统的用户进行跟踪，并控制他们对系统资源的访问；另一方面也能帮助用户组织文件，为用户提供安全性保护。每个账号都拥有一个唯一的用户名和用户密码。用户在登录时键入正确的用户名和密码后，才能进入系统和自己的主目录。

- 用户组

  > 用户组是具有相同特征的用户的逻辑集合。有时需要让多个用户具有相同的权限，比如查看、修改某一个文件的权限，一种方法是逐一对多个用户进行文件访问授权；另一种方法是建立一个组，让这个组具有查看、修改此文件的权限，然后将所有需要访问此文件的用户放入这个组中，那么所有该组用户就具有了和组一样的权限。这就是用户组，将用户分组是 Linux 系统中对用户进行管理及控制访问权限的一种手段，通过定义用户组，在很大程度上简化了管理工作。 

###### 相关配置文件

+ **用户信息文件（/etc/passwd）**

  用户信息是被保存在 `/etc/passwd` 文件中，可以通过 `cat /etc/passwd` 来查看文件的内容：

   <img width="400" src="https://raw.githubusercontent.com/zhanyeye/Figure-bed/win-pic/img/20191128151217.png">

  文件中每行记录用冒号 `:` 分隔为 7 个字段，从左到右具体含义是：

  > 用户名：密码占位符（x 表示用户需要密码登录）：用户标识号（`UID`）：组标识号（`GID`）：注释性描述：主目录：登录的 `shell`

+ **密码文件（/etc/shadow）**

   用户信息文件中的密码信息是被单独保存在 `/etc/shadow` 文件中，文件格式和用户信息类似，通过 `cat /etc/shadow` 命令来查看：

  ```zsh
  $ sudo cat /etc/shadow
  ```

  <img width="400" src="https://raw.githubusercontent.com/zhanyeye/Figure-bed/win-pic/img/20191128151643.png">

  文件中每行记录用冒号 `:` 分隔为 9 个字段，从左到右具体含义是：

  > 用户名：加密口令：最后一次修改时间：密码最短有效天数：密码最长有效天数：密码过期前的警告时间：不活动时间：用户失效时间：暂时保留未使用

  在上面的命令中，我们使用了 `sudo`，因为对于 `/etc/shadow` 文件来说，当前的用户 `shiyanlou` 是没有权限去读取该文件的，所以我们需要使用 `sudo` 工具。

+ 用户组文件（/etc/group）

   Linux 系统对用户组的所有信息被保留在 `/etc/group` 文件中， 同样通过 `cat /etc/group` 命令来查看。 

  文件中每行记录用冒号 `:` 分隔为 4 个字段，从左到右具体含义是：

  > 组名：口令：组标识号（`GID`）：组内用户列表（多用户可用逗号分隔开）

<!--more-->

##### 用户管理

###### 创建用户

添加新的用户账号是通过 `useradd` 命令。此外 `adduser` 命令也可以用于添加用户，掌握前者就已经足够。

**语法**

```
useradd [选项][用户名]
```

选项说明

| 选项 | 说明                                                         |
| ---- | ------------------------------------------------------------ |
| `-c` | comment，指定一段注释性描述                                  |
| `-d` | 目录，指定用户主目录或者说家目录；如果此目录不存在，则同时使用 -m 选项来创建主目录<br /> `sudo useradd -m -d /home/dir username` |
| `-g` | 用户组，指定用户所属的用户组                                 |
| `-G` | 用户组，指定用户所属的附加组                                 |
| `-s` | Shell 文件，指定用户的登录 shell                             |
| `-u` | 用户号，指定用户的用户号，若有 -o 选项，则可以重复使用其它用户的标识号 |

*注意：*

1. shell 指的是用户进入系统命令行界面中默认执行的一个程序，比如打开桌面上的 xfce 终端，默认会进入 zsh shell，绝大部分的 Linux 系统都会使用 bash。创建用户的时候 -s 参数指定的是 shell 的完整的路径，比如 /bin/bash 或者 /bin/zsh。
2. -g 指定用户加入的主用户组，-G 表示创建的用户加入的其它附加用户组，参数可以是组的列表（使用逗号隔开），某个用户所属的主用户组和附加用户组可以使用 `id username` 查询。**一个用户只能属于一个主组**，但可以有很多附加组。主组就是用户登录系统后的默认组，当用户创建一个文件的时候文件的组是当前用户的主组。用户可以在系统中使用 `newgrp` 命令切换到附加组。

eg 1：新建一个用户 `loulou`，并设置某些属性值，然后查看 `/etc/passwd` 中相应的内容：

```bash
# 添加用户，指定 `shell`
$ sudo useradd -s /bin/bash loulou

# 设置密码
$ sudo passwd loulou

# 查看 /etc/passwd 文件最后 10 行
$ sudo tail /etc/passwd

# 查看文件的最后一行
$ sudo tail -1 /etc/passwd
```

 使用 `su` 命令切回到 `shiyanlou` 用户中，也可以使用 `exit` 命令直接退出当前 `shell`。 

 `passwd` 命令，该命令还可用于修改用户的密码，设置用户密码过期等操作，非管理员用户即一般用户只能变更自己的密码。 

eg 1：锁定用户密码和解除密码锁定：

```
$ sudo passwd -l loulou 
$ su loulou
$ sudo passwd -u loulou
$ su loulou
exit
```

<img width="400" src="https://raw.githubusercontent.com/zhanyeye/Figure-bed/win-pic/img/20191128162505.png">

 从输出可以看到当锁定了用户密码时，用户就不能成功认证登陆，只有解除锁定才可以登陆成功。 

eg 2：清除用户密码：

```
$ sudo passwd -S loulou
$ sudo passwd -d loulou
$ sudo passwd -S loulou
```

<img width="400" src="https://raw.githubusercontent.com/zhanyeye/Figure-bed/win-pic/img/20191128162740.png">

 从输出可以看到用户密码的状态从 `P` 变成了 `NP`。 

###### 修改用户

通常情况下，可以通过 `usermod` 来修改已经存在用户信息：

**语法**

```
usermod [选项][用户名]
```

常用选项包括 `-c、-d、-m、-g、-G、-s、-u、-o` 等，选项用法与 `useradd` 相同。

这里额外介绍一个 `-a` 参数，该参数可以给用户添加一个新的附加组。

**举例**

eg 1：使用选项 `-c`，修改用户 `loulou` 的备注信息：

```
$ sudo usermod -c "shiyanlou" loulou
$ tail /etc/passwd
```

###### 删除用户

从系统中删除一个不再使用的用户，可以通过 `userdel` 命令实现。如果一个用户的账号不再使用，删除用户账号就要把 `/etc/passwd` 等系统文件中的该用户记录都删除，必要时还要删除用户的主目录。

**语法**

```
userdel [选项][用户名]
```

选项 `-r` 用于把用户的主目录一起删除。

**举例**

eg 1：先用 `useradd` 新建一个用户 `louplus`，然后再删除：

*因为不会有输出信息，可以通过查看 /etc/passwd 文件来确认。*

```
$ sudo useradd louplus
$ tail -3 /etc/passwd
$ sudo userdel louplus
$ tail -3 /etc/passwd
```

###### 查看用户

在 Linux 终端里，我们先来查看一下 `/etc/passwd` 文件。第三个参数为 `5000` 以上的就是我们后来建立的用户，其它的是系统用户：

```
$ cat /etc/passwd 
```

也可以通过下面这些命令来查看用户的信息。

+ 查看当前用户

  ```bash
  $ w
  ```

  ​	<img width="500" src="https://raw.githubusercontent.com/zhanyeye/Figure-bed/win-pic/img/20191128164533.png">

+ 查看主机上的用户

  ```bash
  $ who
  $ whoami # 查看当前登录的用户
  ```

  ​    <img width="400" src="https://raw.githubusercontent.com/zhanyeye/Figure-bed/win-pic/img/20191128164717.png">

+ 查看登录记录：

  ```bash
  $ lastlog
  ```

  ​    <img width="400" src="https://raw.githubusercontent.com/zhanyeye/Figure-bed/win-pic/img/20191128164837.png">

+  查看用户 ID 和组信息

  ```bash
  $ id 
  ```

     <img width="450" src="https://raw.githubusercontent.com/zhanyeye/Figure-bed/win-pic/img/20191128164942.png">



##### 管理用户组		

其中用户组的增删改实际上就是对 `/etc/group` 文件的处理。 

###### 增加新用户组

增加一个新的用户组调用 `groupadd` 命令。

```bash
groupadd[选项][用户组]
```

选项说明

| 选项 | 说明                                                        |
| ---- | ----------------------------------------------------------- |
| `-g` | 指定新用户组的组标识号（GID），该参数指定的值必须唯一       |
| `-o` | 与 `-g` 同时使用，允许用户组的新 GID 和系统已有用户组的相同 |

eg：创建一个用户组`test`，并且组标识号为 1024，然后查看组信息：

```bash
$ sudo groupadd -g 1024 test 
$ sudo grep test /etc/group  
test:x:1024:
```

>  grep 是一个检索命令 

###### 修改用户组

通常使用 `groupmod` 命令修改用户组的属性。

```
groupmod [选项][用户组]
```

选项说明

| 选项 | 说明                                            |
| ---- | ----------------------------------------------- |
| `-g` | 为用户组指定一个新的组标识号                    |
| `-o` | 与 `-g` 同时使用时，允许将组 GID 更改为非唯一值 |
| `-n` | 将用户组的名字修改为新的名字                    |

eg 1：修改用户组 `test` 的用户组名为 `test1` ：

```
$ sudo groupmod -n test1 test 
```

eg 2：修改用户组 `test1` 的 GID ，并查看用户组信息：

```
$ sudo groupmod -g 1023 test1
$ sudo grep test1 /etc/group  
test1:x:1023:
```

######  删除用户组

使用 `groupdel` 命令把一个用户组从系统中删除。

**语法**

```
groupdel 用户组
```

eg：删除用户组 `test1` ：

```
$ sudo groupdel test1
```

#####  查看用户所属的所有组 

 查看一个用户属于哪些组，可以使用 `groups` 命令，不指定用户时，查看的是当前用户属于哪些组 

##### 用户的禁用和恢复登录

若一个用户在操作过程中存在违法行为或长时间未曾登录，可以对其进行用户的锁定。

禁用：

```
# usermod -L username
# passwd -l username
```

恢复：

```
# usermod -U username
# passwd -u username
```

eg 1：禁止用户 `loulou` 登录， 然后再恢复：

```
$ sudo passwd -l loulou
$ sudo passwd -u loulou
```

**禁用原理**

```bash
$ sudo grep loulou /etc/shadow
$ sudo passwd -l loulou
$ sudo grep loulou /etc/shadow
```

<img width="400" src="https://raw.githubusercontent.com/zhanyeye/Figure-bed/win-pic/img/20191128174601.png">

 码之后，在文件 `/etc/shadow` 中密码仍旧存在，只是在前面多了感叹号 `!` ，这样该用户就无法登录了，因为验证端改变了密码。当然，在解锁之后，密码前面的叹号会被去掉。 