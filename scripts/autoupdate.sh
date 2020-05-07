#!/bin/sh

rom=0; 	#rom值若为0，则会出现可选菜单，也可手动改为1-3，将不会出现选项
backup=0; 	#backup值若为0，则会出现可选菜单，也可手动改为1-3，将不会出现选项
mode=0; 	#mode值若为0，则会出现可选菜单，也可手动改为1-3，将不会出现选项
suffix=1; 	#判定升级文件名后缀，无需改动，保持1即可
while [ $rom -eq 0 ]
	do
		echo
		echo "...........欢迎使用 R2S 一键升级脚本.........."
		echo " 1. 升级Chuck版"
		echo
		echo " 2. 升级QiuSimons版"
		echo
		echo " 3. 本地升级（固件以R2S*.zip或Friendly*.img.gz格式放在/tmp/upload目录，优先判定zip格式）"
		echo
		echo " 4. 输入zip格式固件下载地址"
		echo
		echo " 5. 输入img.gz格式固件下载地址"
		echo
		echo " 6. 退出"
		echo
		read -p "$(echo -e "请选择 [\e[95m1-6\e[0m]:")" rom
		case $rom in
		1)
			rom=1;;
		2)
			rom=2;;
		3)
			rom=3;;
		4)
			rom=4
			read -p "$(echo -e "\e[92m请输入固件下载地址\e[0m:")" address
			;;
		5)
			rom=5
			read -p "$(echo -e "\e[92m请输入固件下载地址\e[0m:")" address
			;;
		6)
			exit 1
			;;
		*)
			rom=0
			echo
			echo -e '\e[91m输入错误，请重新输入\e[0m'
			;;
		esac
	done

while [ $backup -eq 0 ]
	do
		echo
		echo "...........欢迎使用 R2S 一键升级脚本.........."
		echo " 1. 升级保留配置（同系列的固件直接升级推荐使用）"
		echo
		echo " 2. 特殊保留模式（只保留网口配置、防火墙、端口转发、DDNS和SSRP的数据，方便跨版本刷机）"
		echo
		echo " 3. 升级不保留配置"
		echo
		echo
		read -p "$(echo -e "请选择 [\e[95m1-3\e[0m]，默认为1:")" backup
		[[ -z $backup ]] && backup="1"
		case $backup in
		1)
			backup=1;;
		2)
			backup=2;;
		3)
			backup=3;;
		*)
			backup=0
			echo
			echo -e '\e[91m输入错误，请重新输入\e[0m'
			;;
		esac
	done

while [ $mode -eq 0 ]
	do
		echo
		echo "...........欢迎使用 R2S 一键升级脚本.........."
		echo " 1. 使用pigz刷机（速度更快）"
		echo
		echo " 2. 使用zstd刷机（理论上，更新成功率更高）"
		echo
		echo " 3. 不刷机，只保留上述修改的刷机文件（可以此制作适合自己已保留配置的刷机镜像，卡刷时救砖用）"
		echo
		echo
		read -p "$(echo -e "请选择 [\e[95m1-3\e[0m]，默认为3:")" mode
		[[ -z $mode ]] && mode="3"
		case $mode in
		1)
			mode=1;;
		2)
			mode=2;;
		3)
			mode=3;;
		*)
			mode=0
			echo
			echo -e '\e[91m输入错误，请重新输入\e[0m'
			;;
		esac
	done

cd /overlay
echo '检查依赖文件...'
if ! type "unzip" > /dev/null; then
	opkg update ; opkg install unzip
	if ! type "unzip" > /dev/null; then
		echo 'unzip安装失败，退出...'
		exit 1
	fi
fi
if ! type "pv" > /dev/null; then
	opkg update ; opkg install pv
	if ! type "pv" > /dev/null; then
		echo 'pv安装失败，退出...'
		exit 1
	fi
fi
if ! type "losetup" > /dev/null; then
	opkg update ; opkg install losetup
	if ! type "losetup" > /dev/null; then
		echo 'losetup安装失败，退出...'
		exit 1
	fi
fi
if [ $mode -eq 1 ] || [ $mode -eq 3 ]; then
	if ! type "pigz" > /dev/null; then
		if [ -f /www/pigz_2.4-1_aarch64_cortex-a53.ipk ]; then
		opkg install /www/pigz_2.4-1_aarch64_cortex-a53.ipk
		elif [ -f /tmp/upload/pigz_2.4-1_aarch64_cortex-a53.ipk ]; then
		opkg install /www/pigz_2.4-1_aarch64_cortex-a53.ipk
		else
			rm pigz_2.4-1_aarch64_cortex-a53.ipk
			wget https://github.com/lsl330/R2S-SCRIPTS/raw/master/pigz_2.4-1_aarch64_cortex-a53.ipk
			opkg install pigz_2.4-1_aarch64_cortex-a53.ipk
			cp pigz_2.4-1_aarch64_cortex-a53.ipk /www
		fi
		if ! type "pigz" > /dev/null; then
			echo 'pigz安装失败，退出...'
			exit 1
		fi
	fi
