在 OpenWrt (x86) 上将 Tailscale 配置为**子网路由（Subnet Router）** ，可以让您在外部远程访问家里的所有设备（如 NAS、智能家居、路由器后台），而无需在每个设备上都安装 Tailscale。

由于 OpenWrt 的特殊性，除了在网页端勾选设置外，还需要处理防火墙逻辑。

### 第一步：在 OpenWrt 上宣告子网

登录 OpenWrt 的 SSH，执行以下命令。以我的家庭内网网段是 `192.168.0.0/24`为例：

```Bash
tailscale up --advertise-routes=192.168.0.0/24 --accept-dns=false
```

-   **注意：** 请根据你实际的 LAN 口网段修改 `192.168.0.0/24`。
-   `--accept-dns=false` 通常建议加上，防止 Tailscale 的 DNS 配置干扰 OpenWrt 本身的 DNS 解析。

* * *

### 第二步：在 Tailscale 后台批准路由

1.  打开 [Tailscale Admin Console](https://login.tailscale.com/admin/machines)。
1.  找到你的 OpenWrt 设备，点击 **Edit route settings**。
1.  在 **Subnet routes** 下方，勾选你刚刚宣告的网段（如 `192.168.0.0/24`）。
1.  保存。此时，错误提示应该会消失。

![](https://raw.githubusercontent.com/abining/picgo_imgs/main/imagesimage-20260108171415042.png)

![](https://raw.githubusercontent.com/abining/picgo_imgs/main/imagesimage-20260108171451318.png)

### 第三步：配置 OpenWrt 防火墙（关键）

OpenWrt 默认会丢弃来自未识别接口的转发流量。为了让 Tailscale 的流量能顺利到达 LAN 侧，建议创建一个单独的防火墙区域。

#### 1. 创建接口

在 OpenWrt 后台：**网络 (Network) -> 接口 (Interfaces)** ：

-   添加新接口，名称定为 `tailscale`。
-   协议选择 **不配置协议 (Unmanaged)** 。
-   设备选择 **tailscale0**。
    ![](https://raw.githubusercontent.com/abining/picgo_imgs/main/imagesimage-20260108163340166.png)

#### 2. 配置防火墙区域

前往：**网络 (Network) -> 防火墙 (Firewall)** ：

-   新建一个区域，名称定为 `tailscale`。
-   **入站数据 (Input):** accept
-   **出站数据 (Output):** accept
-   **转发 (Forward):** accept
-   **允许从源区域转发:** 勾选 `lan`。
-   **允许转发到目标区域:** 勾选 `lan`。
-   **设备/接口:** 选择刚才创建的 `tailscale` 接口。

* * *

### 第四步：开启 IP 动态伪装 (Masquerading)

为了确保回程路由正常（即 LAN 里的设备知道把数据发回给 OpenWrt），最简单的方法是在防火墙上对 Tailscale 区域开启 **MSS 锁定 (MSS Clamping)** 和 **动态伪装 (Masquerading)** ：

1.  在刚才创建的 `tailscale` 防火墙区域设置中。
1.  勾选 **动态伪装 (Masquerading)** 。
1.  勾选 **MSS 锁定 (MSS Clamping)** 。
    ![](https://raw.githubusercontent.com/abining/picgo_imgs/main/images20260108172005143.png)

* * *

### 验证连接

1.  让你的手机或笔记本连接外部网络（如 5G），并开启 Tailscale。
1.  在浏览器尝试访问 OpenWrt 的 LAN IP（如 `192.168.0.110`），即可访问家庭设备。

## 最后

计算机网络里面的东西太多，太精妙了。这个系统真复杂。



