#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.22.1/g' package/base-files/files/bin/config_generate

# Modify filename, add date prefix
sed -i 's/IMG_PREFIX:=/IMG_PREFIX:=$(shell date +"%Y%m%d")-/1' include/image.mk

# 备用科学插件：移除 openwrt feeds 自带的核心包
#rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box}
#git clone https://github.com/sbwml/openwrt_helloworld package/helloworld
# 更新 golang 1.25 版本
#rm -rf feeds/packages/lang/golang
#git clone https://github.com/sbwml/packages_lang_golang -b 25.x feeds/packages/lang/golang
rm -rf feeds/packages/lang/golang
git clone https://github.com/openwrt/packages  -b master lang/golang

# passwall官方方法：移除 openwrt feeds 自带的核心库
rm -rf feeds/packages/net/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,trojan-plus,tuic-client,v2ray-plugin,xray-plugin,geoview,shadow-tls}
git clone https://github.com/xiaorouji/openwrt-passwall-packages package/passwall-packages
# 移除 openwrt feeds 过时的luci版本
rm -rf feeds/luci/applications/luci-app-passwall
git clone https://github.com/xiaorouji/openwrt-passwall package/passwall-luci
