## 20200507
* chuck版内核更新至5.4.38,已基本稳定
* chuck版增加checkwan守护脚本
* chuck版取消wan&lan互换
* 第二版本换成了另一位大佬QiuSimons基于官方Openwrt的版本
* 移除dyc版编译,20200501版本基本完美,作为保留版本

## 20200504
* chuck版跟随上游采用官方repo
* chuck版内核确认采用5.4.36
* ssrp无法导入服务器的问题已修复

## 20200502
* chuck版更新至5.4.37内核
* chuck版重新调整内核参数,稳定性和性能有优化,待测试
* chuck版增加超频,有壳子就是任性不怕热

## 20200501
* chuck版改用大佬提供的cpu温度显示,移除autocore
* chuck版升级至5.4.36内核,新内核版本暂时标记为pre
* chuck版增加ramfree
* 恢复upnp
* 默认关闭wan口防火墙入站和转发
* 默认设置ssh仅lan口访问
* 默认关闭lan口dhcpv6
* 刷机脚本工作目录更改到overlay,不依赖是否挂载到mnt

## 20200430
* 首次发布
