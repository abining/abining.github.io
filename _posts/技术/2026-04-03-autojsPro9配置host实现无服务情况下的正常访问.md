---
layout: post
author: abining
title: autojsPro9配置host实现无服务情况下的正常访问
header-style: text
date: 2026-04-03 00:00:00
catalog: true
tags:
  - autojsPro
  - host
---

## 背景。
2026年4月3日早上九点左右，发现autojs无法登录了，于是找到之前的host配置文件。

配置文件：

```bash
1.12.243.165 pro.autojs.org
1.12.243.165 get.baibaoyun.com
37.187.75.186 boys.intcl.top
37.187.75.186 aj.joysboy.com
```

然后ping对应的ip，发现ping不通，于是去找解决方案。

## 找到解决方案的历程

>【2026最新可用】pro版本带搭建教程
>链接：https://pan.quark.cn/s/39e5260200fc

现在的配置文件我是使用别人的mock数据，mock数据来源：

根据提供的文件，发现有一份json，我把json解析出来，得到代码如下：

```js
// 在请求到达服务器之前,调用此函数,您可以在此处修改请求数据
// 例如Add/Update/Remove：Queries、Headers、Body
async function onRequest(context, request) {
    console.log(request.url);
    //URL参数
    //request.queries[\"name\"] = \"value\";
    // 更新或添加新标头
    //request.headers[\"X-New-Headers\"] = \"My-Value\";

    // Update Body 使用fetch API请求接口，具体文档可网上搜索fetch API
    //request.body = await fetch('https://www.baidu.com/').then(response => response.text());
    return request;
}
 
// 在将响应数据发送到客户端之前,调用此函数,您可以在此处修改响应数据
async function onResponse(context, request, response) {
    // 更新或添加新标头
     
    response.headers[\"Content-Type\"] = \"application/json\";
    response.statusCode = 200;
    if (request.url.includes(\"/csrfToken\")) {
        response_data = {
            '_csrf': 'Tbs6hIVo--Ngb_G9VJ3lnoMR1EYRnQli5bEY'
        }
        response.body = JSON.stringify(response_data)
    } else if (request.url.includes(\"/api/v1/config\")) {
        response_data = {
            'wl': '0a4fd5d5accf385b8d5f382d7abcfea7'
        }
        response.body = JSON.stringify(response_data)
    } else if (request.url.includes(\"/docs\")) {
        response.body = 'http://tool.zjh336.cn/docs/v8/app.html';
    } else if (request.url.includes(\"/api/v1/account\")) {
     
        var body = {
            'id': '6131f76468e4553fba39ae4c',
            'now': Date.now(),
            'emailAddress': '1242129506@qq.com',
            'fullName': '悯默',
            'paidServices': {
                'v8': {
                    'expires': Date.now() + 1000000
                }
            },
            'permissions': {}
        }
        response.body = JSON.stringify(body);
    } else if (request.url.includes(\"/static/legal/version.json\")) {
        response_data = {
            'version': 20240211,
            'wording': 'AutojsPro\\n阅读%s和%s全文了解详细信\\n请点击“同意”继续接受我们的服务。'
        }
        response.body = JSON.stringify(response_data)
    } else if (request.url.includes(\"/api/v1/security/validation2\")) {
        response_data = {
            \"data\": \"uNl8AK0WM6mIAQAAM9bHGgAAAACaX4kztI8jdDdMKBwYbba4oNAKCHba0nRgN7zXoP0IzjEyM2NjZjgzMmFiZTg5OGYAAQAAAAAAAAAyWsXfnWpHYVlJ4ZPT/u3n+ZH3NLvubrTRJnas08r0ijocgKnKqCxTFvJgeZnWx2omp6CzeSFWEG8aEaarJ4XMkp9+F8sdy2yFkqkOrp41KmCfShbIQX4hCYeD0mVOOwfOVLpQLJjg18FvFvHm9TKYzK5ysfv9UHuHn8+dexgnLM28j5BDrIFv9B9XS+UW1x/lLAwe+QzBEAWzsYFKPkVJ9Mc0L5lG/i8Eh7bxcGHIg1L+VbC4t9+CZXcF6DOoy75I40omuQs/gtbLCsMEr7fdsiDQ76iukr1SwLHVIEaXrNutrvvqKp+UBcq4WGQEM+aMj46S3pd7+h17J8vKdTVknI2IOJPZM2mVjGCQ3MBriG5HQqghbFE3y/VEPWpmtkgjDXqc09vuYA4PLxnV1AbvoAEvy8FgqxY00MXANK2MMixzZorUIC2Jk1hBLgPYHd1lMPlAMt8Deab3KZ0sJNLMo/7tAzk50DrPse3onAg5oA5QTSDfKBI2AtZP+DmPYrtsa96iUFK9iz8/18Pnhw/GBd+ceDR00dpQRVGjqTFxftAtZFr9kFYXTfz94+uq/fnVlH4eDGQiNAvuPg/4nQLXlde3lDYp5loaN2MkjL4uK9m8uQjH68217L195jsXANSo8IKjJYqWzcA1oCF/Smnmwc03k0Uk5OcfunIF/AGJ1g==\"
        }
        response.body = JSON.stringify(response_data)
    } else if (request.url.includes(\"/docs/documentation.json\")) {
        response_data = {
            'documentation_version': 20221024
        }
        response.body = JSON.stringify(response_data)
    } else if (request.url.includes(\"/api/v1/announcements\")) {
        response_data = {};
        response.body = JSON.stringify(response_data)
    } else if (request.url.includes(\"/api/v1/plugins\")) {
        plugins = [{
                \"package_name\": \"org.autojs.plugin.ffmpeg\",
                \"name\": \"官方FFMpeg插件\",
                \"version\": \"1.1\",
                \"version_code\": 1,
                \"summary\": \"FFmpeg是一套可以用来记录、转换数字音频、视频，并能将其转化为流的开源计算机程序。本插件用于利用ffmpeg处理音视频文件，比如从格式转换等。\",
                \"icon\": \"https://www.joysboy.com/docs/assets/image/ffmpeg-plugin.png\",
                \"url\": \"https://www.joysboy.com/docs/blog/ffmpeg-plugin.html\",
                \"installed\": false,
                \"update_timestamp\": 0
            },
            {
                \"package_name\": \"org.autojs.autojspro.plugin.mlkit.ocr\",
                \"name\": \"官方MLKitOCR插件\",
                \"version\": \"1.1\",
                \"version_code\": 1,
                \"summary\": \"基于谷歌MLKit，识别速度超过绝大部分OCR。\",
                \"icon\": \"https://www.joysboy.com/docs/assets/image/mlkit-ocr-plugin.png\",
                \"url\": \"https://www.joysboy.com/docs/blog/mlkit-ocr-plugin.html\",
                \"installed\": false,
                \"update_timestamp\": 0
            },
            {
                \"package_name\": \"cn.lzx284.p7zip\",
                \"name\": \"7Zip通用压缩插件\",
                \"version\": \"1.2.1\",
                \"version_code\": 4,
                \"summary\": \"本插件基于p7zip 16.02制作，支持多种格式文件的压缩与解压。7-Zip是一款完全免费而且开源的压缩软件，相比其他软件有更高的压缩比但同时耗费的资源也相对更多，能提供比使用 PKZip 及 WinZip 高2~10%的压缩比率。\",
                \"icon\": \"https://www.joysboy.com/docs/assets/image/7zip-plugin.png\",
                \"url\": \"https://www.joysboy.com/docs/blog/7zip-plugin.html\",
                \"documentation_url\": \"https://www.joysboy.com/docs/blog/7zip-plugin.html\",
                \"installed\": false,
                \"update_timestamp\": 0
            },
            {
                \"package_name\": \"com.hraps.pytorch\",
                \"name\": \"Pytorch插件\",
                \"version\": \"1.0.0\",
                \"version_code\": 1,
                \"summary\": \"Pytorch模块提供了已完成的深度学习神经网络模型在安卓设备上执行的功能，可以实现常规程序难以实现的功能，如：图像识别，语言翻译，语言问答等。\",
                \"icon\": \"https://www.joysboy.com/docs/assets/image/pytorch-logo.png\",
                \"url\": \"https://www.joysboy.com/docs/v8/thirdPartyPlugins.html\",
                \"documentation_url\": \"https://www.joysboy.com/docs/v8/thirdPartyPlugins.html#pytorch插件\",
                \"installed\": false,
                \"update_timestamp\": 0
            },
            {
                \"package_name\": \"org.autojs.autojspro.ocr.v2\",
                \"name\": \"PaddleOCR\",
                \"version\": \"1.3\",
                \"version_code\": 1,
                \"summary\": \"PaddleOCR\",
                \"icon\": \"\",
                \"url\": \"\",
                \"documentation_url\": \"\",
                \"installed\": false,
                \"update_timestamp\": 0
            }
        ]
        response.body = JSON.stringify(plugins)
    } else if (request.url.includes(\"/api/v1/project\")) {
        response_data = [{
            \"packageName\": \"com.ninedays.a.b\",
            \"file\": \"http://pcdn.autojs.org/projects/migrated/97beef80-d1d7-4812-8000-c91bd4e03007.zip\",
            \"name\": \"下拉框高度更改\",
            \"permissions\": [],
            \"version\": \"2.69\",
            \"versionCode\": 1,
            \"minSdkVersion\": 0,
            \"contacts\": {},
            \"summary\": \"花了两天研究改下拉框高度\",
            \"details\": \"有更好的更改方法告诉我一下2307136635\",
            \"images\": [],
            \"releaseNotes\": {},
            \"maxAutoJsVersion\": 0,
            \"minAutoJsVersion\": 0,
            \"minProVersion\": 0,
            \"maxProVersion\": 0,
            \"compileVersion\": \"Pro 9.1.20-0\",
            \"category\": \"模块\",
            \"tags\": [],
            \"status\": 0,
            \"fileSize\": 1556,
            \"user\": {
                \"id\": \"62a57ee9879b9e3dbb07a9b0\",
                \"emailAddress\": \"wm_v@qq.com\",
                \"fullName\": \"九天\"
            },
            \"upvoted\": false,
            \"upvotedCount\": 0,
            \"id\": \"6309b505f9e3cc1848d963bb\"
        }, {
            \"packageName\": \"来一局TicTacToe?\",
            \"file\": \"http://pcdn.autojs.org/projects/migrated/4494cd62-73bb-445f-8317-7723e3ed7548.zip\",
            \"name\": \"人机井字棋对弈\",
            \"permissions\": [],
            \"version\": \"1.0.0\",
            \"versionCode\": 0,
            \"minSdkVersion\": 0,
            \"contacts\": {},
            \"summary\": \"井字棋人机对弈\",
            \"details\": \"权值算法计算最优解\",
            \"images\": [],
            \"releaseNotes\": {},
            \"maxAutoJsVersion\": 0,
            \"minAutoJsVersion\": 0,
            \"minProVersion\": 0,
            \"maxProVersion\": 0,
            \"compileVersion\": \"Pro 9.1.19-0\",
            \"category\": \"其他\",
            \"tags\": [],
            \"status\": 0,
            \"fileSize\": 3525,
            \"user\": {
                \"id\": \"5e426df225fbe26cc58cacc0\",
                \"emailAddress\": \"418740992@qq.com\",
                \"fullName\": \"楚轩\"
            },
            \"upvoted\": false,
            \"upvotedCount\": 0,
            \"id\": \"62fba096874d234d9ee41ece\"
        }]
        response.body = JSON.stringify(response_data)
    } else if (request.url.includes(\"/api/v1/project/categories\")) {
        response_data = [\"官方示例\", \"模块\", \"系统工具\", \"实用工具\", \"学习教育\", \"软件辅助\", \"游戏辅助\", \"游戏\", \"其他\"]
        response.body = JSON.stringify(response_data)
    } else if (request.url.includes(\"/api/v1/project/tags\")) {
        response_data = [\"精品\", \"官方\", \"UI\"]
        response.body = JSON.stringify(response_data)
    }
    return response;
}

```

