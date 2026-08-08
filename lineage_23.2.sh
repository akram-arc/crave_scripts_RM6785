#!/bin/bash

rm -rf .repo/local_manifests/
rm -rf vendor/gms
rm -rf device/realme
rm -rf kernel/realme
rm -rf vendor/realme/RM6785
rm -rf device/mediatek/sepolicy_vndr
rm -rf hardware/mediatek

# Local TimeZone
sudo rm -rf /etc/localtime
sudo ln -s /usr/share/zoneinfo/Asia/Dhaka /etc/localtime


# repo init rom
repo init --depth=1 -u https://github.com/LineageOS/android.git -b lineage-23.2 --git-lfs
echo "=================="
echo "Repo init success"
echo "=================="

# Local manifests
git clone https://github.com/akram-arc/local_manifests.git .repo/local_manifests
echo "============================"
echo "Local manifest clone success"
echo "============================"

echo "============="
echo "Repo Syncing "
echo "============="

# Build Sync
/opt/crave/resync.sh 
echo "============="
echo "Sync success"
echo "============="

# Media Patches (frameworks/av)
echo ">>> Cherry picking Media patches..."
cd frameworks/av
git remote add akram-arc https://github.com/akram-arc/android_frameworks_av.git 2>/dev/null || true
git fetch akram-arc
git cherry-pick e1324be91d82c47cd632dc0cbeaeedcfcbd11c80 1d6ac760928140d361c23b2ca2862622d9ab9e78 c8db8c1671ee9bf4f8409a5c7c565acb47dfd053 3748303946dee31bf0d3e8dfb3bc2085cb533c21
cd ../..

# Updater Patch
echo ">>> Cherry picking Updater patch..."
cd packages/apps/Updater
git remote add akram-arc https://github.com/akram-arc/android_packages_apps_Updater.git 2>/dev/null || true
git fetch akram-arc
git cherry-pick 73119d3ce53b620ce681cd089cb55a8353caaaf8
cd ../../..

# CTS patches
echo ">>> Cherry picking CTS patches..."
cd vendor/lineage
git remote add akram-arc https://github.com/akram-arc/android_vendor_lineage.git 2>/dev/null || true
git fetch akram-arc
git cherry-pick 39a3e37c772f9e3803da67625fb818494ce50d43
cd ../..

# Settings Patch
echo ">>> Cherry picking Settings patch..."
cd packages/apps/Settings/
git remote add akram-arc https://github.com/akram-arc/android_packages_apps_Settings.git 2>/dev/null || true
git fetch akram-arc
git cherry-pick 60a0738d4b32f86dbf71b76cc351b7874b160885 4159020efff3e07375933aa70433117efb2fac75 66bfc1b3e49ef220e34f7682748a8dd4efe6ff61
cd ../../..

# Base Patch
echo ">>> Cherry picking Bash patch..."
cd frameworks/base
git remote add akram-arc https://github.com/akram-arc/android_frameworks_base.git 2>/dev/null || true
git fetch akram-arc
git cherry-pick 65ce9f45432786159e59bf3b5e7c6cd4fd759271 38cfff20438d0af01cde457c14e0b8eb6638eadd
cd ../..

# Launcher Patch
echo ">>> Cherry picking Settings patch..."
cd packages/apps/Launcher3
git remote add akram-arc https://github.com/akram-arc/android_packages_apps_Launcher3.git 2>/dev/null || true
git fetch akram-arc
git cherry-pick 46b05b795e084f5c159c7c42346c37d76831baa6
cd ../../..

# Locked lk patches
echo ">>> Cherry picking Locked lk patches..."
cd system/core
git remote add akram-arc https://github.com/akram-arc/android_system_core.git 2>/dev/null || true
git fetch akram-arc
git cherry-pick 4d55070a72e649c5d0615b84dc10183463f926a8 d72b2f13cc8906c3de6e22055de7ad8c05410ac3 52bcc2864705ea77f0eb6a6a41756d26943465cd
cd ../..

echo "====================="
echo "All Cherry picks Done"
echo "====================="

# Export
export BUILD_USERNAME=Akram 
export BUILD_HOSTNAME=crave
echo "======= Export Done ======="


# Set up build environment
source build/envsetup.sh
echo "============="

# Lunch
breakfast RM6785
echo "============="

# Make cleaninstall
make installclean
echo "============="

# Build
brunch RM6785
