#!/bin/bash
clear
#拉取friendlywrt的源码
mkdir friendlywrt-rk3328
cd friendlywrt-rk3328
repo init -u https://github.com/friendlyarm/friendlywrt_manifests -b master-v19.07.1 -m rk3328.xml --repo-url=https://github.com/friendlyarm/repo --no-clone-bundle --depth=1
repo sync -c --no-tags --no-clone-bundle -j8
cd friendlywrt/ && git fetch --unshallow
cd ..
cd kernel/ && git fetch --unshallow
cd ..
#调整friendlywrt的更新源，取消不安全的防火墙设定
latest_feed="$(curl -s https://github.com/openwrt/openwrt/releases |grep -Eo "v[0-9\.]+.tar.gz" |sed -n 1p |sed 's/v//g' |sed 's/.tar.gz//g')"
sed -i 's,19.07.1,'"${latest_feed}"',g' device/friendlyelec/rk3328/common-files/etc/opkg/distfeeds.conf
sed -i 's/downloads.openwrt.org/mirrors.cloud.tencent.com/g' device/friendlyelec/rk3328/common-files/etc/opkg/distfeeds.conf
sed -i 's,ACCEPT,REJECT,g' device/friendlyelec/rk3328/default-settings/install.sh
#去除不必要的操作
sed -i 's,./scripts,#./scripts,g' scripts/mk-friendlywrt.sh
#变基friendlywrt到官方1907分支
cd friendlywrt
git config --local user.email "action@github.com" && git config --local user.name "GitHub Action"
git remote add upstream https://github.com/openwrt/openwrt.git && git fetch upstream
git rebase upstream/openwrt-19.07
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
#删除不必要的文件
rm -f ./include/version.mk
rm -f ./package/base-files/image-config.in
rm -f ./feeds.conf.default
wget https://raw.githubusercontent.com/openwrt/openwrt/openwrt-19.07/feeds.conf.default
rm -f ./package/base-files/files/etc/banner
rm -f ./package/base-files/files/bin/config_generate
sed -i 's,performance,ondemand,g' target/linux/rockchip-rk3328/base-files/etc/init.d/fa-rk3328-misc
cd ..
#准备openwrt release tag的源码
mkdir opofficial
latest_release="$(curl -s https://github.com/openwrt/openwrt/releases |grep -Eo "v[0-9\.]+.tar.gz" |sed -n 1p)"
curl -LO "https://github.com/openwrt/openwrt/archive/${latest_release}"
tar zxvf ${latest_release}  --strip-components 1 -C ./opofficial
#恢复部分文件到release分支
cp -f ./opofficial/include/version.mk ./friendlywrt/include/version.mk
cp -f ./opofficial/package/base-files/image-config.in ./friendlywrt/package/base-files/image-config.in
cp -f ./opofficial/package/base-files/files/etc/banner ./friendlywrt/package/base-files/files/etc/banner
cp -f ./opofficial/package/base-files/files/bin/config_generate ./friendlywrt/package/base-files/files/bin/config_generate
cd ..
#为下一步做准备
rm -rf ./scripts/.git
cp -f ./scripts/02_prepare_package.sh ./friendlywrt-rk3328/friendlywrt/
cp -f ./scripts/03_convert_translation.sh ./friendlywrt-rk3328/friendlywrt/
cp -f ./scripts/04_remove_upx.sh ./friendlywrt-rk3328/friendlywrt/
cp -f ./scripts/05_patch_kernel.sh ./friendlywrt-rk3328/05_patch_kernel.sh
exit 0
