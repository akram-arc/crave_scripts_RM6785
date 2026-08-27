#!/bin/bash

rm -rf .repo/local_manifests/
rm -rf vendor/gms
rm -rf device/realme
rm -rf kernel/realme
rm -rf vendor/realme
rm -rf device/mediatek/sepolicy_vndr
rm -rf hardware/mediatek
rm -rf .repo/project-objects/

# Local TimeZone
sudo rm -rf /etc/localtime
sudo ln -s /usr/share/zoneinfo/Asia/Dhaka /etc/localtime


# repo init rom
repo init --depth=1 -u https://github.com/LineageOS/android.git -b lineage-23.2 --git-lfs
echo "=================="
echo "Repo init success"
echo "=================="

# Local manifests
git clone https://github.com/realme-mt6785-devs/local_manifests.git .repo/local_manifests
echo "============================"
echo "Local manifest clone success"
echo "============================"

# Build Sync
/opt/crave/resync.sh 
echo "============="
echo "Sync success"
echo "============="

# Export
export BUILD_USERNAME=Akram 
export BUILD_HOSTNAME=crave
echo "======= Export Done ======"

# Locked lk patches
echo ">>> Cherry picking Locked lk patches..."
cd system/core
git remote add akram-arc https://github.com/akram-arc/android_system_core.git 2>/dev/null || true
git fetch akram-arc
git cherry-pick 4d55070a72e649c5d0615b84dc10183463f926a8 d72b2f13cc8906c3de6e22055de7ad8c05410ac3 52bcc2864705ea77f0eb6a6a41756d26943465cd
cd ../..

# Set up build environment
source build/envsetup.sh
echo "============="

# Lunch
breakfast RM6785

# Build
brunch RM6785

