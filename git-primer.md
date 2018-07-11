title: git入门
speaker: speaker
transition: cards

[slide style="background-image:url('/img/bg1.png')"]

# Git入门
<small>by 王宁</small>



[slide style="background-image:url('/img/bg1.png')"  data-transition="slide"]

* **关于版本控制** {:&.bounceIn}
* **Git介绍**
* **Git安装**
* **Git命令**
* **鲨鱼项目Git实践**

[slide style="background-image:url('/img/bg1.png')"  data-transition="slide2"]

## 关于版本控制
----
 {:&.rollIn}

>版本控制是一种记录一个或若干文件内容变化，以便将来查阅特定版本修订情况的系统。

<br>

版本控制系统分为三种： {:.flexbox.vleft}

<br>

* 本地版本控制系统  {:&.flexbox.vleft.rollIn}
* 集中化的版本控制系统
* 分布式版本控制系统

[slide style="background-image:url('/img/bg1.png')"  data-transition="slide3"]
[magic data-transition="cover-circle"]
### 本地版本控制系统 {:&.flexbox.vleft}
----
<br>

>大多都是采用某种简单的数据库或者使用整个文件夹拷贝来记录文件的历次更新差异

====
![](/git-primer/18333fig0101-tn.png)

[/magic]

[slide style="background-image:url('/img/bg1.png')"  data-transition="newspaper"]
[magic data-transition="cover-circle"]
### 集中化的版本控制系统(CVS，Subversion 以及 Perforce) {:&.flexbox.vleft}
----
<br>

>集中化的版本控制系统诸如CVS,Subversion以及Perforce等.

----
>都有一个单一的集中管理的服务器.保存所有文件的修订版本.而协同工作的人们都通过客户端连到这台服务器.取出最新的文件或者提交更新。

====
![](/git-primer/18333fig0102-tn.png)

[/magic]

[slide style="background-image:url('/img/bg1.png')"  data-transition="glue"]
[magic data-transition="cover-circle"]
### 分布式版本控制系统(Git ) {:&.flexbox.vleft}
----
<br>

>分布式版本控制系统诸如Git等.

----
>客户端并不只提取最新版本的文件快照,而是把代码仓库完整地镜像下来.这么一来,任何一处协同工作用的服务器发生故障,事后都可以用任何一个镜像出来的本地仓库恢复,因为每一次的提取操作,实际上都是一次对代码仓库的完整备份

====
![](/git-primer/18333fig0103-tn.png)

[/magic]


[slide style="background-image:url('/img/bg1.png')"  data-transition="vkontext"]  {:.flexbox.vleft}

## Git简介

* Git是一个快速、可扩展的**分布式**版本控制系统  {:&.rollIn}
* Subversion等使用**<span class="text-danger">"增量文件系统"**(存储每次提交之间的差异)
* Git将每次提交的文件的**<span class="yellow3">全部内容</span>**记录下来



[slide style="background-image:url('/img/bg1.png')"  data-transition="circle"]

[magic data-transition="cover-circle"]

## SVN在每个版本中记录着各个文件的具体差异

> 当文件变动发生提交时,增量式文件系统存储的是文件的差异信息.

====
![](/git-primer/20140212173003375.png)
[/magic]


[slide style="background-image:url('/img/bg1.png')"  data-transition="move"]

[magic data-transition="cover-circle"]

## Git保存每次更新时的文件快照

> 当文件变动发生提交时,Git存储的则为文件快照(即整个文件内容),并保存指向快照的索引.考虑到性能因素.如果文件内容没有发生任何变化,该文件系统则不会重复保存文件索引,只是简单地保存上次提交的快照索引.

====

![](/git-primer/20140212173119765.png)

====


<span class="text-warning">Git 之所以选择这样的底层存储数据结构,主要是为了提高 Git 分支的使用效率.实际上,Git 分支本质上是一个指向索引对象的可变指针,而每一个索引对象又指向文件快照</span>


[/magic]




[slide style="background-image:url('/img/bg1.png')"  data-transition="horizontal"]

[magic data-transition="pulse"]

## Git 分支对应的数据结构


====

![](/git-primer/20140212173119766.png)


[/magic]


[slide style="background-image:url('/img/bg1.png')"  data-transition="horizontal3d"]

[magic data-transition="pulse"]

## Git 分布式工作示意图


====

![](/git-primer/20140212173119767.png)


[/magic]

[slide style="background-image:url('/img/bg1.png')"  data-transition="vertical3d"]


## Git仓库模型

