---
layout: post
title: "gitalk作为评论工具，在Jekyll个人网站上使用"
subtitle: "Gitalk+Jekyll+githubOAuth App"
author: "Ebin"
header-img: "img/post-bg-gitalk.png"
header-color: "black"

catalog: true
tags:
    - Jekyll
    - Gitalk
    - 博客
    - GitHub pages
---

如果你想在自己的Jekyll博客上通过Gitalk添加评论功能，可以跟着我做。

## 实现gitalk作为评论工具，在Jekyll个人网站上使用

### 步骤1: 在GitHub中创建OAuth App

1.  **登录GitHub**：打开浏览器，访问[GitHub](https://github.com)并登录你的账户。

2.  **访问设置**：点击右上角的个人头像，从下拉菜单中选择“Settings（设置）”。

3.  **开发者设置**：在左侧菜单中，向下滚动并点击“Developer settings（开发者设置）”。

4.  **OAuth Apps**：点击左侧菜单中的“OAuth Apps”，然后点击右上角的“New OAuth App（新建OAuth应用）”按钮。

5.  **填写应用信息**：

    *   **Application name（应用名称）** ：输入一个名字，随便写一个。
    *   **Homepage URL（主页URL）** ：输入你的GitHub Pages的URL，如`https://<username>.github.io`。
    *   **Authorization callback URL（授权回调URL）** ：同上，GitHub Pages的URL。

6.  **创建应用**：填写完毕后，点击页面底部的“Register application（注册应用）”按钮。创建成功后，你会看到生成的**Client ID**和**Client Secret**。请将这两个信息安全保存，接下来需要用到。

### 步骤2: 修改post.html文件

1.  **找到文件**：在你的Jekyll项目中，找到`_layouts`文件夹，并打开`post.html`文件。

2.  **添加Gitalk插件**：

    *   在HTML文件的合适位置（通常是文章内容末尾）添加以下代码：

        ```html
            <div id="gitalk-container"></div>
            <link rel="stylesheet" href="https://unpkg.com/gitalk/dist/gitalk.css">
            <script src="https://unpkg.com/gitalk@latest/dist/gitalk.min.js"></script>
            <script src="/js/md5.min.js"></script>
            <script type="text/javascript">
                 // 处理标签，过滤掉空值和无效值
                var tagsString = '{{ page.tags | jsonify }}';  // 使用 jsonify 过滤器
                var tags = JSON.parse(tagsString).filter(function(tag) {
                    return tag && tag.trim() !== '' && !tag.includes('/');  // 过滤掉包含斜杠的标签
                });
                var gitalk = new Gitalk({
                    clientID: '自己的Client ID',
                    clientSecret: '自己的Client secret',
                    repo: '评论存放的仓库名称',
                    owner: 'Github ID/username',
                    admin: ['同owner, 也可添加其他管理员'],
                    id: md5(location.href.match('/(?<=posts/)(.*)(?=/)/')[1]),
                    title: '{{ page.title }}',                     // 使用文章标题
                    body: '文章链接：' + location.href,             // 文章链接
                    labels: ['Gitalk'].concat(tags),               // 只使用有效的标签
                    language: 'zh-CN',
                    perPage: 10,
                    distractionFreeMode: false // 是否启用无干扰模式
                });
                gitalk.render('gitalk-container');
            </script>
        ```

    *   替换`clientID`,`admin`的属性的属性值(共5个，必填项目)，为你的实际信息。

    *   其中`title`是issue的title，`body`是issue的description，`id`会作为页面唯一标识，并且在issue的labels中显示。labels设置的内容同样会显示在issue的labels中。

    *   你也可以把这个内容放在页面文件头部的 YAML front matter，就像这里的第17行`title: '{{ page.title }}',`。
        *   也可以放在`_config.yml` 文件中，通过site即可访问，例如可以修改第11行为：`clientID: '{{ site.gitalk.clientID }}',`。前提是你在`_config.yml`中添加相关配置
        ```js
        gitalk:
          owner: abining              # 您的 GitHub 用户名
          repo: blog-comments         # 存储评论的仓库,通常为:***.github.io
          clientID: ---    # OAuth Application 的 Client ID
          clientSecret: ---  # OAuth Application 的 Client Secret
          admin: abining             # 管理员用户名
          labels: ['Gitalk']         # GitHub issue 的标签
          perPage: 15                # 每页评论数
          pagerDirection: last       # 排序方式是从最新的评论开始
          createIssueManually: true  # 如果当前页面没有相应的 issue，需要手动创建
          distractionFreeMode: false # 是否启用无干扰模式
        ```

### 步骤3: 添加md5的JS文件

1.  **下载md5.js**：从网上找到一个md5的JavaScript实现，或者从这里直接复制。

```js
! function(n) {
    "use strict";

    function d(n, t) {
        var r = (65535 & n) + (65535 & t);
        return (n >> 16) + (t >> 16) + (r >> 16) << 16 | 65535 & r
    }

    function f(n, t, r, e, o, u) {
        return d(function(n, t) {
            return n << t | n >>> 32 - t
        }(d(d(t, n), d(e, u)), o), r)
    }

    function l(n, t, r, e, o, u, c) {
        return f(t & r | ~t & e, n, t, o, u, c)
    }

    function g(n, t, r, e, o, u, c) {
        return f(t & e | r & ~e, n, t, o, u, c)
    }

    function v(n, t, r, e, o, u, c) {
        return f(t ^ r ^ e, n, t, o, u, c)
    }

    function m(n, t, r, e, o, u, c) {
        return f(r ^ (t | ~e), n, t, o, u, c)
    }

    function i(n, t) {
        var r, e, o, u, c;
        n[t >> 5] |= 128 << t % 32, n[14 + (t + 64 >>> 9 << 4)] = t;
        var f = 1732584193,
            i = -271733879,
            a = -1732584194,
            h = 271733878;
        for (r = 0; r < n.length; r += 16) i = m(i = m(i = m(i = m(i = v(i = v(i = v(i = v(i = g(i = g(i = g(i = g(i = l(i = l(i = l(i = l(o = i, a = l(u = a, h = l(c = h, f = l(e = f, i, a, h, n[r], 7, -680876936), i, a, n[r + 1], 12, -389564586), f, i, n[r + 2], 17, 606105819), h, f, n[r + 3], 22, -1044525330), a = l(a, h = l(h, f = l(f, i, a, h, n[r + 4], 7, -176418897), i, a, n[r + 5], 12, 1200080426), f, i, n[r + 6], 17, -1473231341), h, f, n[r + 7], 22, -45705983), a = l(a, h = l(h, f = l(f, i, a, h, n[r + 8], 7, 1770035416), i, a, n[r + 9], 12, -1958414417), f, i, n[r + 10], 17, -42063), h, f, n[r + 11], 22, -1990404162), a = l(a, h = l(h, f = l(f, i, a, h, n[r + 12], 7, 1804603682), i, a, n[r + 13], 12, -40341101), f, i, n[r + 14], 17, -1502002290), h, f, n[r + 15], 22, 1236535329), a = g(a, h = g(h, f = g(f, i, a, h, n[r + 1], 5, -165796510), i, a, n[r + 6], 9, -1069501632), f, i, n[r + 11], 14, 643717713), h, f, n[r], 20, -373897302), a = g(a, h = g(h, f = g(f, i, a, h, n[r + 5], 5, -701558691), i, a, n[r + 10], 9, 38016083), f, i, n[r + 15], 14, -660478335), h, f, n[r + 4], 20, -405537848), a = g(a, h = g(h, f = g(f, i, a, h, n[r + 9], 5, 568446438), i, a, n[r + 14], 9, -1019803690), f, i, n[r + 3], 14, -187363961), h, f, n[r + 8], 20, 1163531501), a = g(a, h = g(h, f = g(f, i, a, h, n[r + 13], 5, -1444681467), i, a, n[r + 2], 9, -51403784), f, i, n[r + 7], 14, 1735328473), h, f, n[r + 12], 20, -1926607734), a = v(a, h = v(h, f = v(f, i, a, h, n[r + 5], 4, -378558), i, a, n[r + 8], 11, -2022574463), f, i, n[r + 11], 16, 1839030562), h, f, n[r + 14], 23, -35309556), a = v(a, h = v(h, f = v(f, i, a, h, n[r + 1], 4, -1530992060), i, a, n[r + 4], 11, 1272893353), f, i, n[r + 7], 16, -155497632), h, f, n[r + 10], 23, -1094730640), a = v(a, h = v(h, f = v(f, i, a, h, n[r + 13], 4, 681279174), i, a, n[r], 11, -358537222), f, i, n[r + 3], 16, -722521979), h, f, n[r + 6], 23, 76029189), a = v(a, h = v(h, f = v(f, i, a, h, n[r + 9], 4, -640364487), i, a, n[r + 12], 11, -421815835), f, i, n[r + 15], 16, 530742520), h, f, n[r + 2], 23, -995338651), a = m(a, h = m(h, f = m(f, i, a, h, n[r], 6, -198630844), i, a, n[r + 7], 10, 1126891415), f, i, n[r + 14], 15, -1416354905), h, f, n[r + 5], 21, -57434055), a = m(a, h = m(h, f = m(f, i, a, h, n[r + 12], 6, 1700485571), i, a, n[r + 3], 10, -1894986606), f, i, n[r + 10], 15, -1051523), h, f, n[r + 1], 21, -2054922799), a = m(a, h = m(h, f = m(f, i, a, h, n[r + 8], 6, 1873313359), i, a, n[r + 15], 10, -30611744), f, i, n[r + 6], 15, -1560198380), h, f, n[r + 13], 21, 1309151649), a = m(a, h = m(h, f = m(f, i, a, h, n[r + 4], 6, -145523070), i, a, n[r + 11], 10, -1120210379), f, i, n[r + 2], 15, 718787259), h, f, n[r + 9], 21, -343485551), f = d(f, e), i = d(i, o), a = d(a, u), h = d(h, c);
        return [f, i, a, h]
    }

    function a(n) {
        var t, r = "",
            e = 32 * n.length;
        for (t = 0; t < e; t += 8) r += String.fromCharCode(n[t >> 5] >>> t % 32 & 255);
        return r
    }

    function h(n) {
        var t, r = [];
        for (r[(n.length >> 2) - 1] = void 0, t = 0; t < r.length; t += 1) r[t] = 0;
        var e = 8 * n.length;
        for (t = 0; t < e; t += 8) r[t >> 5] |= (255 & n.charCodeAt(t / 8)) << t % 32;
        return r
    }

    function e(n) {
        var t, r, e = "0123456789abcdef",
            o = "";
        for (r = 0; r < n.length; r += 1) t = n.charCodeAt(r), o += e.charAt(t >>> 4 & 15) + e.charAt(15 & t);
        return o
    }

    function r(n) {
        return unescape(encodeURIComponent(n))
    }

    function o(n) {
        return function(n) {
            return a(i(h(n), 8 * n.length))
        }(r(n))
    }

    function u(n, t) {
        return function(n, t) {
            var r, e, o = h(n),
                u = [],
                c = [];
            for (u[15] = c[15] = void 0, 16 < o.length && (o = i(o, 8 * n.length)), r = 0; r < 16; r += 1) u[r] = 909522486 ^ o[r], c[r] = 1549556828 ^ o[r];
            return e = i(u.concat(h(t)), 512 + 8 * t.length), a(i(c.concat(e), 640))
        }(r(n), r(t))
    }

    function t(n, t, r) {
        return t ? r ? u(t, n) : function(n, t) {
            return e(u(n, t))
        }(t, n) : r ? o(n) : function(n) {
            return e(o(n))
        }(n)
    }
    "function" == typeof define && define.amd ? define(function() {
        return t
    }) : "object" == typeof module && module.exports ? module.exports = t : n.md5 = t
}(this);
//# sourceMappingURL=md5.min.js.map
```
    
3.  **放入项目**：下载后，将文件放置在你的项目的跟`_layouts`文件夹同级的`js`文件夹内（如果没有这个文件夹，需要创建一个）。
4.  **确保路径正确**：在`post.html`文件中引用这个文件，确保路径与你存放的位置相符,上面的代码已经引入了。

### 效果查看

完成以上步骤后，当你的博客部署到GitHub Pages上时，每篇博文底部应该能看到Gitalk的评论框。如果有任何问题，检查控制台中是否有错误提示，这通常是由配置错误或文件路径问题引起的。
博客评论区效果:
![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/a95b79cf46794b49839eb41cd0b5f8f9~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5bel5Lya5Luj6KGo:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiNzQxNDk1MjkzMDkyMTUxIn0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1731150784&x-orig-sign=hEruVj2gJ5ffuGRiMPUllMyjpew%3D)

指定仓库的[issues](https://github.com/abining/blog-comments/issues)效果:
![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/2a403fec07c440b9ba679615e81d9924~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5bel5Lya5Luj6KGo:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiNzQxNDk1MjkzMDkyMTUxIn0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1731150784&x-orig-sign=uhyuKOaIq00WGR6GkSUyrnMGyBc%3D)

## Gitalk 与 GitHub Issues 的绑定机制探究

### 绑定关系

*   通过 clientID 和 clientSecret 确定是哪个 GitHub OAuth App

*   通过 repo 和 owner 确定评论存储在哪个仓库

*   通过 id 属性来唯一标识一个 Issue。其中，id最长是50个字符

### Issue 创建过程

通过这5个必填的属性，初始化一个issue

```js
{
    clientID: '{{ site.gitalk.clientID }}',     // 识别应用
    repo: '{{ site.gitalk.repo }}',            // 仓库名
    owner: '{{ site.gitalk.owner }}',          // 仓库所有者
    admin: ['{{ site.gitalk.admin }}'],        // 可以初始化评论的人
    id: location.pathname,                     // Issue 的标识符
}
```

### 一个github的issue包含内容

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/ed12c5f263104f3daa62f519cbf6108f~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5bel5Lya5Luj6KGo:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiNzQxNDk1MjkzMDkyMTUxIn0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1731150784&x-orig-sign=SuUdpA2lpVC9a1gACaWUAJdyUPc%3D)

1.  Issue 的标题（Title），默认是网站的head内容，例如这里的红圈色部分的内容，在不指定的时候会作为Issue的title使用。

![image.png](https://p0-xtjj-private.juejin.cn/tos-cn-i-73owjymdk6/ecf57595fb564327a1d9f4396050f0f7~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAg5bel5Lya5Luj6KGo:q75.awebp?policy=eyJ2bSI6MywidWlkIjoiNzQxNDk1MjkzMDkyMTUxIn0%3D&rk3s=f64ab15b&x-orig-authkey=f32326d3454f2ac7e96d3d06cdbb035152127018&x-orig-expires=1731150784&x-orig-sign=MP4W2bfLplHOi9quASeUv6lF7TY%3D)

2.  Issue 的标签（Label）
    可以自己指定，没有指定则会添加[Gitalk](https://github.com/abining/blog-comments/issues?q=is%3Aissue+is%3Aopen+label%3AGitalk)，id

3.  issue的description，未指定则会贴上当前评论的博客的网址。

### id的作用

用于查找对应的 Issue

**工作流程：**

1.  访问页面 -> Gitalk 初始化
2.  使用 id 查找对应的 Issue
3.  如果找不到，管理员可以点击初始化评论
4.  初始化时会创建一个新的 Issue：
    *   Title: 页面标题
    *   Label: 使用 id 值
    *   内容：自动生成的引用链接

所以，GitHub Issues 和网站的绑定是通过：

*   OAuth App 验证（clientID + clientSecret）

2.  仓库信息（repo + owner）

*   Issue label（id）

这三层来确保唯一性和对应关系的。

## 参考

[Jekyll使用Gitalk实现评论功能](https://country-if.github.io/posts/jekyll-gitalk/)

[Jekyll个人博客利用gitalk增加评论功能](https://zoharandroid.github.io/2019-08-02-Jekyll%E4%B8%AA%E4%BA%BA%E5%8D%9A%E5%AE%A2%E5%88%A9%E7%94%A8gitalk%E5%A2%9E%E5%8A%A0%E8%AF%84%E8%AE%BA%E5%8A%9F%E8%83%BD/)
