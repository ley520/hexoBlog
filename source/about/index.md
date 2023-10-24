---
title: about
layout: about
date: 2023-02-03 15:51:58

---

## 建站方案

## 框架

[**Hexo**](https://hexo.io/zh-cn/)

````shell
# 创建草稿，部署后不可见
hexo new draft fileName
# 发布草稿文件
hexo publish draft fileName.md

# 创建新的页面,访问方法 http://host:port/fileName
hexo new page fileName

# 编辑文章
在---、---中间编辑文章基本信息
---
title: 标题
date	建立日期	文件建立日期
updated	更新日期 文件更新日期
comments	开启文章的评论功能	默认true
# 分类
categories:
# 为文章添加多个分类，可以尝试以下 list 中的方法
- [Diary, PlayStation]
- [Diary, Games]
- [Life]
# PlayStation 和 Games 分别都是父分类 Diary 的子分类，同时 Life 是一个没有子分类的分类
# 标签
tags:
- PS3
- Games
---

hexo clean #清除缓存文件

hexo g -d #hexo生成静态文件并自动部署，后面两个命令作用相同 hexo generate --deploy    hexo deploy --generate
hexo s # 启动服务 hexo server -p 5000 指定端口

#内置了start.sh文件，用来清除、编译并重新启动服务
#给start.sh文件可执行权限
chmod 755 start.sh
# 后续直接执行即可
./start.sh
````

## 服务器

[**Github Pages**](https://pages.github.com/)

## 主题

[**Fluid**](https://hexo.fluid-dev.com/docs/start/#%E6%8C%87%E5%AE%9A%E4%B8%BB%E9%A2%98)







