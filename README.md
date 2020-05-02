# NanoPi-R2S-OpenWrt
 使用 Github Actions 在线编译 NanoPi-R2S 固件

 [![lean's openwrt from dyc](https://github.com/msylgj/NanoPi-R2S-OpenWrt/workflows/lean's%20openwrt%20from%20dyc/badge.svg)](https://github.com/msylgj/NanoPi-R2S-OpenWrt/actions?query=workflow%3A%22lean%27s+openwrt+from+dyc%22)
 [![lean's openwrt from chuck](https://github.com/msylgj/NanoPi-R2S-OpenWrt/workflows/lean's%20openwrt%20from%20chuck/badge.svg)](https://github.com/msylgj/NanoPi-R2S-OpenWrt/actions?query=workflow%3A%22lean%27s+openwrt+from+chuck%22)

## 发布地址
[点我下载](https://github.com/msylgj/NanoPi-R2S-OpenWrt/releases)

## 更新说明
[经常会忘记写的更新说明](https://github.com/msylgj/NanoPi-R2S-OpenWrt/blob/master/CHANGELOG.md)

## 说明
* chuck版使用了5.4.36最新内核,目前看该版本内核有一些问题,暂时不建议使用在主力机器上
* 双版本,Fork自以下两位大神,个人根据**完全私人**口味进行了一定修改
    - [klever1988/nanopi-openwrt](https://github.com/klever1988/nanopi-openwrt)
    - [fanck0605/nanopi-r2s](https://github.com/fanck0605/nanopi-r2s)
* ipv4: 192.168.2.1
* username: root
* password: password
* 添加Flow Offload和Full Cone Nat
* 1.5Ghz超频, 跑分专用
* 内置aria2自动更新bt-tracker脚本
    - 需要使用的话在计划任务处增加一行(时间格式:分 时 日 月 星期几 *代表任意)
    ```bash
    0 1 * * * /usr/bin/autoupdate_tracker.sh 1>/dev/null 2>&1 &
    ```
* wan口和lan口互换(*chuck*)

## 插件清单
- aria2
- ddns with aliyun&dnspod
- 解锁网易云灰色歌曲
- wol网络唤醒
- samba
- frps(注意是服务端)
- kms
- **r-Plus
- 默认移除: netdata uhttpd vftpd frpc

## 版本区别
* DYC(klever1988)版本
    - 保留了对usb-wifi的支持
    - 未互换wan lan
* Chuck(fanck0605)版本
    - 未同步添加usb-wifi支持
    - 开启wan lan互换
    - 较为精简
* 以上区别都增加到了yml中注释掉了,有需要可以在yml中删除注释后自行编译
* 其它未感受到明显差异, 两位大佬的版本都十分优秀, 请不要做任何比较, 选择合适的就好

## 升级方法
* ssh登录到路由器,直接执行./au.sh
    - 支持双版本在线更新
    - 支持本地更新
    - 可选是否保留配置
    - 可选是否使用镜像站点(无科学状态下*非常偶尔*能加个速)

* 获取最新脚本
```bash
wget https://github.com/msylgj/NanoPi-R2S-OpenWrt/raw/master/scripts/autoupdate.sh && chmod +x ./autoupdate.sh && ./autoupdate.sh
```
(脚本原版由gary lau提供，非常感谢！)

## 特别感谢（排名不分先后）
* [fanck0605/nanopi-r2s](https://github.com/fanck0605/nanopi-r2s)
* [klever1988/nanopi-openwrt](https://github.com/klever1988/nanopi-openwrt)
* [lsl330/R2S-SCRIPTS](https://github.com/lsl330/R2S-SCRIPTS)
* [ardanzhu/Opwrt_Actions](https://github.com/ardanzhu/Opwrt_Actions)
* [songchenwen/nanopi-r2s-opkg-feeds](https://songchenwen.com/nanopi-r2s-opkg-feeds/packages/)
* [soffchen/NanoPi-R2S](https://github.com/soffchen/NanoPi-R2S)
* [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede)
* [friendlyarm/friendlywrt](https://github.com/friendlyarm/friendlywrt)