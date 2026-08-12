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
git cherry-pick 09c7e531ac25a9fe4f8be41bd026c0ebb4e59200
cd ../../..

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

# Base patches
echo ">>> Cherry picking base patches..."
cd frameworks/base
git remote add akram-arc https://github.com/akram-arc/android_frameworks_base.git 2>/dev/null || true
git fetch akram-arc
git cherry-pick bf1f04383176d6cf9fd1cef19ef31663ab8ce1d9 850581e22afa47e3c958e4cb637374aceb789154 7c2acb070646d0cc6572133cd2862dc49d984b4e a16fb0d01d4bd6b8399f0804ffcda7b6e09e270e 9f3842010d0f7df810943e966dc9aeebfb3c61f6
cd ../..

# sdk patches
echo ">>> Cherry picking sdk patches..."
cd lineage-sdk
git remote add akram-arc https://github.com/akram-arc/android_lineage-sdk.git 2>/dev/null || true
git fetch akram-arc
git cherry-pick f9329886c332783d191c6ac08f5e3f8fd849fb62 b2ebaf25b11156f43b689fef173e9f95d117d38d 8233504dfc613a0041c57925998f3bc03ab74df6 a48de9dc229e831f5697781bf86ab5a0bffc81fa 24ac6800e10ebc5d62ec1094e4bdb85568e632aa
cd ..

# LineageParts patches
echo ">>> Cherry picking LineageParts patches..."
cd packages/apps/LineageParts
git remote add akram-arc https://github.com/akram-arc/android_packages_apps_LineageParts.git 2>/dev/null || true
git fetch akram-arc
git cherry-pick 4053b9f39bc101f68f8ff254ce22e47363af13ed 8ec5af9f0a752da870b77e23dfa52e1f204c214a 103db00b160c99c4bf018aa0c7acb1fe8c386a23 b48bf30af8c2d8e0aa87ae05918c31daf6a86af5
cd ../../..

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