fi
if [ $mode -eq 2 ]; then
	if ! type "zstd" > /dev/null; then
		opkg update ; opkg install zstd
		if ! type "zstd" > /dev/null; then
			echo 'zstd安装失败，退出...'
			exit 1
		fi
	fi
fi

rm -rf artifact R2S*.zip FriendlyWrt*img*

if [ $rom -eq 1 ]; then	#下载Chuck固件
	wget https://github.com/msylgj/NanoPi-R2S-OpenWrt/releases/download/R2S-OPoA-Chuck-$(date +%Y-%m-%d)/R2S-OPoA-Chuck-$(date +%Y-%m-%d)-ROM.zip
	if [ -f /overlay/R2S*.zip ]; then
		echo -e '\e[92m今天固件已下载，准备解压\e[0m'
	else
		echo '今天的固件还没更新，尝试下载昨天的固件'
		wget https://github.com/msylgj/NanoPi-R2S-OpenWrt/releases/download/R2S-OPoA-Chuck-$(date -d "@$(( $(busybox date +%s) - 86400))" +%Y-%m-%d)/R2S-OPoA-Chuck-$(date -d "@$(( $(busybox date +%s) - 86400))" +%Y-%m-%d)-ROM.zip
		if [ -f /overlay/R2S*.zip ]; then
			echo -e '\e[92m昨天的固件已下载，准备解压\e[0m'
		else
			echo -e '\e[91m没找到最新的固件，脚本退出\e[0m'
			exit 1
		fi
	fi
fi

if [ $rom -eq 2 ]; then	#下载QiuSimons固件
	wget https://github.com/msylgj/NanoPi-R2S-OpenWrt/releases/download/R2S-OPoA-QiuSimons-$(date +%Y-%m-%d)/R2S-OPoA-QiuSimons-$(date +%Y-%m-%d)-ROM.zip
	if [ -f /overlay/R2S*.zip ]; then
		echo -e '\e[92m今天固件已下载，准备解压\e[0m'
	else
		echo '今天的固件还没更新，尝试下载昨天的固件'
		wget https://github.com/msylgj/NanoPi-R2S-OpenWrt/releases/download/R2S-OPoA-QiuSimons-$(date -d "@$(( $(busybox date +%s) - 86400))" +%Y-%m-%d)/R2S-OPoA-QiuSimons-$(date -d "@$(( $(busybox date +%s) - 86400))" +%Y-%m-%d)-ROM.zip
		if [ -f /overlay/R2S*.zip ]; then
			echo -e '\e[92m昨天的固件已下载，准备解压\e[0m'
		else
			echo -e '\e[91m没找到最新的固件，脚本退出\e[0m'
			exit 1
		fi
	fi
fi

if [ $rom -eq 3 ]; then	#上传本地rom
	if [ -f /tmp/upload/R2S*.zip ]; then  #检测upload目录是否有zip升级文件
		echo -e '\e[92m找到本地固件，准备解压\e[0m'
		mv /tmp/upload/R2S*.zip /overlay/
	elif [ -f /tmp/upload/Friendly*.img.gz ]; then	 #检测upload目录是否有img.gz升级文件
		suffix=2
		mv /tmp/upload/Friendly*.img.gz /overlay/FriendlyWrt-ROM.img.gz
	elif [ -f /overlay/R2S*.zip ]; then  #检测upload目录是否有升级文件
		echo -e '\e[92m找到本地固件，准备解压\e[0m'
	else
		echo -e '\e[91m没找到本地固件，脚本退出\e[0m'
		exit 1
	fi
fi

if [ $rom -eq 4 ]; then	#指定下载地址
	wget $address -O /overlay/R2S-ROM.zip
	if [ -f /overlay/R2S*.zip ]; then
		echo -e '\e[92m固件已下载，准备解压\e[0m'
	else
		echo -e '\e[91m指定位置没找到固件，脚本退出\e[0m'
		exit 1
	fi
fi

if [ $rom -eq 5 ]; then	#指定下载地址
	wget $address -O /overlay/FriendlyWrt-ROM.img.gz
	if [ -f /overlay/FriendlyWrt-ROM.img.gz ]; then
		suffix=2
		echo -e '\e[92m固件已下载，准备解压\e[0m'
	else
		echo -e '\e[91m指定位置没找到固件，脚本退出\e[0m'
		exit 1
	fi
