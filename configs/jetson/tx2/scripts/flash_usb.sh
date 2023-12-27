#!/bin/bash
set -eo pipefail

if [ $EUID != 0 ]; then
  echo "This script requires root, so it might not work."
  echo "Run in sudo bash if you have any issues."
fi

if [ "$SKIFF_NVIDIA_USB_FLASH" != "confirm" ]; then
    echo "Set SKIFF_NVIDIA_USB_FLASH=confirm to confirm you want to USB-flash to your board."
    echo "Warning: this may overwrite existing data."
    exit 1
fi

IMAGES_DIR=$BUILDROOT_DIR/images

uimg_path=$IMAGES_DIR/Image
if [ ! -f "$uimg_path" ]; then
  echo "Image not found, make sure Buildroot is done compiling."
  exit 1
fi

flash_path=$IMAGES_DIR/linux4tegra/flash.sh
if [ ! -f $flash_path ]; then
    echo "linux4tegra flash.sh not found, ensure buildroot is done compiling."
    exit 1
fi

cd ${IMAGES_DIR}/linux4tegra

# kernel args
export EXTRA_KERNEL_FLAGS="net.ifnames=0 printk.devkmsg=on"

# disable recovery image
export NO_RECOVERY_IMG=1

# operating mode #1: kernel in partition, buildroot rootfs as mutable /
# (legacy)
if [ -n "$TX2_MUTABLE_ROOTFS" ]; then
    echo "Using legacy mutable rootfs approach..."
    bash $flash_path \
         -I $IMAGES_DIR/rootfs.ext2 \
         -K $IMAGES_DIR/Image \
         -L $IMAGES_DIR/u-boot.bin \
         -C "${EXTRA_KERNEL_FLAGS}" \
         -d $IMAGES_DIR/tegra186-quill-p3310-1000-c03-00-base.dtb \
         jetson-tx2-devkit mmcblk0p1
    exit $?
fi

# operating mode #2: standard SkiffOS u-boot system
# everything stored in one partition (persist)
# using /boot bind-mounted to /mnt/boot
echo "Using skiffos.ext2 as APP partition with u-boot..."
ln -fs $IMAGES_DIR/skiffos.ext2 ./bootloader/system.img
bash $flash_path \
     -r \
     -C "${EXTRA_KERNEL_FLAGS}" \
     -L $IMAGES_DIR/u-boot.bin \
     -d $IMAGES_DIR/tegra186-quill-p3310-1000-c03-00-base.dtb \
     jetson-tx2-devkit mmcblk0p1
