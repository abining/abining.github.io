---
layout: post
title: "Hello Linux - 我的Linux学习之旅"
subtitle: "从零开始的Linux探索历程"
categories: [Linux] # 文章分类，tags的替代
author: "Ebin"
header-img: "img/post-bg-unix-linux.jpg"
header-mask: 0.4
# layout:     keynote
# iframe:     "http://huangxuan.me/js-module-7day/"
catalog: true
tags: [Linux, 技术, 笔记]
---

> "Linux 是一个免费的类 Unix 操作系统，它代表着开源精神和技术自由。" —— [Linus Torvalds](https://github.com/torvalds)

## 前言

在这个被操作系统主导的时代，Linux 作为一个自由、开放的操作系统，正在扮演着越来越重要的角色。本文将记录我的 Linux 学习之旅，希望能帮助到同样对 Linux 感兴趣的朋友。

## 为什么选择 Linux？

> "选择 Linux 不仅仅是选择一个操作系统，更是选择了一种生活方式。" —— [Linux Foundation](https://www.linuxfoundation.org/)

### 开源精神

- 自由查看源代码
- 可以自由修改和分发
- 强大的社区支持

### 技术优势

- 稳定性强
- 安全性高
- 资源占用少
- 高度可定制

## 入门必备知识

### 1. 基础命令

> 推荐阅读：[Linux Command Line Basics](https://ubuntu.com/tutorials/command-line-for-beginners)

### 2. 系统管理

> 引用自 [Red Hat 文档](https://www.redhat.com/sysadmin/):
> "系统管理是 Linux 运维中最重要的一环，它直接关系到系统的安全性和稳定性。"

基本操作包括：

- 用户管理
- 权限设置
- 进程控制
- 服务配置

## Linux 发行版选择

| 发行版 | 特点     | 官方网站                               |
| ------ | -------- | -------------------------------------- |
| Ubuntu | 用户友好 | [ubuntu.com](https://ubuntu.com)       |
| CentOS | 稳定可靠 | [centos.org](https://www.centos.org)   |
| Arch   | 高度定制 | [archlinux.org](https://archlinux.org) |

## 进阶学习路线

> 来自 [Linux Journey](https://linuxjourney.com/):
> "掌握 Linux 需要循序渐进，从基础命令到系统架构，每一步都很重要。"

1. **基础知识**

   - [Shell 基础](https://www.shellscript.sh/)
   - [文件系统](https://www.linux.com/training-tutorials/linux-filesystem-explained/)
   - [进程管理](https://www.tecmint.com/linux-process-management/)

2. **网络配置**

   - [TCP/IP 基础](https://www.networkworld.com/article/3242170/tcp-ip-explained.html)
   - [防火墙设置](https://www.digitalocean.com/community/tutorials/iptables-essentials)

3. **安全加固**
   - [SELinux 配置](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/using_selinux/index)
   - [SSH 安全](https://www.ssh.com/academy/ssh/security)

## 实用工具推荐

> "工欲善其事，必先利其器。"

1. **终端工具**

   - [Oh My Zsh](https://ohmyz.sh/) - 终端美化工具
   - [tmux](https://github.com/tmux/tmux) - 终端复用工具
   - [htop](https://htop.dev/) - 系统监控工具

2. **开发工具**
   - [Visual Studio Code](https://code.visualstudio.com/)
   - [Vim](https://www.vim.org/)
   - [Git](https://git-scm.com/)

## 常见问题解决

> 引用自 [Stack Overflow](https://stackoverflow.com/questions/tagged/linux):
> "遇到问题时，先查看日志，再搜索社区解决方案。"

1. 系统日志查看

> 推荐工具：[Glances](https://nicolargo.github.io/glances/) - 系统监控工具
>
> ```bash
> sudo apt install glances  # Ubuntu/Debian
> glances  # 运行
> ```

2. 常见故障排查流程

> 引用自 [Linux Performance](http://www.brendangregg.com/linuxperf.html):
> "系统性能问题通常需要从多个维度进行分析。"

- CPU 相关

  ```bash
  # 查看 CPU 负载
  uptime

  # 查看进程 CPU 使用率
  ps aux --sort=-%cpu | head -n 10
  ```

- 内存相关

  ```bash
  # 查看内存占用最多的进程
  ps aux --sort=-%mem | head -n 10

  # 查看缓存使用情况
  cat /proc/meminfo
  ```

- 磁盘相关

  ```bash
  # 查找大文件
  find / -type f -size +100M -exec ls -lh {} \;

  # 检查磁盘健康状态
  sudo smartctl -a /dev/sda
  ```

4. 系统优化建议

> 来自 [Linux Performance Tuning](https://www.kernel.org/doc/Documentation/sysctl/):

- 文件系统优化

  ```bash
  # 调整文件描述符限制
  ulimit -n 65535
  ```

- 网络优化

  ```bash
  # 查看当前网络连接状态
  netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
  ```

- 进程管理
  ```bash
  # 设置进程优先级
  nice -n 10 command
  renice 10 -p PID
  ```

5. 常用性能监控命令速查

| 命令    | 用途         | 示例              |
| ------- | ------------ | ----------------- |
| top     | CPU/内存监控 | `top -u username` |
| iostat  | IO 监控      | `iostat -x 1`     |
| netstat | 网络连接     | `netstat -tunlp`  |
| vmstat  | 虚拟内存     | `vmstat 1`        |
| sar     | 系统活动     | `sar -u 1 5`      |

> 更多系统监控工具可以参考：[Linux Performance Tools](http://techblog.netflix.com/2015/11/linux-performance-analysis-in-60s.html)

## 未来计划（关于计算机 system）

- [ ] 深入学习 Shell 脚本
- [ ] 掌握系统管理技能
- [ ] 参与开源项目：[First Contributions](https://github.com/firstcontributions/first-contributions)
- [ ] 搭建个人服务器（如你所见）

## 总结

> "Linux 的学习是一个永无止境的过程，重要的是保持热情和持续学习的态度。"

Linux 的学习是一个循序渐进的过程，需要耐心和持续的实践。通过本文的介绍，希望能帮助你更好地开启 Linux 学习之旅。

## 参考资源

1. [Linux Documentation Project](https://tldp.org/)
2. [Linux Foundation Training](https://training.linuxfoundation.org/)
3. [Linux Academy](https://linuxacademy.com/)
4. [Linux.com](https://www.linux.com/)

---

> 本文首发于 [Ebin Blog](https://github.com/abining)，转载请注明出处。
