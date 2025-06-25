# 快速启动指南（macOS）

本指南适用于 macOS 用户，帮助你从零开始运行本博客项目。

---

## 1. 安装 Homebrew（如已安装可跳过）

Homebrew 是 macOS 上最流行的包管理工具，用于安装和管理各种开发环境。

在终端输入：
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

---

## 2. 安装 Ruby

**不推荐使用 macOS 系统自带的 Ruby 2.x 版本**，因为它版本较老且容易遇到权限和兼容性问题。推荐使用 Homebrew 安装最新版 Ruby。

参考文献：
- [Jekyll 官方文档：macOS 安装指南](https://jekyllrb.com/docs/installation/macos/)
- [为什么不建议用系统自带 Ruby](https://brew.sh/index_zh-cn)

使用 Homebrew 安装 Ruby：
```sh
brew install ruby
```

安装完成后，需要将 Ruby 路径加入环境变量：

- **zsh 用户**（macOS 默认 shell）：
  ```sh
  echo 'export PATH="/opt/homebrew/opt/ruby/bin:$PATH"' >> ~/.zshrc
  source ~/.zshrc
  ```
- **bash 用户**：
  ```sh
  echo 'export PATH="/opt/homebrew/opt/ruby/bin:$PATH"' >> ~/.bashrc
  source ~/.bashrc
  ```

这样可以确保你在终端使用的是 Homebrew 安装的新版本 Ruby。

---

## 3. 检查 Ruby 是否安装成功

```sh
ruby -v
```
**作用说明：** 该命令用于查看当前 Ruby 版本，确认是否为新安装的版本（如 ruby 3.x.x）。

---

## 4. 安装 Bundler

Bundler 是 Ruby 的依赖管理工具，用于安装和管理项目所需的 gem 包。

```sh
gem install bundler
```
**说明：** `gem` 是 Ruby 的包管理工具，`gem install bundler` 用于安装 Bundler。

---

## 5. 安装依赖

进入项目根目录：
```sh
cd /Users/*/*/abining.github.io
```

如遇到 lockfile 版本不兼容，先删除 lockfile：
```sh
rm Gemfile.lock
```

然后安装依赖：
```sh
bundle install
```
**作用说明：**
- `Gemfile` 文件用于声明项目所需的所有 Ruby 依赖包（gem）。
- `bundle install` 会根据 Gemfile 自动下载并安装所有依赖。

---

## 6. 启动本地服务

```sh
bundle exec jekyll serve
```
**作用说明：** 该命令会启动 Jekyll 本地服务，生成并预览静态博客网站。

浏览器访问 http://localhost:4000 即可预览博客。

---

## 常见问题

- 如果遇到 Bundler 版本报错，优先升级 Bundler 并删除 Gemfile.lock 重新安装依赖。
- 如有 gem 安装失败或其他报错，将报错内容发给开发者协助解决。