fi

if [ $suffix -eq 1 ]; then	#zip格式固件，进行解压
	unzip R2S*.zip
	rm R2S*.zip
fi

if [ -f /overlay/artifact/FriendlyWrt*.img.gz ]; then  #统一解压固件路径
	pv /overlay/artifact/FriendlyWrt*.img.gz | gunzip -dc > FriendlyWrt.img
	echo -e '\e[92m准备解压镜像文件\e[0m'
elif [ -f /overlay/FriendlyWrt*.img.gz ]; then
	pv /overlay/FriendlyWrt*.img.gz | gunzip -dc > FriendlyWrt.img
	echo -e '\e[92m准备解压镜像文件\e[0m'
fi
lodev=$(losetup -f)
mkdir /overlay/img
losetup -o 100663296 $lodev /overlay/FriendlyWrt.img
mount $lodev /overlay/img
echo -e '\e[92m解压已完成，准备编辑镜像文件，写入备份信息\e[0m'
cd /overlay/img
if [ $backup -eq 1 ]; then
	sysupgrade -b /overlay/img/back.tar.gz
	tar zxf back.tar.gz
	echo -e '\e[92m备份文件已经写入，移除挂载\e[0m'
	rm back.tar.gz
elif [ $backup -eq 2 ]; then
	cp -f /etc/config/network /overlay/img/etc/config/; #网络配置文件
	rm -rf /overlay/img/etc/board.d
	cp -f /etc/board.d /overlay/img/etc/
	cp -f /etc/board.json /overlay/img/etc/
	cp -f /etc/config/aria2 /overlay/img/etc/config/; #aria2配置文件
	cp -f /etc/config/ddns /overlay/img/etc/config/; #ddns配置文件
	cp -f /etc/config/frps /overlay/img/etc/config/; #frps配置文件
	cp -f /etc/passwd /overlay/img/etc/; #账号文件配置文件
	cp -f /etc/shadow /overlay/img/etc/; #账号密码配置文件
	cp -f /etc/config/firewall /overlay/img/etc/config/; #防火墙及端口转发配置文件
	cp -f /etc/config/shadowsocksr /overlay/img/etc/config/; #ssrp配置文件
	cp -f /etc/config/netflixip.list /overlay/img/etc/config/; #ssrp配置文件
	cp -f /etc/china_ssr.txt /overlay/img/etc/; #ssrp配置文件
	mkdir /overlay/img/etc/dnsmasq.ssr; #ssrp配置文件
	cp -f /etc/dnsmasq.ssr/gfw_list.conf /overlay/img/etc/dnsmasq.ssr/; #ssrp配置文件
else
	echo -e '\e[92m升级文件已经写入，移除挂载\e[0m'
fi
cd /tmp
umount /overlay/img
losetup -d $lodev
echo -e '\e[92m准备重新打包\e[0m'
if [ $mode -eq 3 ]; then
	mkdir /tmp/upload
	pv /overlay/FriendlyWrt.img | pigz > /tmp/upload/FriendlyWrtupdate.img.gz
	echo -e '\e[92m刷机镜像已保存在/tmp/upload目录，请及时导出\e[0m'
	exit 1
fi
if [ $mode -eq 1 ]; then
	pv /overlay/FriendlyWrt.img | pigz --fast > /tmp/FriendlyWrtupdate.img.gz
else
	zstdmt /overlay/FriendlyWrt.img -o /tmp/FriendlyWrtupdate.img.zst
fi
echo -e '\e[92m打包完毕，准备刷机\e[0m'
if [ -f /tmp/FriendlyWrtupdate.img.gz ]; then
	echo 1 > /proc/sys/kernel/sysrq
	echo u > /proc/sysrq-trigger || umount /
	pv /tmp/FriendlyWrtupdate.img.gz | gunzip -dc > /dev/mmcblk0
	echo -e '\e[92m刷机完毕，正在重启...\e[0m'
	echo b > /proc/sysrq-trigger
fi
if [ -f /tmp/FriendlyWrtupdate.img.zst ]; then
	echo 1 > /proc/sys/kernel/sysrq
	echo u > /proc/sysrq-trigger || umount /
	pv /tmp/FriendlyWrtupdate.img.zst | zstdcat | dd of=/dev/mmcblk0 conv=fsync
	echo -e '\e[92m刷机完毕，正在重启...稍等片刻后重新登录\e[0m'
	echo b > /proc/sysrq-trigger
fi