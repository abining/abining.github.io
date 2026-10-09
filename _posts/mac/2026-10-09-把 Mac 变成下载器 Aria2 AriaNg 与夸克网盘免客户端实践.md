---
layout: post
title: "把 Mac 变成自己的下载器：Aria2、AriaNg 与夸克网盘免客户端实践"
subtitle: "一个常驻的下载后端、一张本地 HTML 控制台，再把网页里的下载任务推送进来。"
categories: [Mac]
author: "Ebin"
header-style: text
catalog: true
tags: [Mac, Aria2, AriaNg, LinkSwift, 下载]
---

## 从一个「请先安装客户端」的按钮说起

别人分享给我的夸克网盘文件，我转存到自己的网盘后，想在 Mac 上直接下载，却不想为这一次下载再装一个官方客户端。最初我甚至考虑在云服务器部署 OpenList，后来发现那解决的是另一类问题：我要的是**文件直接落到自己的 Mac**，而不是先经过服务器，也不是绕过网盘的会员或速度限制。

于是我在本机搭了一套可复用的下载环境：**aria2 负责真正下载，AriaNg 提供浏览器中的 HTML 面板，LinkSwift 在需要时负责把网盘页面上的任务交给 aria2**。这不是我从零编写了一个下载引擎，而是把三个工具接成了一条适合自己的工作流。aria2 官方支持 HTTP(S)、FTP、SFTP、BitTorrent 和 Metalink，并提供 RPC 接口；AriaNg 本身只是前端，不负责传输文件。[aria2 项目说明](https://github.com/aria2/aria2) · [AriaNg 项目说明](https://github.com/mayswind/AriaNg)

```text
普通 HTTP 链接 / 批量链接 / 合法的磁力任务
                         │
网盘网页 ── LinkSwift ────┤ 只在需要网盘请求信息时使用
                         ▼
                 Mac 上常驻的 aria2
                    ├─ RPC：仅本机 6800 端口
                    └─ 文件：~/Downloads
                         ▲
                    AriaNg HTML 面板
                  查看进度、暂停、管理任务
```

这里有一个关键区别：**AriaNg 的 HTML 页面不是下载服务器，也不是网盘直链生成器。** 浏览器关闭了，已经交给 aria2 的任务仍由本机后台进程管理；但 Mac 关机后自然不会继续下载。若只是想在浏览器里直接保存单个文件，浏览器自带下载功能已经够用，没必要为了「下载器」而下载器。

## 它到底有什么用？四种真实使用姿势

1. **大文件与不稳定网络**：下载公开的软件安装包、系统镜像、数据集压缩包时，可以在面板里集中看进度、暂停和重试。aria2 支持续传和分段，但是否真的能续传、分段取决于源站是否提供稳定地址、正确的文件长度及 Range 响应；它不会凭空把有限速的服务变快。
2. **一批公开文件一次下完**：资料页给了几十个独立 URL，不用反复点击保存。将每行一个 URL 放到 `urls.txt`，在终端执行 `aria2c --no-conf -i urls.txt -j 3 -d "$HOME/Downloads"`；`--no-conf` 避免这个临时命令再次读取后台服务的 RPC 配置、抢占 `6800` 端口。`-j 3` 是同时下载三个任务，不是把单个文件拆成三段。
3. **合法的 BT、磁力和 Metalink 资源**：例如提供这些格式的开源项目，可以在面板里添加任务、查看文件和进度。只下载自己有权获取的内容；aria2 支持协议，不代表任何资源都能下载成功。
4. **让其他工具把任务推过来**：aria2 的 JSON-RPC 让浏览器脚本、自己的自动化脚本可以提交 URL，AriaNg 则统一管理。网盘案例正是这个姿势：脚本处理网页一侧的链接与必要请求头，aria2 处理传输。

一些早期的 Mac 使用经验文章讨论过「用轻量的后台下载程序搭配浏览器界面」：[少数派《我和迅雷杠上了——Mac 的下载工具》](https://sspai.com/post/42712)和 [Wild Flame 的 Aria2 配置指南](https://wild-flame.github.io/guides/docs/mac-os-x-setup-guide/aria_2/readme)。它们给了我使用场景上的启发，但安装包、接口配置与权限设置请以下面的现行项目文档和本机实测为准，不要照搬旧文里对外开放 RPC 的示例。

## 在 Mac 上把下载后端跑起来

我用 Homebrew 安装了 aria2：

```bash
brew install aria2
aria2c -v
```

安装后直接运行 `aria2c --conf-path="$HOME/.aria2/aria2.conf" -D`，一开始报了两种错：「找不到 `/Users/你的用户名/...`」是把教程的占位符当成真实路径；换成自己的路径后仍提示「指定至少一个 URL」，是因为我只创建了**空的**配置文件，没有下载 URL，也没有打开 RPC。解决方式是给 aria2 一份真正的配置。

> 下面是**首次安装**的示例，会覆盖 `~/.aria2/aria2.conf`。已有配置的人请先备份并合并设置。密钥只保存在自己的 Mac，不要写进博客或截图。

```bash
mkdir -p "$HOME/.aria2" "$HOME/Downloads"
chmod 700 "$HOME/.aria2"
touch "$HOME/.aria2/aria2.session"
chmod 600 "$HOME/.aria2/aria2.session"

RPC_SECRET="$(openssl rand -hex 24)"
cat > "$HOME/.aria2/aria2.conf" <<EOF_CONF
dir=$HOME/Downloads
continue=true
input-file=$HOME/.aria2/aria2.session
save-session=$HOME/.aria2/aria2.session
save-session-interval=60
enable-rpc=true
rpc-listen-all=false
rpc-listen-port=6800
rpc-secret=$RPC_SECRET
EOF_CONF
chmod 600 "$HOME/.aria2/aria2.conf"
```

首次验证可以手动启动：

```bash
aria2c --conf-path="$HOME/.aria2/aria2.conf" --daemon=true
lsof -nP -iTCP:6800 -sTCP:LISTEN
```

正常应看到 `aria2c` 监听 `127.0.0.1:6800`，而不是 `0.0.0.0:6800`。我还向本机 `/jsonrpc` 发送了 `aria2.getVersion` 测试，收到了版本号；这验证的是**aria2 后端和密钥**，不等于已经验证某个网盘文件成功下载。你也可以这样检查：

```bash
RPC_SECRET="$(sed -n 's/^rpc-secret=//p' "$HOME/.aria2/aria2.conf")"
curl -sS -H 'Content-Type: application/json' \
  -d "{\"jsonrpc\":\"2.0\",\"id\":\"test\",\"method\":\"aria2.getVersion\",\"params\":[\"token:$RPC_SECRET\"]}" \
  'http://127.0.0.1:6800/jsonrpc'
```

返回 JSON 中有 `result.version` 才算测试通过。这里的 `token:` 只是原生 RPC 请求格式，AriaNg/LinkSwift 的密钥输入框都只填密钥原文。aria2 官方手册还说明了 `/jsonrpc`、`rpc-secret`、会话保存等选项。[aria2 官方手册](https://aria2.github.io/manual/en/html/aria2c.html)

### 登录时自动启动

手动 `-D` 在重启或重新登录后要重新执行。我把它改为 macOS 用户级 LaunchAgent：`~/Library/LaunchAgents/com.ebin.aria2.plist`，让系统登录时运行 aria2、异常退出时重试。**交给 launchd 后不再加 `-D`**，也不要让它与原来的手动进程同时抢占端口。启动文件的核心内容是：

```xml
<key>ProgramArguments</key>
<array>
  <string>/opt/homebrew/bin/aria2c</string>
  <string>--conf-path=/Users/你的用户名/.aria2/aria2.conf</string>
</array>
<key>RunAtLoad</key><true/>
<key>KeepAlive</key><true/>
```

这是说明结构的**片段**，不是可直接保存的完整 plist；路径要按自己的机器修改。我的环境中用 `launchctl print "gui/$(id -u)/com.ebin.aria2"` 能看到 `state = running`，RPC 在切换后仍正常。当前 Homebrew 的 aria2 formula 没有自带 service 定义，因此不能指望一条 `brew services start aria2` 自动完成这件事。[Homebrew aria2 formula](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/a/aria2.rb) · [Apple 的 launchd 指南](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html)

## 配套 HTML 前台：AriaNg

命令行下载很灵活，但我更愿意在浏览器里看任务。到 [AriaNg Releases](https://github.com/mayswind/AriaNg/releases) 下载 **All-In-One** 压缩包，解压后只有 HTML 页面和许可证文件。我放在 `~/Applications/AriaNg/`，用下面的命令打开：

```bash
open "$HOME/Applications/AriaNg/index.html"
```

这是**静态本地网页**，不必另装 Node、Docker，也不必让网页服务对公网开放。AriaNg「设置 → RPC」填写：

| 项目 | 值 |
| --- | --- |
| 协议 | `WebSocket` |
| 主机 | `localhost` |
| 端口 | `6800` |
| 接口 | `jsonrpc`（界面已显示 `/`） |
| 密钥 | 本机 `aria2.conf` 的 `rpc-secret` 值，不带 `token:` |

组合起来是 `ws://localhost:6800/jsonrpc`。保存后按面板提示刷新；显示「已连接」并能看到 aria2 状态，才说明**前端到后端**这一步也通了。不要把 RPC 密钥填到来历不明的在线演示站。

如果你确实想要一个 `http://localhost` 地址而不是直接打开 `file://`，可以只在本机临时托管这张静态页面：

```bash
python3 -m http.server 8787 --bind 127.0.0.1 --directory "$HOME/Applications/AriaNg"
# 另开浏览器访问 http://127.0.0.1:8787/
```

这个 Python 服务只负责**提供 HTML**，并不接管文件下载；终端按 `Ctrl + C` 就会停止。日常我直接打开本地 HTML，少维护一个进程。`file://` 与 `http://127.0.0.1:8787` 是不同页面来源，切换入口时可能需要重新填写面板设置。

## 案例：夸克网盘文件不装官方客户端，推送到本机

最初我在「夸克网盘直链方案」的讨论里考虑过云服务器 OpenList，但最终没有采用。对于「浏览器里登录自己的夸克账号，把有权下载的文件落到当前 Mac」这个目标，本机 **LinkSwift → aria2 → AriaNg** 更直接：不需要把文件先流经我租用的服务器。注意，「免客户端」指**不安装夸克官方客户端**，仍需要浏览器、用户脚本管理器和本机下载后端。

1. 从 [LinkSwift 官方项目](https://github.com/hmjz100/LinkSwift)提供的正式版来源安装脚本，阅读脚本权限；在 Chrome 的夸克网盘网页版登录自己的账号。只处理自己有权访问和下载的文件。
2. 如果是别人分享的文件，先按网盘网页允许的方式转存到自己的网盘，进入自己的文件列表并选择文件。脚本能否从分享页直接获取链接，取决于当前版本和网页状态，不能一概而论。
3. 打开 LinkSwift 的「Aria2 服务设置」，填 `http://localhost`、端口 `6800`、路径 `/jsonrpc`、**原始密钥**（不带 `token:`）；「存储路径」留空，交由 aria2 配置的 `dir` 决定。截图里预设的 `16800` 通常是 Motrix 的端口，不能原样用于本例的 Homebrew aria2。先点击「测试」。
4. 从 LinkSwift 的下载菜单选择推送到 Aria2，然后在 AriaNg 中观察任务是否出现、下载是否完成，最后到 `~/Downloads` 检查文件大小；若源站提供校验值，再核对 SHA-256。

三者分工要分清：**LinkSwift 获取网盘端提供的下载请求，aria2 执行下载，AriaNg 显示和管理任务。** 普通分享页面 URL 不是可以直接扔给 aria2 的文件直链；需要的 Cookie、Referer 等请求信息应由脚本按当前情况提供。链接可能过期，账号权限或服务端策略也可能使任务返回 `403/412`。本文不承诺绕过会员限速，也不建议为了速度盲目添加连接数。[LinkSwift 项目说明](https://github.com/hmjz100/LinkSwift) · [夸克推送请求头相关问题](https://github.com/hmjz100/LinkSwift/issues/405) · [403/412 问题报告](https://github.com/hmjz100/LinkSwift/issues/488)

**验证边界**：我已经在这台 Mac 上验证 aria2 常驻、仅本机 RPC 可用，并打开了 AriaNg 本地页面；这里没有记录一次真实夸克文件完整下载的结果，所以以上是可操作的案例流程，而不是「实测必定成功」或「一定提速」的承诺。遇到失败，先区分是 LinkSwift 没拿到可用请求、AriaNg 没连接 RPC，还是 aria2 收到上游拒绝；三类问题不能靠盲目增加线程数解决。

## 最后

这套方案最吸引我的不是某个「神奇直链」，而是把下载能力留在自己的 Mac：平时下公开大文件、批量资料、合法的 BT/Metalink，用同一张网页看进度；碰到有下载按钮限制的网盘，再视当前网页和账号权限把任务交给它。**它让下载变得可管理，不负责替任何平台解除限制。**

### 参考和延伸阅读

- [aria2 官方功能与配置手册](https://aria2.github.io/manual/en/html/aria2c.html)
- [AriaNg 官方仓库与 All-In-One 说明](https://github.com/mayswind/AriaNg)
- [LinkSwift 官方仓库及其免责声明](https://github.com/hmjz100/LinkSwift)
- [少数派：《我和迅雷杠上了——Mac 的下载工具》](https://sspai.com/post/42712)
- [Wild Flame：《Aria2 - 下载神器》](https://wild-flame.github.io/guides/docs/mac-os-x-setup-guide/aria_2/readme)
