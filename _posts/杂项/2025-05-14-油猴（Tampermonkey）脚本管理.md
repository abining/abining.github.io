---
layout: post
categories: [杂项] # 文章分类，tags的替代
author: abining
title: 油猴脚本管理教程：发布、同步与实用技巧
header-style: text
catalog: true
tags:
  - 浏览器
  - 工具
  - Tampermonkey
  - 油猴
  - 脚本管理
---

# 🛠️ 油猴脚本管理教程：发布、同步与实用技巧

Tampermonkey 是一款流行的浏览器扩展，用于运行用户脚本（UserScripts），它可以大幅度地增强网页功能。本教程将带你了解如何高效地**发布**你的油猴脚本，并在**多个设备之间同步**这些脚本。

本期以我开发的油猴脚本：[CodeCV 简历保存打印脚本](https://www.tampermonkey.net/script_installation.php#url=https://update.greasyfork.org/scripts/535912/CodeCV%E7%AE%80%E5%8E%86%E4%BF%9D%E5%AD%98%E6%89%93%E5%8D%B0%E8%84%9A%E6%9C%AC.user.js)为例

---

## 📦 一、脚本发布方法

你可以通过以下方式将脚本发布给他人使用：

### 1. 发布到脚本托管平台（推荐）

最常用的两个平台：

- [GreasyFork](https://greasyfork.org/)
- [OpenUserJS](https://openuserjs.org/)

#### 🔧 GreasyFork 发布步骤：

1. **注册并登录账号**
2. 进入 [上传新脚本页面](https://greasyfork.org/zh-CN/scripts)
3. 填写：

   - 代码（可以直接粘贴或上传 `.user.js` 文件）
   - 标题和描述
   - 标签、语言等元信息（可选）

4. 点击【提交】
   ![img](https://raw.githubusercontent.com/abining/picgo_imgs/main/images20250514035819734.png)

> 💡 注意：GreasyFork 对脚本内容有严格要求，例如不能加载外部脚本链接，不能包含跟踪代码。

---

### 2. 通过 GitHub 发布

你可以将脚本作为 `.user.js` 文件放入 GitHub 仓库，并在头部添加 `@updateURL` 和 `@downloadURL`：

```js
// ==UserScript==
// @name         My Script
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  示例脚本
// @author       YourName
// @match        *://*/*
// @grant        none
// @downloadURL  https://raw.githubusercontent.com/用户名/仓库名/分支名/脚本名.user.js
// @updateURL    https://raw.githubusercontent.com/用户名/仓库名/分支名/脚本名.user.js
// ==/UserScript==
```

用户访问这个 URL 即可安装脚本，并自动获取更新。

我的仓库：[https://github.com/abining/tampermonkey](https://github.com/abining/tampermonkey)

---

## 🔄 二、不同设备间同步脚本

### 方法一：Tampermonkey 自带的同步功能（推荐）

#### ✅ 步骤：

1. 在设备 A（已有脚本的设备）：
   - 打开 Tampermonkey 设置（点击图标 → 实用工具）
     ![img](https://raw.githubusercontent.com/abining/picgo_imgs/main/images20250514034432096.png)
   - 找到 “云” 或 “Sync” 标签页
   - 选择同步服务（推荐使用 **Google Drive** 或 **OneDrive** ），会要求获取对应云服务厂商的认证。
   - 启用同步，并执行“立即上传”
2. 在设备 B：
   - 使用相同浏览器安装 Tampermonkey 插件
   - 登录相同的 Google/OneDrive 账户
     ![](https://raw.githubusercontent.com/abining/picgo_imgs/main/images20250514034715407.png)
   - 进入 Tampermonkey 设置，启用同步并点击“立即下载”

> 🔐 注意：需开启 Tampermonkey 的“同步设置和脚本”选项，否则只同步设置，不同步脚本。

---

### 方法二：手动导入导出

#### 导出（在设备 A）：

1. 打开 Tampermonkey 仪表盘
2. 点击【实用工具】
3. 找到【备份】
4. 点击“导出为 zip” → 下载脚本备份文件

#### 导入（在设备 B）：

1. 同样进入【实用工具】
2. 找到【恢复】
3. 选择刚才下载的 zip 文件 → 点击“恢复”

---

### 方法三：使用 GitHub 或 Git 版本管理

对于高级用户，建议将所有脚本保存在 Git 仓库中，利用 Git 工具（或 GitHub Desktop）同步代码。优点：

- 支持版本控制
- 多人协作
- 可用于公共或私有存储

---

## 🧠 实用技巧

- ✅ **使用元信息控制更新**

  利用 `@updateURL` / `@downloadURL` 实现脚本自动更新。

- 🔍 **用注释维护脚本 changelog**

  保持代码可读性，方便维护。

- ⌨️ **自定义快捷键**

  使用 `Mousetrap.js` 等库在脚本中加入快捷操作。

- 🧩 **适配不同网站结构**

  使用 `@match` 或 `@include` 精确控制脚本作用范围。

---

## 🏁 总结

| 功能         | 推荐方式              |
| ------------ | --------------------- |
| 脚本发布     | GreasyFork / GitHub   |
| 脚本同步     | Tampermonkey 云同步   |
| 脚本备份     | 导出 ZIP 文件手动同步 |
| 多人协作开发 | GitHub + PR 机制      |
