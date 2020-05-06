# NanoPi-R2S-OpenWrt
 使用 Github Actions 在线编译 NanoPi-R2S 固件

 [![Lean's Openwrt From Chuck](https://github.com/msylgj/NanoPi-R2S-OpenWrt/workflows/Lean's%20Openwrt%20From%20Chuck/badge.svg)](https://github.com/msylgj/NanoPi-R2S-OpenWrt/actions?query=workflow%3A%22Lean%27s+Openwrt+From+Chuck%22)
 [![Openwrt From QiuSimons](https://github.com/msylgj/NanoPi-R2S-OpenWrt/workflows/Openwrt%20From%20QiuSimons/badge.svg)](https://github.com/msylgj/NanoPi-R2S-OpenWrt/actions?query=workflow%3A%22Openwrt+From+QiuSimons%22)

## 发布地址
[点我下载](https://github.com/msylgj/NanoPi-R2S-OpenWrt/releases)

## 更新说明
[经常会忘记写的更新说明](https://github.com/msylgj/NanoPi-R2S-OpenWrt/blob/master/CHANGELOG.md)

## 说明
* 双版本,Fork自以下两位大神,个人根据**完全私人**口味进行了一定修改
    - [QiuSimons/R2S_OP_SSRP](https://github.com/QiuSimons/R2S_OP_SSRP)
    - [fanck0605/nanopi-r2s](https://github.com/fanck0605/nanopi-r2s)
    - QiuSimons版本完全基于官方OpenWrt,Chuck(fanck0605)版本基于Lean版OpenWrt
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
* chuck版目前测试已基本稳定,有问题可以反馈
* 强烈建议刷机完成之后先手动重启一次

## 已知问题
### Chuck版
1. 历史问题已修复,暂无

### QiuSimons版
1. 测试中

## 插件清单
- aria2
- ddns with aliyun&dnspod
- 解锁网易云灰色歌曲
- wol网络唤醒
- samba
- frps(注意是服务端)
- kms
- **r-Plus

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
* [QiuSimons/R2S_OP_SSRP](https://github.com/QiuSimons/R2S_OP_SSRP)
* [fanck0605/nanopi-r2s](https://github.com/fanck0605/nanopi-r2s)
* [klever1988/nanopi-openwrt](https://github.com/klever1988/nanopi-openwrt)
* [lsl330/R2S-SCRIPTS](https://github.com/lsl330/R2S-SCRIPTS)
* [ardanzhu/Opwrt_Actions](https://github.com/ardanzhu/Opwrt_Actions)
* [songchenwen/nanopi-r2s-opkg-feeds](https://songchenwen.com/nanopi-r2s-opkg-feeds/packages/)
* [soffchen/NanoPi-R2S](https://github.com/soffchen/NanoPi-R2S)
* [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede)
* [friendlyarm/friendlywrt](https://github.com/friendlyarm/friendlywrt)