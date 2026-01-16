---
layout: post
author: "abining"
title: "一文搞懂offset系列、client系列、scroll系列，以及他们的应用场景"
header-style: text
catalog: true
# header-img: "img/post-bg-2015.jpg"
tags: [前端开发, css, 盒子模型]
---

# 前言

## 标准盒子模型和 ie 盒子模型的区别

一个盒子由四个部分组成：content、padding、border、margin

可以通过`box-sizing: content-box|border-box|inherit:`来修改盒模型的类型

- content-box: 默认值，标准盒模型，宽高只设置 content 的宽高
- border-box: 怪异盒模型，宽高设置的是 content+padding+border 的宽高
- inherit: 从父元素继承 box-sizing 属性的值。

在标准盒模型的情况下，设置元素的宽高，只会影响元素的 content 区域，实际的总高度和宽度，需要加上 padding，border 和 margin。

在怪异盒模型的情况下，元素的宽高是 content+padding+border 的总和。

盒模型的类型不同，会影响 offset 系列、client 系列、scroll 系列属性的计算方式。
在实际开发中，为了确保跨浏览器的一致性，开发者通常会使用标准盒模型，并在 CSS 中设置 box-sizing: border-box;，这样元素的宽度和高度就会包括内边距和边框，使得布局更加直观和容易控制。

- 接下来使用 element 代指 HTML 元素。
- 文中提到的所有属性没有说明，默认是只读的
- 先从应用场景出发，看看 element 下面的 offset 系列、client 系列、scroll 系列属性的区别

# 应用场景

## Determining the dimensions of elements（确定一个元素的大小）

当想要确认元素的宽高时有几种属性可以选择，但是我们很难确认使用哪个属性才是最适合的。本文将帮助你做出正确的选择。

## 1. 元素占用了多少空间？

如果你需要知道元素总共占用了多少空间，包括可视内容、滚动条（如果有的话）、内边距和边框的宽度，你会使用  [`offsetWidth`](https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/offsetWidth "此页面目前仅提供英文版本")  和  [offsetHeight](https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/offsetHeight "此页面目前仅提供英文版本")  属性，大多数情况下，当元素没有什么形状上的变化时，他们与  [getBoundingClientRect()](https://developer.mozilla.org/en-US/docs/Web/API/Element/getBoundingClientRect "此页面目前仅提供英文版本")的宽高一致。但是如果发生变化，offsetWidth 和 offsetHeight 将返回元素的布局宽高，而 getBoundingClientRect() 将返回实际渲染的宽高。例如：如果元素的宽 width:100px，变化 transform:scale(0.5)，此时 getBoundingClientRect() 将返回宽 50，而 offsetWidth 将返回宽 100.

![20241217145856](https://s2.loli.net/2024/12/17/KROFq23CY8uDfa5.png)

> element.offsetHeight 和 element.offsetWidth 这一对属性指的是元素的 border+padding+content 的宽度和高度，不包括 margin。

## 2. 显示内容尺寸是多少？

如果你需要知道展示区域内容占用了多少空间，包括内边距但是不包括边框、外边距或者滚动条，你会使用[clientWidth](https://developer.mozilla.org/zh-CN/docs/Web/API/Element/clientWidth)和[clientHeight](https://developer.mozilla.org/zh-CN/docs/Web/API/Element/clientHeight)属性：

![20241217150558](https://s2.loli.net/2024/12/17/DKTPupsQdJZL3Ea.png)

## 3. 内容有多大？

如果你想要知道内容区域的实际大小，而不局限于可见区域的话，你会使用  [`scrollWidth`](https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollWidth "此页面目前仅提供英文版本")和[scrollHeight](https://developer.mozilla.org/zh-CN/docs/Web/API/Element/scrollHeight)属性。即使使用了滚动条仅有部分内容可见，这两个属性仍会返回元素的完整内容宽高

例如，一个 300x300 像素 的滚动盒子里放置了一个 600x400 像素的元素，scrollWidth 将会返回 600，scrooHeight 返回 400.

# offset 系列，client 系列，scroll 系列的属性

## offset 系列属性

<!-- 获取偏移以及边框 -->

### element.offsetHeight 和 element.offsetWidth

element.offsetHeight 和 element.offsetWidth 这一对属性指的是元素的 border+padding+content 的宽度和高度，不包括 margin。

### element.offsetLeft 和 element.offsetTop

element.offsetLeft 和 element.offsetTop 这一对属性指的是元素相对于其父元素（offsetParent）的偏移量，包括边框。

1. 如果当前元素的父级元素没有进行 CSS 定位（position 为 absolute 或 relative）,offsetParent 为 body.
2. 假如当前元素的父级元素中有 CSS 定位，offsetParent 取最近的那个父级元素。
3. offsetLeft 返回当前元素左上角相对于 HTMLElement.offsetParent 节点的左边界偏移的像素值。
4. offsetTop 返回当前元素相对于其 offsetParent 元素的顶部的距离。

参考链接：

[HTMLElement.offsetLeft](https://developer.mozilla.org/zh-CN/docs/Web/API/HTMLElement/offsetLeft)  
[HTMLElement.offsetTop](https://developer.mozilla.org/zh-CN/docs/Web/API/HTMLElement/offsetTop)

## client 系列的属性

### element.clientWidth 和 element.clientHeight

返回元素内部的高度(单位像素)，包含内边距 padding，但不包括滚动条 scroll、边框 border 和外边距 margin。

### element.clientLeft 和 element.clientTop

`element.clientLeft`表示一个元素的左边框的宽度，以像素表示。如果元素的文本方向是从右向左（RTL, right-to-left），并且由于内容溢出导致左边出现了一个垂直滚动条，则该属性包括滚动条的宽度。

`element.clientTop`一个元素顶部边框的宽度（以像素表示）。不包括顶部外边距或内边距。

参考链接：

[Element.clientLeft - MDN](https://developer.mozilla.org/zh-CN/docs/Web/API/Element/clientLeft)
[Element.clientTop](https://developer.mozilla.org/zh-CN/docs/Web/API/Element/clientTop)

## scroll 系列属性

### scrollWidth 和 scrollHeight

scrollWidth 和 scrollHeight 返回元素的完整内容宽高，包括由于滚动而未显示在屏幕中的一部分。例如，如果一个元素的内容大于其容器，那么 scrollHeight 将大于 clientHeight。

### element.scrollLeft 和 element.scrollTop

1. scrollLeft 和 scrollTop 属性可以获取或设置一个元素的滚动条位置（水平和垂直方向）。
   获取滚动距离
2. 这对属性是可读写（可被重新赋值）

参考链接：

[Element.scrollTop](https://developer.mozilla.org/zh-CN/docs/Web/API/Element/scrollTop)

[Element.scrollLeft](https://developer.mozilla.org/zh-CN/docs/Web/API/Element/scrollLeft)
