---
title: git和Github入门实践
date: 2019-07-21 08:37:15
tags:
- git
---

#### 常用操作

##### 设置git使用socks5代理

```shell
git config --global http.proxy socks5://127.0.0.1:1080
git config --global https.proxy socks5://127.0.0.1:1080

# 取消代理
git config --global --unset http.proxy
git config --global --unset https.proxy

# 只对github进行代理
git config --global http.https://github.com.proxy socks5://127.0.0.1:1080
git config --global https.https://github.com.proxy socks5://127.0.0.1:1080

```





#### Git 与 GitHub 简介

当我们在 GitHub 上创建一个仓库时，同时生成了仓库的默认主机名 origin，并创建了默认分支 master。GitHub 可以看成是免费的 Git 服务器，在 GitHub 上创建仓库，会自动生成一个仓库地址，主机就是指代这个仓库，主机名就等于这个仓库地址。克隆一个 GitHub 仓库（也叫远程仓库）到本地，本地仓库则会自动关联到这个远程仓库，执行 `git remote -v` 命令可以查看本地仓库所关联的远程仓库信息

Git 要求对本地仓库关联的每个远程主机都必须指定一个主机名（默认为 origin），用于本地仓库识别自己关联的主机，`git remote` 命令就用于管理本地仓库所关联的主机，一个本地仓库可以关联任意多个主机（即远程仓库）。

<!--more-->

#### Git 基础操作