我分析是一个用来伪造数据的一个代理方法，于是就想到用nginx来实现一个

```conf

    location = /csrfToken {
        default_type application/json;
        return 200 '{"_csrf":"Tbs6hIVo--Ngb_G9VJ3lnoMR1EYRnQli5bEY"}';
    }

    location = /api/v1/config {
        default_type application/json;
        return 200 '{"wl":"0a4fd5d5accf385b8d5f382d7abcfea7"}';
    }

    location = /docs {
        default_type text/plain;
        return 200 'http://tool.zjh336.cn/docs/v8/app.html';
    }

    location = /api/v1/account {
        default_type application/json;
        return 200 '{"id":"6131f76468e4553fba39ae4c","now":1712123412341,"emailAddress":"3094774079@qq.com","fullName":"abining","paidServices":{"v8":{"expires":4865723412000}},"permissions":{}}';
    }

    location = /static/legal/version.json {
        default_type application/json;
        return 200 '{"version":20240211,"wording":"AutojsPro\\n阅读%s和%s全文了解详细信\\n请点击“同意”继续接受我们的服务。"}';
    }

    location = /api/v1/security/validation2 {
        default_type application/json;
        return 200 '{"data":"uNl8AK0WM6mIAQAAM9bHGgAAAACaX4kztI8jdDdMKBwYbba4oNAKCHba0nRgN7zXoP0IzjEyM2NjZjgzMmFiZTg5OGYAAQAAAAAAAAAyWsXfnWpHYVlJ4ZPT/u3n+ZH3NLvubrTRJnas08r0ijocgKnKqCxTFvJgeZnWx2omp6CzeSFWEG8aEaarJ4XMkp9+F8sdy2yFkqkOrp41KmCfShbIQX4hCYeD0mVOOwfOVLpQLJjg18FvFvHm9TKYzK5ysfv9UHuHn8+dexgnLM28j5BDrIFv9B9XS+UW1x/lLAwe+QzBEAWzsYFKPkVJ9Mc0L5lG/i8Eh7bxcGHIg1L+VbC4t9+CZXcF6DOoy75I40omuQs/gtbLCsMEr7fdsiDQ76iukr1SwLHVIEaXrNutrvvqKp+UBcq4WGQEM+aMj46S3pd7+h17J8vKdTVknI2IOJPZM2mVjGCQ3MBriG5HQqghbFE3y/VEPWpmtkgjDXqc09vuYA4PLxnV1AbvoAEvy8FgqxY00MXANK2MMixzZorUIC2Jk1hBLgPYHd1lMPlAMt8Deab3KZ0sJNLMo/7tAzk50DrPse3onAg5oA5QTSDfKBI2AtZP+DmPYrtsa96iUFK9iz8/18Pnhw/GBd+ceDR00dpQRVGjqTFxftAtZFr9kFYXTfz94+uq/fnVlH4eDGQiNAvuPg/4nQLXlde3lDYp5loaN2MkjL4uK9m8uQjH68217L195jsXANSo8IKjJYqWzcA1oCF/Smnmwc03k0Uk5OcfunIF/AGJ1g=="}';
    }

    location = /docs/documentation.json {
        default_type application/json;
        return 200 '{"documentation_version":20221024}';
    }

    location = /api/v1/announcements {
        default_type application/json;
        return 200 '{}';
    }

    location = /api/v1/plugins {
        default_type application/json;
        return 200 '[{"package_name":"org.autojs.plugin.ffmpeg","name":"官方FFMpeg插件","version":"1.1","version_code":1,"summary":"FFmpeg是一套可以用来记录、转换数字音频、视频，并能将其转化为流的开源计算机程序。本插件用于利用ffmpeg处理音视频文件，比如从格式转换等。","icon":"https://www.joysboy.com/docs/assets/image/ffmpeg-plugin.png","url":"https://www.joysboy.com/docs/blog/ffmpeg-plugin.html","installed":false,"update_timestamp":0},{"package_name":"org.autojs.autojspro.plugin.mlkit.ocr","name":"官方MLKitOCR插件","version":"1.1","version_code":1,"summary":"基于谷歌MLKit，识别速度超过绝大部分OCR。","icon":"https://www.joysboy.com/docs/assets/image/mlkit-ocr-plugin.png","url":"https://www.joysboy.com/docs/blog/mlkit-ocr-plugin.html","installed":false,"update_timestamp":0},{"package_name":"cn.lzx284.p7zip","name":"7Zip通用压缩插件","version":"1.2.1","version_code":4,"summary":"本插件基于p7zip 16.02制作，支持多种格式文件的压缩与解压。7-Zip是一款完全免费而且开源的压缩软件，相比其他软件有更高的压缩比但同时耗费的资源也相对更多，能提供比使用 PKZip 及 WinZip 高2~10%的压缩比率。","icon":"https://www.joysboy.com/docs/assets/image/7zip-plugin.png","url":"https://www.joysboy.com/docs/blog/7zip-plugin.html","documentation_url":"https://www.joysboy.com/docs/blog/7zip-plugin.html","installed":false,"update_timestamp":0},{"package_name":"com.hraps.pytorch","name":"Pytorch插件","version":"1.0.0","version_code":1,"summary":"Pytorch模块提供了已完成的深度学习神经网络模型在安卓设备上执行的功能，可以实现常规程序难以实现的功能，如：图像识别，语言翻译，语言问答等。","icon":"https://www.joysboy.com/docs/assets/image/pytorch-logo.png","url":"https://www.joysboy.com/docs/v8/thirdPartyPlugins.html","documentation_url":"https://www.joysboy.com/docs/v8/thirdPartyPlugins.html#pytorch插件","installed":false,"update_timestamp":0},{"package_name":"org.autojs.autojspro.ocr.v2","name":"PaddleOCR","version":"1.3","version_code":1,"summary":"PaddleOCR","icon":"","url":"","documentation_url":"","installed":false,"update_timestamp":0}]';
    }

    location = /api/v1/project/categories {
        default_type application/json;
        return 200 '["官方示例","模块","系统工具","实用工具","学习教育","软件辅助","游戏辅助","游戏","其他"]';
    }

    location = /api/v1/project/tags {
        default_type application/json;
        return 200 '["精品","官方","UI"]';
    }

    location = /api/v1/project {
        default_type application/json;
        return 200 '[{"packageName":"com.ninedays.a.b","file":"http://pcdn.autojs.org/projects/migrated/97beef80-d1d7-4812-8000-c91bd4e03007.zip","name":"下拉框高度更改","permissions":[],"version":"2.69","versionCode":1,"minSdkVersion":0,"contacts":{},"summary":"花了两天研究改下拉框高度","details":"有更好的更改方法告诉我一下2307136635","images":[],"releaseNotes":{},"maxAutoJsVersion":0,"minAutoJsVersion":0,"minProVersion":0,"maxProVersion":0,"compileVersion":"Pro 9.1.20-0","category":"模块","tags":[],"status":0,"fileSize":1556,"user":{"id":"62a57ee9879b9e3dbb07a9b0","emailAddress":"wm_v@qq.com","fullName":"九天"},"upvoted":false,"upvotedCount":0,"id":"6309b505f9e3cc1848d963bb"},{"packageName":"来一局TicTacToe?","file":"http://pcdn.autojs.org/projects/migrated/4494cd62-73bb-445f-8317-7723e3ed7548.zip","name":"人机井字棋对弈","permissions":[],"version":"1.0.0","versionCode":0,"minSdkVersion":0,"contacts":{},"summary":"井字棋人机对弈","details":"权值算法计算最优解","images":[],"releaseNotes":{},"maxAutoJsVersion":0,"minAutoJsVersion":0,"minProVersion":0,"maxProVersion":0,"compileVersion":"Pro 9.1.19-0","category":"其他","tags":[],"status":0,"fileSize":3525,"user":{"id":"5e426df225fbe26cc58cacc0","emailAddress":"418740992@qq.com","fullName":"楚轩"},"upvoted":false,"upvotedCount":0,"id":"62fba096874d234d9ee41ece"}]';
    }

```

我把这个nginx的配置放在我的服务器上，然后再配置手机的host文件，就可以成功使用了。

## 配置手机host文件的方法。

magisk自带了一个去除广告的模块，那个模块就是通过host来实现去广告的，可以在规则后面新增如下的规则，实现本地网络劫持。

注意：这里的域名需要你自己配置，我把所有代理都转发到我自己的服务器上了，如果需要，可以联系我。

```bash
1.12.243.165 pro.autojs.org
1.12.243.165 get.baibaoyun.com
37.187.75.186 boys.intcl.top
37.187.75.186 aj.joysboy.com
```

## 总结

如果你需要参考我的教程来结局autojsPro的无法访问问题。

1. 确保你有自己的服务器，服务器有公网ip。
2. 服务器的nginx有运行在80端口服务。
3. 在nginx的配置文件上追加上面的规则块。
4. 配置手机的host文件。

我不提供hostip，需要的话自己搭建