#!/bin/sh

# 默认备份
backup=1
succes=0
# 在线or本地
echo -e '\e[92m请选择更新固件方式\e[0m'
echo -e '\e[92m  1.在线下载更新(默认)\e[0m'
echo -e '\e[92m  2.在线下载更新且跳过备份\e[0m'
echo -e '\e[92m  3.本地更新(固件上传至/tmp/upload目录)\e[0m'
echo -e '\e[92m  4.本地更新且跳过备份(固件上传至/tmp/upload目录)\e[0m'
read -p '请选择(1/2/3/4):' input
if [ $input -eq 3 ] || [ $input -eq 4 ]; then
	if [ -f /tmp/upload/R2S*.zip ]; then
		echo -e '\e[92m已找到固件文件，准备解压\e[0m'
		mv /tmp/upload/R2S*.zip /overlay
		cd /overlay
		if [ $input -eq 4 ]; then
			backup=0
		fi
	else
		echo -e '\e[92m没找到固件文件，脚本退出\e[0m'
		exit 1
	fi
else
	if [ $input -eq 2 ]; then
		backup=0
	fi
	echo -e '\e[92m请选择版本分支\e[0m'
	echo -e '\e[92m  1.DYC版(默认)\e[0m'
	echo -e '\e[92m  2.Chuck版\e[0m'
	read -p '请选择(1/2):' rom
	if [ $rom -eq 2 ]; then
		romtype='Chuck'
	else
		romtype='DYC'
	fi
	# 切换下载站点
	read -p '是否从镜像站点下载?(解决无科学上网情况下下载慢的问题, y or n):' mirror
	if [ "$mirror" = "y" ]; then
		url='https://git.msylgj.workers.dev/https://github.com'
		echo -e '\e[92m将从镜像站点下载\e[0m'
	else
		url='https://github.com'
		echo -e '\e[92m从Github主站下载\e[0m'
	fi
	# 下载固件
	cd /overlay
	rm -rf artifact R2S*.zip FriendlyWrt*img*
	wget $url/msylgj/NanoPi-R2S-OpenWrt/releases/download/R2S-OPoA-$romtype-$(date +%Y-%m-%d)/R2S-OPoA-$romtype-$(date +%Y-%m-%d)-ROM.zip
	if [ -f /overlay/R2S*.zip ]; then
		echo -e '\e[92m今天固件已下载，准备解压\e[0m'
	else
		echo -e '\e[91m今天的固件还没更新，尝试下载昨天的固件\e[0m'
		wget $url/msylgj/NanoPi-R2S-OpenWrt/releases/download/R2S-OPoA-$romtype-$(date -d "@$(( $(busybox date +%s) - 86400))" +%Y-%m-%d)/R2S-OPoA-$romtype-$(date -d "@$(( $(busybox date +%s) - 86400))" +%Y-%m-%d)-ROM.zip
		if [ -f /overlay/R2S*.zip ]; then
			echo -e '\e[92m昨天的固件已下载，准备解压\e[0m'
		else
			echo -e '\e[91m没找到最新的固件，脚本退出\e[0m'
			exit 1
		fi
	fi
fi
# 开始刷机
if [ -d /overlay/img ]; then
	echo -e '\e[92m清理文件夹\e[0m'
	umount /overlay/img
	losetup -D
	rm -rf /overlay/img
fi
unzip R2S*.zip
rm R2S*.zip
if [ -f /overlay/artifact/FriendlyWrt*.img.gz ]; then
	echo -e '\e[92m准备解压镜像文件\e[0m'
	succes=1
	pv /overlay/artifact/FriendlyWrt*.img.gz | gunzip -dc > FriendlyWrt.img
fi
if [ $succes -eq 1 ]; then
	if [ $backup -eq 1 ]; then
		lodev=$(losetup -f)
		mkdir /overlay/img
		losetup -o 100663296 $lodev /overlay/FriendlyWrt.img
		mount $lodev /overlay/img
		echo -e '\e[92m解压已完成，准备编辑镜像文件，写入备份信息\e[0m'
		cd /overlay/img
		sysupgrade -b /overlay/img/back.tar.gz
		tar zxf back.tar.gz
		echo -e '\e[92m备份文件已经写入，移除挂载\e[0m'
		rm back.tar.gz
		cd /tmp
		umount /overlay/img
		losetup -d $lodev
	else
		echo -e '\e[92m已跳过备份，将进行纯净安装\e[0m'
	fi
	echo -e '\e[92m准备重新打包\e[0m'
	zstdmt /overlay/FriendlyWrt.img -o /tmp/FriendlyWrtupdate.img.zst
	echo -e '\e[92m打包完毕，准备刷机\e[0m'
	if [ -f /tmp/FriendlyWrtupdate.img.zst ]; then
		echo 1 > /proc/sys/kernel/sysrq
		echo u > /proc/sysrq-trigger || umount /
		pv /tmp/FriendlyWrtupdate.img.zst | zstdcat | dd of=/dev/mmcblk0 conv=fsync
		echo -e '\e[92m刷机完毕，正在重启...\e[0m'
		echo b > /proc/sysrq-trigger
	fi
else
	echo -e '\e[92m镜像文件不匹配, 脚本退出\e[0m'
fi