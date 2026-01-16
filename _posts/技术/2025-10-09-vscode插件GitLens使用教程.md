---
layout: post
author: abining
title: vscode插件GitLens使用教程
header-style: text
date: 2025-10-09 00:00:00
catalog: true
tags:
  - vscode
  - 工具
---

# GitLens 使用教程

## 目录

1. [GitLens 简介](#gitlens-简介)
2. [安装与配置](#安装与配置)
3. [Commit Graph 功能详解](#commit-graph-功能详解)
4. [搜索功能使用指南](#搜索功能使用指南)
5. [实用技巧](#实用技巧)
6. [参考资源](#参考资源)

## GitLens 简介

GitLens 是 Visual Studio Code 的一款强大插件，能够增强 Git 的功能，帮助开发者更深入地理解代码库的历史和上下文。它提供了丰富的可视化界面和强大的搜索功能，让代码版本管理变得更加直观和高效。

## 安装与配置

### 安装步骤

1. 打开 VSCode，点击左侧的扩展图标（或使用快捷键 `Ctrl+Shift+X`）
2. 在搜索框中输入"GitLens"
3. 找到 GitLens 插件，点击"安装"
4. 安装完成后，GitLens 会自动启用

### 基本配置

- GitLens 安装后会自动集成到 VSCode 的侧边栏
- 可以通过 `Ctrl+Shift+P` 打开命令面板，输入"GitLens"查看所有可用命令

## Commit Graph 功能详解

### 界面介绍

从你的截图中可以看到，GitLens 的 Commit Graph 界面包含以下主要部分：

1. **标题栏**：显示当前仓库名称和分支信息
2. **导航栏**：显示仓库名、分支名、推送状态等
3. **提交图**：可视化显示提交历史和分支关系
4. **搜索菜单**：提供多种搜索和过滤选项

### 主要功能

- **可视化提交历史**：通过图形化界面展示提交的时间线和分支关系
- **作者信息显示**：每个提交旁边显示作者头像和相关信息
- **分支管理**：清晰显示分支的创建、合并和删除过程
- **时间轴视图**：左侧显示时间轴，帮助理解提交的时间分布

## 搜索功能使用指南

### 搜索菜单详解

根据你的截图，GitLens 提供了以下搜索选项：

#### 1. 按作者搜索

```
My changes @me
Author author: or @:
```

- **@me**：查看当前用户的所有提交
- **author:用户名**：搜索特定作者的提交
- **@:用户名**：同上，另一种写法

#### 2. 按提交信息搜索

```
Message message: or =:
```

- **message:关键词**：在提交信息中搜索包含特定关键词的提交
- **=:关键词**：同上，简化写法

#### 3. 按提交哈希搜索

```
Commit SHA commit: or #:
```

- **commit:哈希值**：通过完整的提交哈希查找特定提交
- **#:哈希值**：同上，简化写法

#### 4. 按类型搜索

```
Type type:stash or is:stash
```

- **type:stash**：查找暂存（stash）记录
- **is:stash**：同上，另一种写法

#### 5. 按文件搜索

```
File file: or ?:
```

- **file:文件名**：查找涉及特定文件的提交
- **?:文件名**：同上，简化写法

#### 6. 按变更内容搜索

```
Change change: or ~:
```

- **change:关键词**：在代码变更内容中搜索
- **~:关键词**：同上，简化写法

#### 7. 按时间范围搜索

```
After Date after: or since:
Before Date before: or until:
```

- **after:日期**：查找指定日期之后的提交
- **since:日期**：同上，另一种写法
- **before:日期**：查找指定日期之前的提交
- **until:日期**：同上，另一种写法

### 实际使用示例

#### 示例 1：查找特定功能的提交

```
message:新增外部成本投入查询
```

这将查找所有提交信息中包含"新增外部成本投入查询"的提交。

#### 示例 2：查找特定作者的提交

```
author:abining
```

这将显示所有由 abining 用户提交的代码。

#### 示例 3：查找特定文件的修改历史

```
file:outerCostOrderSearch.vue
```

这将显示所有涉及 `outerCostOrderSearch.vue` 文件的提交。

#### 示例 4：组合搜索

```
author:abining message:新增
```

这将查找 abining 用户提交的、提交信息中包含"新增"的所有提交。

#### 示例 5：时间范围搜索

```
after:2025-09-01 before:2025-09-10
```

这将查找 2025 年 9 月 1 日到 9 月 10 日之间的所有提交。

## 实用技巧

### 1. 快速导航

- 使用 `Ctrl+Shift+P` 打开命令面板，输入"GitLens"快速访问功能
- 在提交图中点击任意提交可以查看详细信息
- 双击提交可以打开该提交的详细视图

### 2. 高效搜索

- 组合使用多个搜索条件可以精确找到目标提交
- 使用通配符 `*` 进行模糊搜索
- 保存常用的搜索条件以便重复使用

### 3. 代码审查

- 使用比较功能查看不同提交之间的差异
- 通过作者信息了解代码贡献者
- 利用时间轴理解代码演进过程

### 4. 分支管理

- 在提交图中清晰看到分支的创建和合并点
- 通过颜色区分不同的分支
- 快速切换到任意分支或提交

## 参考资源

### 推荐博客文章

1. [图解 git 及 vscode 中的 git/gitlens 插件的使用](https://www.oryoy.com/news/jie-mi-vs-code-gitlens-cha-jian-shen-du-jie-xi-ti-sheng-ni-de-dai-ma-xie-zuo-xiao-lv.html)
2. [掌握 VSCode GitLens 插件助你成为代码版本控制高手](https://www.oryoy.com/news/zhang-wo-vs-code-gitlens-cha-jian-zhu-ni-cheng-wei-dai-ma-ban-ben-kong-zhi-gao-shou.html)
3. [VSCode 插件之 - GitLens 使用指南](https://blog.csdn.net/weixin_43970743/article/details/123456789)

### 官方资源

- [GitLens 官方文档](https://gitlens.amod.io/)
- [GitLens GitHub 仓库](https://github.com/gitkraken/vscode-gitlens)

### 快捷键参考

- `Ctrl+Shift+P`：打开命令面板
- `Ctrl+Shift+G`：打开源代码管理面板
- `Ctrl+K Ctrl+O`：打开仓库

---

_本教程基于 GitLens 最新版本编写，如有疑问请参考官方文档或相关博客文章。_
