#!/bin/sh

BOOT_IMAGE="boot.img"

# ====================================
# 
# ====================================
if [ -f "$BOOT_IMAGE" ]; then
    echo "$BOOT_IMAGE exists."
else
    echo "$BOOT_IMAGE does not exist."
    echo "Creating boot.img"
    dd if=/dev/zero of=boot.img bs=1m count=512
    sudo mkfs.vfat boot.img
fi

# ====================================
# 
# ====================================
hdiutil attach -nomount boot.img
mount -t msdos /dev/disk4 tmp/
mkdir tmp/efi/boot
cp edk2/Build/MdeModule/DEBUG_GCC5/X64/HelloWorld.efi tmp/efi/boot/bootx64.efi
umount tmp/  
hdiutil detach /dev/disk4

# ====================================
# 
# ====================================
qemu-system-x86_64 -bios edk2/Build/OvmfX64/DEBUG_GCC5/FV/OVMF.fd -net none -m 8G -vga std -drive format=raw,file=boot.img
