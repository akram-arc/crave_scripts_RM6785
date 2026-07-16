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
git clone  https://github.com/akram-arc/local_manifests.git .repo/local_manifests
echo "============================"
echo "Local manifest clone success"
echo "============================"

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
git cherry-pick 7f1122ca7fcfacbc3fb2b81500aabe2e84a39ab5
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
