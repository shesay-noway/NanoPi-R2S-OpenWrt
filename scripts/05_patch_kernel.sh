#!/bin/bash
#内核变基到linux5.4.y
cd kernel
git config --local user.email "action@github.com" && git config --local user.name "GitHub Action"
git remote add upstream https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git && git fetch upstream
git rebase upstream/linux-5.4.y
cd ../
#解锁1.5G
cd kernel
wget https://github.com/armbian/build/raw/master/patch/kernel/rockchip64-dev/RK3328-enable-1512mhz-opp.patch
git apply RK3328-enable-1512mhz-opp.patch
cd ../
#用openwrt的patch优化默认linux内核的性能表现
git clone https://git.openwrt.org/openwrt/openwrt.git --depth=1
cd openwrt
./scripts/patch-kernel.sh ../kernel ./target/linux/generic/backport-5.4
./scripts/patch-kernel.sh ../kernel ./target/linux/generic/pending-5.4
./scripts/patch-kernel.sh ../kernel ./target/linux/generic/hack-5.4
./scripts/patch-kernel.sh ../kernel ./target/linux/octeontx/patches-5.4
cp -a ./target/linux/generic/files/* ../kernel/
cd ../
#替换fanck0605优化后的内核配置
cd kernel/
rm -f ./arch/arm64/configs/nanopi-r2_linux_defconfig
cat ../../config/nanopi-r2_linux_defconfig > ./arch/arm64/configs/nanopi-r2_linux_defconfig
#启用fullcone内核模块
wget -O net/netfilter/xt_FULLCONENAT.c https://raw.githubusercontent.com/Chion82/netfilter-full-cone-nat/master/xt_FULLCONENAT.c
git apply ../../patches/001-kernel-add-full_cone_nat.patch
exit 0