* 工作区（Working Directory）  {:&.zoomIn}
* 暂存区（Stage 或 Index）
* 版本库（History，本地仓库和远程仓库）


[slide style="background-image:url('/img/bg1.png')"  data-transition="zoomout"]

![](/git-primer/20140212173119770.png)

[slide style="background-image:url('/img/bg1.png')"  data-transition="zoomin"]

![](/git-primer/fasdfasfa.jpg)


[slide style="background-image:url('/img/bg1.png')"   data-transition="cards"]

[magic data-transition="pulse"]

# Git 安装

====

* **Windows**：[http://www.git-scm.com/download/win](http://www.git-scm.com/download/win "http://www.git-scm.com/download/win")
* **Mac OS X**：[http://www.git-scm.com/download/mac](http://www.git-scm.com/download/mac "http://www.git-scm.com/download/mac")
* **Linux**

| 系统 | 安装命令 |
|:-------|:------:|-------:|
| Debian/Ubuntu | `apt-get install git` |
| Fedora/RedHat/CentOS | `yum install git` |
| Gentoo | `emerge --ask --verbose dev-vcs/git` |
| Arch Linux | `pacman -S git` |
| openSUSE | `zypper install git` |
| FreeBSD | `cd /usr/ports/devel/git && make install` |
| Solaris 11 Express | `pkg install developer/versioning/git` |
| OpenBSD | `pkg_add git` |


=====

设置用户信息：
<pre><code class="shell">$ git config  --global --add user.name 你的名字
$ git config  --global --add user.email youremail@koolearn-inc.com
</code></pre>

[/magic]


[slide style="background-image:url('/img/bg1.png')"   data-transition="circle"]

# Git 命令

[slide style="background-image:url('/img/bg1.png')"   data-transition="pulse"]

## 创建版本库
 {:&.fadeIn}

<pre><code class="shell">$ git init
Initialized empty Git repository in C:/Users/Administrator/Desktop/git/test/.git/
</code></pre>

<br>

>瞬间Git就把仓库建好了，而且告诉你是一个空的仓库（empty Git repository），当前目录下多了一个.git的目录，这个目录是Git来跟踪管理版本库的，没事千万不要手动修改这个目录里面的文件，不然改乱了，就把Git仓库给破坏了。


[slide style="background-image:url('/img/bg1.png')"   data-transition="earthquake"]

## 添加文件
 {:&.bounceIn}

<pre><code class="shell">$ echo "Git is a version control system." > readme.txt
// 输入这句话保存到创建的readme.txt文件中
$ echo " Git is free software." >> readme.txt
// 输入此内容追加到readme.txt中
$ git add readme.txt
</code></pre>

<br>

> 用命令**git add**告诉Git，把文件添加到仓库

[slide style="background-image:url('/img/bg1.png')"   data-transition="pulse"]

## 提交文件
 {:&.bounceIn}

<pre><code class="shell">$ git commit -m "wrote a readme file"
[master (root-commit) cb926e7] wrote a readme file
 1 file changed, 2 insertions(+)
 create mode 100644 readme.txt
</code></pre>

<br>

>` git commit`命令，`-m`后面输入的是本次提交的说明，可以输入任意内容，当然最好是有意义的，这样你就能从历史记录里方便地找到改动记录。

<br>
>`git commit`命令执行成功后会告诉你，1个文件被改动（我们新添加的readme.txt文件），插入了两行内容（readme.txt有两行内容）

[slide style="background-image:url('/img/bg1.png')"   data-transition="horizontal3d"]
  {:&.moveIn}
>为什么Git添加文件需要add，commit一共两步呢？


<pre><code class="shell">$ git add file1.txt
$ git add file2.txt file3.txt
$ git commit -m "add 3 files."
</code></pre>

[slide style="background-image:url('/img/bg1.png')"   data-transition="pulse"]

# 几个常用命令  {:&.flexbox.vleft}

* `git status` {:&.moveIn}
* `git diff`
* `git log`
* `git checkout`
* `git reset`




[slide style="background-image:url('/img/bg1.png')"   data-transition="circle"]

[magic data-transition="pulse"]


# Git 分支

> Git 的分支模型称为“必杀技特性”，而正是因为它，将 Git 从版本控制系统家族里区分出来

=====

![](/git-primer/20120201121725_89.png)



[/magic]

[slide style="background-image:url('/img/bg1.png')"   data-transition="vertical3d"]

# 创建分支  {:&.flexbox.vleft}

<pre><code class="shell">$ git checkout -b dev
Switched to a new branch 'dev'
</code></pre>

`git checkout -b`命令表示创建并切换，相当于以下两条命令：

<pre><code class="shell">$ git branch dev
$ git checkout dev
Switched to branch 'dev'
</code></pre>

用`git branch`命令查看当前分支：

<pre><code class="shell">$ git branch
* dev
  master
</code></pre>


[slide style="background-image:url('/img/bg1.png')"   data-transition="cards"]

# 删除分支  {:&.flexbox.vleft}

<pre><code class="shell">$ git branch -d dev
Deleted branch dev (was 5659891).
</code></pre>


# 合并分支

<pre><code class="shell">$ git merge dev
Updating d17efd8..fec145a
Fast-forward
 readme.txt |    1 +
 1 file changed, 1 insertion(+)
</code></pre>

[slide style="background-image:url('/img/bg1.png')"   data-transition="newspaper"]

* 查看分支：`git branch`
* 创建分支：`git branch <name>`
* 切换分支：`git checkout <name>`
* 创建+切换分支：`git checkout -b <name>`
* 合并某分支到当前分支：`git merge <name>`
* 删除分支：`git branch -d <name>`







[slide style="background-image:url('/img/bg1.png')"   data-transition="pulse"]

# 远程仓库  {:&.flexbox.vleft.moveIn}

>为了能在任意 Git 项目上协作，你需要知道如何管理自己的远程仓库。 远程仓库是指托管在因特网或其他网络中的你的项目的版本库。 你可以有好几个远程仓库，通常有些仓库对你只读，有些则可以读写。 与他人协作涉及管理远程仓库以及根据需要推送或拉取数据。 管理远程仓库包括了解如何添加远程仓库、移除无效的远程仓库、管理不同的远程分支并定义它们是否被跟踪等等。


* [http://git.koolearn-inc.com/](http://git.koolearn-inc.com/)
* [https://github.com/](https://github.com/)


[note]

创建`SSH Key`：
<pre><code class="shell">$ ssh-keygen -t rsa -C "youremail@koolearn-inc.com"
Generating public/private rsa key pair.
Enter file in which to save the key (/c/Users/Administrator/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /c/Users/Administrator/.ssh/id_rsa.
Your public key has been saved in /c/Users/Administrator/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:Dwl3MJadfP3/FWbrawpWIgDBXbV+ii1B0GQEauLfB48 youremail@koolearn-inc.com
The key's randomart image is:
+---[RSA 2048]----+
|    .oooXO.o .   |
|     .oo+++ o .  |
|   . o.....o   . |
|  . o  ooo.    +.|
|   .   .So o oo +|
|    . . +o= =  .o|
|     . E =.=  . o|
|        . o .  o.|
|             .o..|
+----[SHA256]-----+
</code></pre>


验证git服务器中添加的`SSH Key`是否生效：
<pre><code class="shell">$ ssh -T git@git.koolearn-inc.com
Welcome to GitLab, XXX!
</code></pre>


[/note]



[slide style="background-image:url('/img/bg1.png')"   data-transition="horizontal3d"]

# 克隆远程仓库  {:&.flexbox.vleft.moveIn}

<pre><code class="shell">$ git clone git@git.koolearn-inc.com:root/gitlab-test.git
</code></pre>


# 拉取远程仓库代码

<pre><code class="shell">$ git pull origin master
</code></pre>


# 推送代码

<pre><code class="shell">$ git push origin master
</code></pre>



[slide style="background-image:url('/img/bg1.png')"   data-transition="pulse"]

# Git 标签

* 查看标签：`git tag`
* 新增标签：
    * `git tag <name>`
    * `git tag -a <tagname> -m "blablabla..."`
* 删除标签：`git tag -d <name>`
* 向远端推送标签:
    * 推送单个标签: `git push <remotename> <tagname>`
    * 推送所有标签: `git push <remotename> --tags`
* 从远端删除标签: `git push origin :<tagname>`



[slide style="background-image:url('/img/bg1.png')"   data-transition="kontext"]

# Git使用流程及鲨鱼项目实践

[slide style="background-image:url('/img/bg1.png')"   data-transition="kontext"]

* 部署分支(四个)
	* `delelop:对应trunk环境` {:&.bounceIn}
	* `test:对应neibu环境`
	* `release:对应release环境`
	* `master:对应预发和线上环境`

[slide style="background-image:url('/img/bg1.png')"   data-transition="kontext"]

* 开发分支(N个)
	* `future-branch:功能分支` {:&.fadeIn}
	* `local-branch:本地分支`

[slide style="background-image:url('/img/bg1.png')"   data-transition="vertical3d"]

### 谢谢大家。。。