![](https://raw.githubusercontent.com/zhanyeye/Figure-bed/deepin-pic/imgwm)

##### 一次修改提交推送操作

`git add [文件名]` 添加到暂存区，以备提交

`git add .` 命令全部添加到暂存区

`git reset -- [文件名]` 或者 `git rm --cached [文件名]`  撤销暂存区的修改

`git reset --` 即可把暂存区的全部修改撤销

 `git diff`，它可以用来查看工作区**被跟踪的文件**的修改详情，注意，只有在版本区中存在的文件才是被跟踪文件。

`git commit` 命令生成一个新的提交，一个必须的选项 `-m` 用来提供该提交的备注

`git branch -avv`，它用来查看全部分支信息

`git push`，后面不需要任何选项和参数，此命令会把本地仓库 当前 分支上的新增提交推送到远程仓库的同名分支上

查看提交历史

  `git log`

关于查看提交历史记录的命令，有些常用的选项介绍一下：

- `git log [分支名]` 查看某分支的提交历史，不写分支名查看当前所在分支
- `git log --oneline` 一行显示提交历史
- `git log -n` 其中 n 是数字，查看最近 n 个提交
- `git log --author [贡献者名字]` 查看指定贡献者的提交记录
- `git log --graph` 图示法显示提交历史

##### 配置个人信息

接下来需要对 Git 进行一些本地配置：

- `user.email`：写入你自己注册 GitHub 账号的邮箱
- `user.name`：你自己的 GitHub 账号名字

`git config -l`可以查看配置信息

统自动生成 Git 的配置文件，就是家目录中的隐藏文件 `.gitconfig` 

##### 版本回退

`git reset --soft HEAD^` 撤销最近的一次提交，将修改还原到暂存区。

+ `--soft` 表示软退回，
+ `HEAD^` 表示撤销一次提交，`HEAD^^` 表示撤销两次提交，撤销 n 次可以简写为 `HEAD~n`。

##### 处理commit时间线分叉

![](https://raw.githubusercontent.com/zhanyeye/Figure-bed/deepin-pic/imgDeepinScreenshot_select-area_20190720160004.png)

![](https://raw.githubusercontent.com/zhanyeye/Figure-bed/deepin-pic/imgDeepinScreenshot_select-area_20190720160949.png)

提交时间线分叉。因为提交操作不是基于远程仓库 origin/master 分支的最新提交版本，而是撤回了一个版本。这种情况下也是可以将本地 master 分支推送到远程仓库的，需要加一个选项 `-f` ，它是 `--force` 的简写，这就是强制推送

##### 本地仓库 commit 变化记录

`git reflog` 命令，它会记录本地仓库所有分支的每一次版本变化。实际上只要本地仓库不被删除，随你怎么折腾，都能回退到任何地方。`reflog` 记录只存在于本地仓库中，本地仓库删除后，记录消失。

`git reset --hard [版本号]`  回退到制定版本

如果记不清版本号，也可以根据`git reflog`的信息，执行 `git reset --hard HEAD@{?}` 命令

![](https://raw.githubusercontent.com/zhanyeye/Figure-bed/deepin-pic/imgDeepinScreenshot_select-area_20190720161438.png)



#### Git 分支操作

##### 添加 SSH 关联授权

若想避免手动输入用户名和密码的麻烦，可以在系统中创建 SSH 公私钥，并将公钥放到 GitHub 指定位置。如此操作即可生成 GitHub 账户对于当前系统中的 Git 授权。

终端执行 `ssh-keygen` 命令按几次回车生成公私钥，公私钥存放在家目录下的隐藏目录 `.ssh` 中的两个文件中

将 `~/.ssh/id_rsa.pub` 文件中的公钥内容复制出来

然后在 GitHub 网页上添加公钥：

**重要的一点：只有使用这种 git 开头的地址克隆仓库，SSH 关联才会起作用。**

使用 SSH 的好处主要有两点：

- 免密码推送，执行 `git push` 时不再需要输入用户名和密码了；
- 提高数据传输速度。



##### 为 Git 命令设置别名

 有些命令的重复度极高，比如 `git status` 和 `git branch -avv` 等，Git 可以对这些命令设置别名，以便简化对它们的使用，设置别名的命令是 `git config --global alias.[别名] [原命令]`，如果原命令中有选项，需要加引号。别名是自定义的，可以随意命名，设置后，原命令和别名具有同等作用。

自己设置的别名要记住，也可以使用 `git config -l` 命令查看配置文件。下面文档中的命令将使用这些别名。

##### Git 分支管理

###### git fetch 刷新本地分支信息

`git fetch`，它的作用是将远程仓库的分支信息拉取到本地仓库

注意，仅仅是更新了本地的远程分支信息，也就是执行 `git branch -avv` 命令时，查看到的 `remotes` 开头的行的分支信息

`fetch` 命令的作用是刷新保存在本地仓库的远程分支信息，此命令需要联网

此时若想使本地 master 分支的提交版本为最新，可以执行 `git pull` 命令来拉取远程分支到本地，`pull` 是拉取远程仓库的数据到本地，需要联网，而由于前面执行过 `git fetch` 命令，所以也可以执行 `git rebase origin/master` 命令来实现 “使本地 master 分支基于远程仓库的 master 分支”，`rebase` 命令在后面还会经常用到

###### 创建新的本地分支

 `git branch [分支名]` 可以创建新的分支

此命令创建新分支后并未切换到新分支，还是在 master 分支上，执行 `git checkout [分支名]`切换分支，`checkout` 也是常用命令

创建新分支后并未切换到新分支，还是在 master 分支上，执行 `git checkout [分支名]`切换分支

`git checkout -b [分支名]` 创建分支并切换到新分支

###### 将新分支中的提交推送至远程仓库

执行 `git push [主机名] [本地分支名]:[远程分支名]` 即可将本地分支推送到远程仓库的分支中，通常冒号前后的分支名是相同的，如果是相同的，可以省略 `:[远程分支名]`，如果远程分支不存在，会自动创建

###### 本地分支跟踪远程分支

 `git branch -u [主机名/远程分支名] [本地分支名]` 将本地分支与远程分支关联，或者说使本地分支跟踪远程分支。
+ 如果是设置当前所在分支跟踪远程分支，最后一个参数本地分支名可以省略不写
+ `-u` 选项是 `--set-upstream` 的缩写

`git branch --unset-upstream [分支名]` 即可撤销该分支对远程分支的跟踪，

+ 同样地，如果撤销当前所在的分支的跟踪，分支名可以省略不写

问题又来了，前面的操作是先将本地分支推送到远程仓库，使远程仓库创建新分支，然后再执行命令使本地分支跟踪远程分支，有没有办法在推送时就自动跟踪远程分支呢？有的，在推送的时候，加个 `--set-upstream` 或其简写 `-u` 选项即可，现在切换到 dev 分支试一下这个命令

###### 删除远程分支

1. 删除远程分支，使用 `git push [主机名] :[远程分支名]` ，如果一次性删除多个，可以这样：`git push [主机名] :[远程分支名] :[远程分支名] :[远程分支名]` 。此命令的原理是将空分支推送到远程分支，结果自然就是远程分支被
2. `git push [主机名] --delete [远程分支名]`

###### 本地分支的更名与删除

`git branch -D [分支名]` 删除本地分支

+ 此命令也可以一次删除多个，将需要删除的分支名罗列在命令后面即可
+ 当前所在的分支不能被删除

`git branch -m [原分支名] [新分支名]` 给本地分支改名

+ 若修改当前所在分支的名字，原分支名可以省略不写

#### 多人协助Git部分

同步主仓库

 因为组长的 master 分支新增了一个提交，所以需要让组员的仓库同步组长的仓库，使它们的提交版本一致。作为组员，要时刻保持自己的 master 分支与组长的一致，以避免在下次提 PR 时出现冲突，该操作叫做 “同步主仓库”，组长的仓库就是主仓库。

提 PR、合并 PR 只能在 GitHub 页面上操作。同步主仓库是要用 Git 操作的

首先，使用 `remote` 系列命令来增加一个关联主机，执行 `git remote add [主机名] [主仓库的地址]`，注意，主仓库的地址使用 https 开头的

主机名是随意定义的，只要不是 origin 就可以，因为自己的仓库地址对应的主机名是 origin，主仓库的主机名通常定义为 up 或 upstream，这个主机名其实就是一个变量，它的值就是仓库地址，例如 `git push origin master` 完全等于 `git push git@github.com:Manchangdx/work master` 。

关联主仓库后也没什么变化嘛，确实如此，即使地址写错也不会报出来。现在可以使用前面课程介绍过的 `fetch` 命令来拉取主仓库的全部分支信息到本地仓库了，我有时使用这个命令看上一个命令是否有拼写错误

如何同步主仓库哩？方法有二:

1. 是执行 `git pull --rebase up master` ，此命令需联网
2. 是执行 `git rebase up/stream`，此命令不联网，因为前面已经执行了 `git fetch up` 这个需要联网的命令，本地已经有了最新的主仓库 master 分支信息，所以可以这么操作。

总结一下：`git pull --rebase` = `git fetch` + `git rebase`。现在使用方法二来同步：

#### Git tag

> 在一个项目中，我们可能需要阶段性地发布一个版本，比如 `V1.0`、`V1.0.2`、`V3.2 Beta` 之类的，Git 的标签可以满足这个需求。在一个长期大型项目中，可能会有数千个提交版本，我们可能需要对重要的节点性提交打个记号，这时也可以使用 Git 的标签功能。在一些项目相关的书籍中，我们会看到 “执行 xxx 命令签出这个版本以查看对应的代码” ，这也是使用 Git 的标签功能做到的。



----------///下面的估计段时间见内不会接触,暂且不总结

##### 创建标签

##### 查看标签

##### 删除本地标签

##### 将本地标签推送到远程仓库

##### 删除远程仓库标签

##### 签出版本

 

 

 

 