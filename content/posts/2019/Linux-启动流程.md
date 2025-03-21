---
title: Linux 启动流程
mathjax: true
date: 2019-12-07 13:50:24
tags:
categories:
---

内容来自[实验楼](https://www.shiyanlou.com/)

###### 启动顺序

Linux 启动过程主要包括以下 4 个步骤：

 <img width="400" src="https://raw.githubusercontent.com/zhanyeye/Figure-bed/win-pic/img/20191207135229.png">

**1.BIOS 自检**：计算机加电后，系统将自动读取 BIOS 中的硬件信息（如：显卡、内存、主板、CPU 等）。然后查找启动设备并设置优先级。接着系统开始自检（`POST，power on selftest`），若有问题会给出提示信息，没有问题就启动执行硬件初始化，并设置 `PnP （Plug-and-Play，即插即用）`设备。最后启动驻留在硬盘主引导记录 `MBR (MasterBoot Record`，主引导分区)中的引导程序 GRUB 或 lilo。

**2.GRUB/lilo 引导启动程序**：用户通过 `GRUB 或 lilo` 引导加载程序启动 Linux 系统。引导程序只是将控制权交给内核，此时操作系统并未装入内存。其中，ubuntu 默认 GRUB 为引导加载程序。

**3.装载 Linux 内核**：最初的引导过程完成后，引导程序开始加载 Linux 内核。ubuntu 的 Linux 内核在 `/boot` 目录下。

**4.系统初始化**：Ubuntu 采用的是基于事件的启动管理器 —— `Upstart`，主要包括 3 个程序（`init`、`telinit`、`runlevel`）和相应配置文件目录（`/etc/init`、`/etc/rcN.d`、`/etc/init.d`）组成。系统内核首先会启动 init 进程，读取并运行 `/etc/init` 目录下的启动配置文件，init 启动任务时会读取默认的运行等级（runlevel），然后将结果传递给 upstart 的下一个组件 telinit 中。telinit 通过比较当前 runlevel 与将要进入的 runlevel 之间运行服务的不同，关闭不需要的服务项，启动目前未运行的服务，从而实现系统状态的转换。

初始化阶段完成后，系统就可以准备接受用户登录。

> **bios** ：接管主板所有自检工作，掌握系统的启动，部件之间的兼容和程序管理等多项任务。连接软件与硬件设备的“桥梁”。

> **boot loader** ：grub 实际上是一个 boot loader，开机管理程序可以指定使用哪个核心文件来开机，并实际载入核心（kernel）到内存当中解压缩与执行， 此时核心就能够开始在内存内活动，并侦测所有硬件信息与载入适当的驱动程序来使整部主机开始运行。

> **init 进程**：系统开始的第一个工作，它是其他所有进程的父进程，一直处在运行状态，并且进程 id 号永远是第一个。作用是读取初始化脚本，完成系统相关管理任务。

<!--more-->

###### 运行级别

Linux 系统的运行级别由 init 启动的，可以通过 `ps -ax` 命令查看到 `PID=1` 是 `init` 进程

init 是 Linux 内核启动的用户级别进程。ubuntu 的默认运行级别文件是 `/etc/init/rc-sysinit.conf` 。

在 `/etc/rc$.d` 目录中定义了各种运行级别的运行服务

```bash
cd /etc
ls | grep rc
```

我们来查看一下定义为 `2` 级别的服务

 <img width="500" src="https://raw.githubusercontent.com/zhanyeye/Figure-bed/win-pic/img/20191207140243.png">

> 上面的 rc.local 可以写入任何想要开机时就进行的工作，在启动的最后阶段，系统会执行存于 rc.local 中的命令。

> 目录里面的服务以 K 开头的是系统将终止对应的服务，以 S 开头的是系统将启动对应的服务。

> S 或者 K 后面跟的数字是程序优先级，数值越小，优先级越高。数字后面的是服务的名称。

可以看到有这几个运行级别：

| 级别                                              | 功能                                                         |
| ------------------------------------------------- | ------------------------------------------------------------ |
| 0                                                 | 关闭系统                                                     |
| 1                                                 | 让系统进入单用户（S，恢复）模式                              |
| 2/3/4/5                                           | 多用户模式，图形登陆界面，运行所有预定的系统服务。对于系统定制而言，运行级别2-5的作用相同。 |
| 6                                                 | 重启系统                                                     |
| S                                                 | 单用户与（恢复）模式， 文本登录界面，只运行很少几项系统服务  |
| **默认情况下，ubuntu 系统引导进入运行级别 `2`。** |                                                              |

查看 `/etc/init/rc-sysinit.conf` 的内容

![实验楼](https://dn-simplecloud.shiyanlou.com/87971509432754859-wm)

可以看到 `default runlevel = 2` ，即默认运行级别为 `2`。

###### 添加和移除自启动程序

1. 在 rc.local 脚本中设置

   `/rc.local` 脚本是 ubuntu 开机之后就会自动执行的一个脚本，位于 `/etc` 路径下。

   可以通过 `root` 权限对这个脚本进行内容修改添加命令执行等。

   ```bash
   sudo vim /etc/rc.local 
   ```

2. 自定义脚本文件

   除了使用 `rc.local` 脚本来自启动开机项，还可以新建一个脚本文件 `new.sh` 来添加开机自启动项。

   首先，新建一个脚本：

   ```bash
   vim new.sh
   ```

   然后设置脚本权限：

   ```bash
   sudo chmod +x new.sh 
   ```

   移动脚本到启动目录下：

   ```bash
   sudo mv new.sh /etc/init.d/new_service.sh
   ```

   将自定义脚本添加至启动项中：

   ```bash
   cd /etc/init.d/
   sudo update-rc.d new_service.sh defaults 95
   ```

   其中，数值 95 表示一个优先级，越小表示执行的越早，可以按照自己的需要相应修改即可。

   > 由于实验楼环境的权限问题，不能验证该脚本的启动过程。

3. 使用 sysv-rc-conf 工具

   ```bash
   sudo apt-get install sysv-rc-conf
   ```

   验证使用工具

   ```bash
   sudo su
   sysv-rc-conf
   ```

   用鼠标点击或者用键盘方向键定位，用空格键设置，`X` 表示开启该服务，`q` 退出。

###### 设置mysql自启的例子

第一种：使用 `update-rc.d` 命令

```bash
sudo update-rc.d mysql defaults
```

启动之后，通过 `ll` 命令来查看下 mysql 的相关运行信息。

```bash
ll /etc/rc?.d/*mysql
```

 <img width="600" src="https://raw.githubusercontent.com/zhanyeye/Figure-bed/win-pic/img/20191207143217.png">

> 可以看到 mysql 在运行级别为 2，3，4，5 上以优先级 20 启动，在运行级别 0，6 上关闭。

移除自启动的方法如下：

```bash
sudo update-rc.d -f mysql remove
```

 <img width="600" src="https://raw.githubusercontent.com/zhanyeye/Figure-bed/win-pic/img/20191207143349.png">

如果我们想设置某些运行级别是启动的，某些运行级别是不启动的，应该怎么设置呢？

现在假设我们设置优先级为 50 的是在 `2，3，4` 上启动，优先级为 51 的在 `0，1，5，6` 上不启动。

```bash
sudo update-rc.d mysql start 50 2 3 4 . stop 51 0 1 5 6 . 
```

<img width="600" src="https://raw.githubusercontent.com/zhanyeye/Figure-bed/win-pic/img/20191207143715.png">

可以看到已经发生了改变。



第二种使用 `sysv-rc-conf` 工具