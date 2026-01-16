---
layout: post
author: abining
title: 前端项目自动化部署改造方案
date: 2025-09-25 00:00:00
catalog: true
header-img: "img/post-bg-githubaction-ssh.jpg"
header-mask: 0.4
tags:
  - 前端
  - 部署
  - github action
---

# 前端项目自动化部署改造方案

## 背景

传统的静态网站部署通常需要手动执行以下步骤：

1. 本地构建项目
2. 手动上传构建文件到服务器
3. 配置 Nginx 虚拟主机
4. 重启 Web 服务

这种手动部署方式存在以下问题：

- 部署过程繁琐，容易出错
- 无法保证部署的一致性
- 缺乏版本控制和回滚机制
- 部署效率低下，影响开发节奏

## 解决方案

采用 **GitHub Actions + SSH** 的自动化部署方案，通过 [easingthemes/ssh-deploy](https://github.com/easingthemes/ssh-deploy) 实现代码推送即自动部署。

> **⚠️ 重要提示**
>
> 1. **本文档面向已配置好 Nginx 的用户**，假设您已经知道如何配置 Nginx 虚拟主机
> 2. **SSH 密钥最好不设置密码短语**，否则 GitHub Actions 无法自动认证
> 3. **请根据您的实际部署目录调整配置**，本文档以 `/var/www/pic-admin` 为例

## ssh-deploy 介绍

[easingthemes/ssh-deploy](https://github.com/easingthemes/ssh-deploy) 是一个基于 NodeJS 的 GitHub Action，专门用于通过 rsync over SSH 部署代码到远程服务器。

### 核心特性

- **高效传输**：使用 rsync 协议，只传输变更文件，比 Docker 版本快 1 分钟以上
- **灵活配置**：支持多种 rsync 参数和 SSH 配置选项
- **脚本执行**：支持部署前后执行自定义脚本
- **安全可靠**：基于 SSH 密钥认证，支持多种安全配置

### 主要参数

| 参数              | 类型   | 必需 | 说明                                |
| ----------------- | ------ | ---- | ----------------------------------- |
| `SSH_PRIVATE_KEY` | string | 是   | SSH 私钥内容                        |
| `REMOTE_HOST`     | string | 是   | 服务器 IP 或域名                    |
| `REMOTE_USER`     | string | 是   | 服务器用户名                        |
| `REMOTE_PORT`     | string | 否   | SSH 端口，默认 22                   |
| `ARGS`            | string | 否   | rsync 参数，默认 `-rlgoDzvc -i`     |
| `SOURCE`          | string | 否   | 源目录，相对于工作空间根目录        |
| `TARGET`          | string | 否   | 目标目录，默认 `/home/REMOTE_USER/` |
| `EXCLUDE`         | string | 否   | 排除路径，用逗号分隔                |
| `SCRIPT_BEFORE`   | string | 否   | 部署前执行的脚本                    |
| `SCRIPT_AFTER`    | string | 否   | 部署后执行的脚本                    |

## 部署架构

```
本地开发 → GitHub仓库 → GitHub Actions → 服务器 → Nginx服务
```

## 详细实施步骤

### 1. 服务器环境准备

#### 1.1 确认部署目录

我这里以我需要部署到的目录：`/var/www/pic-admin`为例。

确保您的 Nginx 已配置好，并确认部署目录路径。通常为：

```bash
# 检查您的 Nginx 配置中的 root 目录
# 例如：/var/www/html、/var/www/your-site、/usr/share/nginx/html 等
# 本文档以 /var/www/pic-admin 为例，请根据实际情况调整

# 确保部署目录存在且有正确权限
sudo mkdir -p /var/www/pic-admin
sudo chown -R $USER:$USER /var/www/pic-admin
sudo chmod -R 755 /var/www/pic-admin
```

**注意**：请将 `/var/www/pic-admin` 替换为您实际的部署目录路径。

#### 1.2 生成 SSH 密钥对

```bash
# 生成 SSH 密钥对（用于 GitHub Actions）
ssh-keygen -m PEM -t rsa -b 4096 -C "github-actions" -f ~/.ssh/github_actions

# ⚠️ 重要：不要设置密码短语，保持为空！
# 如果设置了密码短语，GitHub Actions 无法自动输入密码，会导致认证失败
# 将公钥添加到 authorized_keys
cat ~/.ssh/github_actions.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

**常见问题**：如果之前生成的密钥设置了密码短语，需要重新生成：

```bash
# 删除旧密钥
rm -f ~/.ssh/github_actions*

# 重新生成（注意：当提示输入密码短语时，直接按回车，不要输入任何内容）
ssh-keygen -m PEM -t rsa -b 4096 -C "github-actions" -f ~/.ssh/github_actions

# 将公钥添加到 authorized_keys
cat ~/.ssh/github_actions.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# 设置权限
chmod 700 ~/.ssh
chmod 600 ~/.ssh/github_actions
chmod 644 ~/.ssh/github_actions.pub
```

### 2. GitHub 仓库配置

#### 2.1 配置 Secrets

在 GitHub 仓库中配置以下 Secrets：

1. 进入仓库 `Settings` → `Secrets and variables` → `Actions`
2. 点击 `New repository secret` 添加以下配置：

```
ALIYUN_SSH_KEY: 服务器私钥内容 (~/.ssh/github_actions)
ALIYUN_HOST: 服务器IP地址
ALIYUN_USER: 服务器用户名（如 root 或 ubuntu）
```

![](https://raw.githubusercontent.com/abining/picgo_imgs/main/imagesPixPin_2025-09-25_21-27-40.gif)

#### 2.2 获取私钥内容

在服务器上执行：

```bash
cat ~/.ssh/github_actions
```

将输出的完整内容复制到 GitHub Secrets 的 `ALIYUN_SSH_KEY` 中。

### 3. 项目配置

#### 3.1 GitHub Actions 工作流

创建 `.github/workflows/deploy.yml` 文件：

```yaml
name: 部署图床管理后台到阿里云

on:
  push:
    branches:
      - main # 推送到 main 分支时触发部署

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      # 获取代码
      - name: 迁出代码
        uses: actions/checkout@v4

      # 安装 Node.js 环境
      - name: 安装 Node.js
        uses: actions/setup-node@v4
        with:
          node-version: "20"
          cache: "pnpm"

      # 安装依赖
      - name: 安装依赖
        run: pnpm install

      # 构建项目
      - name: 构建项目
        run: pnpm run build

      # 部署到阿里云服务器
      - name: 部署到阿里云服务器
        uses: easingthemes/ssh-deploy@main
        env:
          # SSH私钥
          SSH_PRIVATE_KEY: ${{ secrets.ALIYUN_SSH_KEY }}
          # SCP参数
          ARGS: "-avzr --delete"
          # 源目录（Vite构建后的dist目录）
          SOURCE: "dist/"
          # 服务器IP
          REMOTE_HOST: ${{ secrets.ALIYUN_HOST }}
          # 服务器用户名
          REMOTE_USER: ${{ secrets.ALIYUN_USER }}
          # 目标目录
          TARGET: "/var/www/pic-admin"

      # 部署完成通知
      - name: 部署完成
        run: echo "图床管理后台部署完成！"
```

#### 3.2 项目构建配置

确保 `package.json` 中有正确的构建脚本：

```json
{
  "scripts": {
    "dev": "vite --mode development",
    "build": "vite build --mode production",
    "preview": "vite preview"
  }
}
```

### 4. 部署流程

#### 4.1 自动部署流程

1. **代码推送**：开发者推送代码到 main 分支
2. **触发构建**：GitHub Actions 自动检测到代码变更
3. **环境准备**：在 Ubuntu 环境中安装 Node.js 和依赖
4. **项目构建**：执行 `pnpm run build` 生成 dist 目录
5. **文件传输**：使用 rsync 将构建文件传输到服务器
6. **服务更新**：Nginx 自动提供新的静态文件

#### 4.2 手动触发部署

如果需要手动触发部署，可以：

1. 在 GitHub 仓库的 Actions 页面
2. 选择对应的工作流
3. 点击 "Run workflow" 按钮

### 5. 监控和维护

#### 5.1 部署状态监控

- 在 GitHub 仓库的 Actions 页面查看部署状态
- 绿色勾号表示部署成功
- 红色叉号表示部署失败，可查看详细日志

#### 5.2 常见问题排查

**SSH 认证失败（Permission denied）**：

```bash
# 检查 SSH 服务状态
sudo systemctl status ssh

# 检查 authorized_keys 文件权限
ls -la ~/.ssh/authorized_keys

# 如果密钥设置了密码短语，需要重新生成（无密码）
rm -f ~/.ssh/github_actions*
ssh-keygen -m PEM -t rsa -b 4096 -C "github-actions" -f ~/.ssh/github_actions
# 注意：当提示输入密码短语时，直接按回车，不要输入任何内容
```

**文件权限问题**：

```bash
# 修复文件权限
sudo chown -R $USER:$USER /var/www/pic-admin
sudo chmod -R 755 /var/www/pic-admin
```

**网络连接问题**：

```bash
# 检查阿里云安全组是否开放SSH端口22
# 确保允许 0.0.0.0/0 访问SSH端口（临时测试用）

# 检查服务器防火墙
sudo ufw status
sudo iptables -L
```

**部署目录不存在**：

```bash
# 确保目标目录存在
sudo mkdir -p /var/www/pic-admin
sudo chown -R $USER:$USER /var/www/pic-admin
```

### 6. 高级配置

#### 6.1 多环境部署

可以配置多个环境（开发、测试、生产）：

```yaml
# 开发环境
- name: 部署到开发环境
  if: github.ref == 'refs/heads/develop'
  uses: easingthemes/ssh-deploy@v5.1.0
  with:
    SSH_PRIVATE_KEY: ${{ secrets.DEV_SSH_KEY }}
    REMOTE_HOST: ${{ secrets.DEV_HOST }}
    TARGET: "/var/www/pic-admin-dev"

# 生产环境
- name: 部署到生产环境
  if: github.ref == 'refs/heads/main'
  uses: easingthemes/ssh-deploy@v5.1.0
  with:
    SSH_PRIVATE_KEY: ${{ secrets.PROD_SSH_KEY }}
    REMOTE_HOST: ${{ secrets.PROD_HOST }}
    TARGET: "/var/www/pic-admin"
```

#### 6.2 部署前备份

```yaml
- name: 备份当前版本
  uses: easingthemes/ssh-deploy@v5.1.0
  with:
    SCRIPT_BEFORE: |
      if [ -d "/var/www/pic-admin" ]; then
        sudo cp -r /var/www/pic-admin /var/www/pic-admin-backup-$(date +%Y%m%d-%H%M%S)
        echo "备份完成"
      fi
```

#### 6.3 部署后验证

```yaml
- name: 验证部署
  uses: easingthemes/ssh-deploy@v5.1.0
  with:
    SCRIPT_AFTER: |
      # 检查关键文件是否存在
      if [ -f "/var/www/pic-admin/index.html" ]; then
        echo "部署验证成功"
      else
        echo "部署验证失败"
        exit 1
      fi
```

## 优势总结

### 1. 自动化程度高

- 代码推送即自动部署，无需手动干预
- 减少人为错误，提高部署一致性

### 2. 部署效率高

- 使用 rsync 只传输变更文件，传输速度快
- 并行执行构建和部署，节省时间

### 3. 安全可靠

- 基于 SSH 密钥认证，安全性高
- 支持回滚和版本控制

### 4. 易于维护

- 集中化的配置管理
- 详细的部署日志和状态监控

### 5. 成本效益

- 利用 GitHub Actions 的免费额度
- 减少服务器维护成本

## 总结

通过使用 [easingthemes/ssh-deploy](https://github.com/easingthemes/ssh-deploy) 实现自动化部署，我们成功将传统的手动部署流程改造为现代化的 CI/CD 流程。这种方案不仅提高了部署效率，还增强了系统的可靠性和可维护性，为项目的持续发展奠定了坚实的基础。
