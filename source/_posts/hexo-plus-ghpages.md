---
title: Hexo + Github Pages = 你的博客
date: 2016-04-13 23:28:37
tags:
  - hexo
  - github pages
  - ghpages
  - tutorial
---


### 曾经的故事
最近又想搞搞博客了，之前使用过 `Hexo`，印象不错，但是唯一有一个问题就是我当时是使用`hexo d`来把`hexo g`生成的`public`目录下的内容放到github 上的，后来因为换电脑等等原因，源文件已经找不到了。

### 有时候也很笨
因此，觉得这个东西不好用，`hexo d`只是部署生成的表态文件到 github，而不会把源文件也放到 github，这样如果我换电脑或者使用其它电脑时就很不方便，我还得再建一个 repo 去维护这个东西，所以决定尝试一下`jekyll`

### 为什么放弃`jekyll`
首先我得说下我对静态博客工具的态度：

- 不要很难上手，因为我不想在这上面花太多功夫
- 可以与github pages集成
- 支持主题，并且主题要很容易切换 （虽然博客的重点是内容而非表面，但是人都有爱美之心，并且容易喜新厌旧）

我想`jekyll`与 github pages 是天然集成的，并且它还有无数非常美丽的主题，但是，它的主题切换就不像`hexo`那么的方便了，当然有可能是我没有搞清楚，但是， anyway，我不想在这上面花太多功夫，所以，决定回归`hexo`.


### 如何重回 `hexo`

#### versoin control你的源代码
对于上面我说的`hexo`的源代码如何保存的问题，我现在的做法是这样的
建立一个新的分支`blog/hexo`， 这里面就放着从`hexo init`到后面各种修改的内容，但是下面这几个文件我觉得是没有必要提交的，所以，可以把它们加到`.gitignore`文件中

```text
.deploy_git/
node_modules/
public/
themes/
db.json
```
这里特别要注意的是`themes`，因为这下面放了你下载的主题，你是很有可能对这些主题进行自定义配置的，所以我的想法是创建一个相对应主题的配置文件，然后把`themes/bla-theme/bla.file` 链接到你新建的配置文件。（当然了，我还没来得及弄）

#### 部署你的网站
`hexo`提供了`hexo-deployer-git`可以让你只用一句命令`hexo d`就可以将你的网站部署到 github pages 上, 具体请看[官方文档](https://hexo.io/docs/deployment.html)

在使用这个工具之前，你需要确保

1. 你已经配置了你的 git repo 信息到`_config.yml`中，示例如下：
```yaml
deploy:
  type: git
  repo: git@github.com:kevinjom/kevinjom.github.io.git
  branch: master
```
2. 先执行`hexo g`

当然了，如果嫌麻烦，你可以写一个简单的脚本。下面是一个例子

```bash
#!/bin/bash

set -e

PROG=$(basename $0)

usage() {
  echo "$PROG <commit message>"
  exit 1
}

[[ -n $1 ]] || usage

git stash
git pull origin blog/hexo --rebase
git stash pop || echo "no stash to pop"
git add .
git commit -m "$1"

hexo g
hexo d

```

### 自定义域名过期了怎么办
如果曾经配置过`CNAME`，但是域名过期了，又没有新域名使用，你想使用`bla.github.io`来访问，但你会发现 github还是会跳转至你曾经的域名，解决办法是将 `CNAME`的内容更新为`bla.github.io`

