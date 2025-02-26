---
layout:     post
author:     "abining"
title:      "使用安卓或iOS设备作为Windows的摄像头和音频扩展工具"
header-style: text
catalog: true
# header-img: "img/post-bg-2015.jpg"
tags: [工具]
---
# 使用安卓或iOS设备作为Windows的摄像头和音频扩展工具

## 介绍

在远程办公、视频会议或在线直播等场景中，摄像头和麦克风是必不可少的设备。如果您的电脑没有摄像头或麦克风，或者您需要更高质量的视频和音频输入，可以使用安卓或iOS设备作为Windows的摄像头和麦克风。

本文将介绍如何使用DroidCam工具实现这一功能。

## 工具下载

推荐下载DroidCam的经典版，该版本图标为绿色的安卓小人图标。

![](https://raw.githubusercontent.com/abining/picgo_imgs/main/images20250226224749499.png)

* **经典版下载地址** ：[https://www.dev47apps.com/](https://www.dev47apps.com/)
* **最新版（可作为备选方案）** ：[https://droidcam.app/](https://droidcam.app/)

## 安装与使用指南

### 1. 下载安装DroidCam

#### Windows端安装

1. 下载并安装DroidCam Windows客户端。
2. 安装完成后，安装完成，打开。

#### 手机端安装

* 安卓用户：从Google Play下载[DroidCam](https://play.google.com/store/apps/details?id=com.dev47apps.droidcam)。
* iOS用户：从App Store下载DroidCam。

### 2. 连接手机与电脑

DroidCam支持两种连接方式：**WiFi无线连接** 和  **USB有线连接** 。

#### WiFi连接（推荐）

1. 确保手机和电脑连接到同一WiFi网络。
2. 打开手机上的DroidCam应用，查看屏幕上显示的IP地址。

![](https://raw.githubusercontent.com/abining/picgo_imgs/main/images20250226225150367.png)

1. 在Windows端打开 `DroidCam Client`，点击中间最大的黑色边框，白色底部的方块选择WiFi连接方式，输入手机端DroidCam显示的IP地址。
2. 

![](https://raw.githubusercontent.com/abining/picgo_imgs/main/images20250226225518192.png)

1. 选择是否启用音频（麦克风），然后点击 `Start`按钮。
2. 连接成功后，DroidCam会将手机摄像头画面和声音传输到电脑。

#### USB连接

1. 需要安装手机USB驱动（部分品牌手机可能默认已安装）。
2. 在手机上开启USB调试模式（开发者选项，麻烦）。
3. 使用USB数据线将手机连接至电脑。
4. 在 `DroidCam Client`中选择USB连接模式，点击 `Start`开始使用。

### 3. 测试摄像头和麦克风

安装并连接成功后，可以使用在线测试工具检查设备是否正常工作：

**[在线测试地址](https://www.p2hp.com/webcammictest/)**

## 使用技巧

1. 连接成功后，可在视频会议软件（如Zoom、腾讯会议、钉钉）中选择“DroidCam”作为摄像头和麦克风输入。
2. 若遇到画面卡顿问题，可以尝试降低分辨率或更换USB连接方式。
3. `HD Mode`模式可提升视频质量，但需要管理员权限运行。
4. 手机摄像头通常比电脑内置摄像头画质更好，可以利用DroidCam实现更清晰的画面。
5. 在火狐浏览器中使用DroidCam时，可能会遇到乱码问题，点击乱码区域即可恢复正常显示。

## 总结

DroidCam是一款优秀的工具，可以让您的安卓或iOS设备变成Windows的摄像头和麦克风，适用于远程办公、在线教学、直播等场景。通过WiFi或USB连接，您可以轻松地在PC端使用手机摄像头和麦克风，提高视频和音频质量。
