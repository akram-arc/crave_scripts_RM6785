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
git cherry-pick a83ee9ce71c49e860c90c7cd17accc3834811e9e a7412e9affdc139b9fd3ae1e2b6577cd7d335540
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
git cherry-pick bf1f04383176d6cf9fd1cef19ef31663ab8ce1d9 850581e22afa47e3c958e4cb637374aceb789154 7c2acb070646d0cc6572133cd2862dc49d984b4e a16fb0d01d4bd6b8399f0804ffcda7b6e09e270e 8c092990466e10b0feb0ea6e5ae0f79cf3460375 2e284640f07ca4ad83b9a88766ad02788dfd366d 7370cf80ff25f46c978019345e25c3be79b39945 9b066176d6f007b5fcac0fc497364ac3af3039ea fd447c4857bcf60790e7218265722b207f877163 dcb717372ab930d01eacb01ddbf68226acbb0bb5
cd ../..

# sdk patches
echo ">>> Cherry picking sdk patches..."
cd lineage-sdk
git remote add akram-arc https://github.com/akram-arc/android_lineage-sdk.git 2>/dev/null || true
git fetch akram-arc
git cherry-pick f9329886c332783d191c6ac08f5e3f8fd849fb62 b2ebaf25b11156f43b689fef173e9f95d117d38d 8233504dfc613a0041c57925998f3bc03ab74df6 35e36fcb152d7fbc949c03fc9fd6dc3fc974c956 36bd1cc390a0321796d8237e071fb0def8b8d3d5 0de890eda8570aa4b69e0604878896b96796d788
cd ..

# LineageParts patches
echo ">>> Cherry picking LineageParts patches..."
cd packages/apps/LineageParts
git remote add akram-arc https://github.com/akram-arc/android_packages_apps_LineageParts.git 2>/dev/null || true
git fetch akram-arc
git cherry-pick 74dcee8186a32d8a801a04ad0f0b45ab1421b11a c891e4c101c65e302d6b6545bc5fa75f0e6157fe 9374e946053953fb65ab88638597c9518fac2453 9823a38572d62ce139c9f99fc23f48ba16054234 04b7601e011ef17761d5986355ce653e480a5c60 94abfc10435afe483bf948e88faf62d902228064 ebd91b76a53bf0313e515a834c09228153fba91a 35b8fee7fadeda7a1c4a8d46f13287b3e870679a 36e139c01d19c05d8d65d9f022e84b8216651e9a 8e30960c2ac8b891bbafd2a2b2bd60e09fab8782 a0d6aa9035bc47ee6176b8bc0763e9fb038f2e2d
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
