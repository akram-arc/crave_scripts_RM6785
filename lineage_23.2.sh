#!/bin/bash

rm -rf .repo/local_manifests/
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
repo init -u https://github.com/LineageOS/android.git -b lineage-23.2 --git-lfs
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

# Export
export BUILD_USERNAME=Akram 
export BUILD_HOSTNAME=crave
echo "======= Export Done ======"


# Set up build environment
source build/envsetup.sh
echo "============="

# Lunch
breakfast RM6785

# Build
brunch RM6785

