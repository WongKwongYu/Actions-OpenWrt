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

# 更新 golang 版本
#rm -rf feeds/packages/lang/golang
#git clone https://github.com/kenzok8/golang -b 1.26 feeds/packages/lang/golang
# 1. 确定需要升级的目标版本
GO_VERSION="1.26.0"
# 2. 下载并替换系统 Go 工具链
# GitHub Actions 环境通常有 sudo 权限，且默认 Go 安装在 /usr/local/go
echo "正在升级 Go 到 $GO_VERSION..."
curl -L https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz -o go.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go.tar.gz
rm -f go.tar.gz
# 3. 强制刷新环境变量并设置工具链模式
# 这一步确保后续编译进程能识别到新版本
export PATH=/usr/local/go/bin:$PATH
export GOTOOLCHAIN=go${GO_VERSION}
# 4. 验证版本（这一步会在 Action 日志中打出版本，方便调试）
go version
# 5. (关键) 为了确保后续的 make 进程也能读取到这个环境变量
# 我们将路径写入当前用户的环境变量配置文件中
echo "export PATH=/usr/local/go/bin:\$PATH" >> ~/.bashrc
echo "export GOTOOLCHAIN=go${GO_VERSION}" >> ~/.bashrc

# 移除 openwrt feeds 自带的核心库
rm -rf feeds/packages/net/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,trojan-plus,tuic-client,v2ray-plugin,xray-plugin,geoview,shadow-tls}
git clone https://github.com/Openwrt-Passwall/openwrt-passwall-packages package/passwall-packages

# 移除 openwrt feeds 过时的luci版本
rm -rf feeds/luci/applications/luci-app-passwall
git clone https://github.com/Openwrt-Passwall/openwrt-passwall package/passwall-luci
