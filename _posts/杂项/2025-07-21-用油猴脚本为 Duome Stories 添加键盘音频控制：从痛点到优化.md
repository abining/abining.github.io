---
layout: post
categories: [杂项] # 文章分类，tags的替代
author: abining
title: 用油猴脚本为 Duome Stories 添加键盘音频控制：从痛点到优化
header-style: text
catalog: true
tags:
  - Duome
  - 多邻国
  - Tampermonkey
  - 音频预加载
---

# 🎧 用油猴脚本为 Duome Stories 添加键盘音频控制：从痛点到优化

---

## ✨ 背景：从 Duome 学英语的真实痛点出发

[Duome.eu/stories](https://duome.eu/stories) 是我在学习英语时频繁使用的非官方资源网站，提供了丰富的语音故事。每个句子都配有音频，理论上是沉浸式学习的绝佳方式，但实际体验却有明显瑕疵。

---

## 😫 我的两个核心痛点

### 1. **播放音频延迟太久**

页面中每个句子的音频都是通过浏览器 `GET` 请求以 `206 Partial Content` 方式加载。

- 实测每次点击音频播放，**平均等待约 1000ms**，最慢时可达 **1.5 秒** 。

![very slow](https://raw.githubusercontent.com/abining/picgo_imgs/main/images20250721191301639.png)

- 页面没有预加载，导致初次体验非常差，通常点击之后要等待一秒钟才播放音频，频繁打断思路。
- 虽然浏览器会缓存 `206` 音频，但仅在 **播放过一次** 后有效。

📌 **我的目标**是：**在页面加载时预先把所有音频下载好**，后续播放直接使用内存中的音频对象，彻底消除初次播放延迟。

---

### 2. **缺乏键盘操作与视觉反馈**

Duome 的页面里布满了几十个音频按钮，全部需要鼠标点击。没有快捷键意味着：

- 无法像播放器一样通过键盘播放/暂停/切换
- 不知道当前播放的是哪一句话，没有视觉提示

📌 我的第二个目标是：**实现快捷键控制 + 播放时高亮当前音频句子**。

---

## 🧠 功能设计目标

于是我动手编写了一个 Tampermonkey 用户脚本，目标是实现以下功能：

### ✅ 实现功能（按重要性排序）

- ✅ **预加载页面中所有音频**，进入页面即可播放，无需等待
- ✅ **支持快捷键控制播放**（上下句、重播当前）
- ✅ **高亮当前播放的音频按钮**，方便跟踪
- ✅ 提供图形化设置面板，自定义快捷键
- ✅ 控制面板悬浮右上角，鼠标悬停展开，带动画过渡

---

## 🔍 页面结构分析：Duome 音频标签结构

我们分析页面结构，找到关键播放按钮的 DOM 元素。

```html
<div class="playback voice" data-src="https://.../audio.mp3"></div>
```

观察发现：

- 每个音频按钮是一个 `<div class="playback voice">`
- 音频地址保存在 `data-src` 属性中
- 没有用 `<audio>` 标签（点击按钮后才触发下载）

📌 所以我们可以：

1. 用 `querySelectorAll('.playback.voice')` 抓取所有按钮
2. 读取 `data-src` 并手动创建 `new Audio()` 对象
3. 调用 `.load()` 立即预加载音频
4. 将音频挂载到元素上：`el._audio = audio`

这样就能在页面加载阶段提前准备好所有音频。

---

## 🛠 开发过程与技术选择

### 🎧 音频预加载核心逻辑

```js
function preloadAudios() {
  return Array.from(document.querySelectorAll(".playback.voice")).map((el) => {
    const src = el.dataset.src;
    if (src) {
      const audio = new Audio(src);
      audio.load(); // 主动加载
      el._audio = audio; // 挂载到元素
    }
    return el;
  });
}
```

📌 这段代码确保每个按钮都带有一份缓存的 `Audio` 对象，后续播放立即生效。

---

### ⌨️ 快捷键录入方式的取舍

#### 🅰️ 方案一：使用 `<select>` 下拉框选择按键

- ✅ 简单易懂
- ❌ 只能选择固定键，无法支持 `Shift+N` 等组合键

#### 🅱️ 方案二：使用 `keydown` 捕捉用户输入

- ✅ 支持任意按键或组合键
- ✅ 操作更自然（直接按下就记录）
- ❌ 实现略复杂，要处理 `Shift` / `Ctrl` 等修饰符

最终我选择了方式二，用如下方式处理键盘录入：

```js
input.addEventListener("focus", () => {
  input.value = "按下键...";
  const capture = (e) => {
    e.preventDefault();
    let key = e.key;
    if (e.shiftKey && key !== "Shift") key = "Shift+" + key;
    input.value = key;
    window.removeEventListener("keydown", capture);
  };
  window.addEventListener("keydown", capture);
});
```

---

### 💾 快捷键配置的存储方式比较

#### ✅ 方式一：`localStorage`

```js
localStorage.setItem("shortcuts", JSON.stringify(config));
```

- ✅ 浏览器原生支持
- ❌ 每个域名独立、数据不隔离，Tampermonkey 脚本难管理

#### ✅ 方式二：Tampermonkey 提供的 `GM_setValue`

```js
GM_setValue("shortcuts", config);
```

- ✅ 配合油猴脚本完美使用，数据独立、跨域共享
- ✅ 可用于任何 Tampermonkey 页面脚本

📌 最终采用 `GM_setValue` / `GM_getValue`，文档参考：[Tampermonkey 文档](https://www.tampermonkey.net/documentation.php#GM_setValue)

---

## 🎛 悬浮控制面板 + 动画展开

为了不打扰页面主体，我把控制面板缩成了右上角一个小齿轮图标。

- 鼠标悬停显示完整控制面板
- 鼠标移出自动收起
- 使用 `opacity` 和 `transform` 实现动画过渡

核心 CSS：

```css
#duome-panel {
  opacity: 0;
  transform: translateY(-10px);
  transition: all 0.3s ease;
}
```

---

## 🎯 最终效果

- ✅ 进入页面即自动加载所有音频
- ✅ 按 `Tab` 播放下一句，`Shift+Tab` 播放上一句
- ✅ 按 `r` 重播当前音频
- ✅ 每次播放时自动高亮当前按钮
- ✅ 用户可自定义快捷键
- ✅ 设置面板带动画、悬浮右上角不打扰阅读

![](https://raw.githubusercontent.com/abining/picgo_imgs/main/images20250721192321931.png)

---

## 🔧 后续优化计划

- 加入播放文字提示（显示当前句子）
- 添加“记忆播放位置”功能
- 支持使用 `Esc` 暂停当前音频
- 打卡学习进度（记录每天播放量）

---

## 🧩 结语

这个小脚本极大地提升了我在 Duome 学英语的体验，也让我进一步掌握了用户脚本的开发方式、页面结构解析能力，以及预加载和键盘交互等技巧。

花了小半天的时间写的，也希望能对其他人有作用吧。

脚本地址：[https://update.greasyfork.org/scripts/543204/Duome%20Stories%20Audio%20Controller.user.js](https://update.greasyfork.org/scripts/543204/Duome%20Stories%20Audio%20Controller.user.js)

github 仓库地址：[https://github.com/abining/tampermonkey](https://github.com/abining/tampermonkey)
