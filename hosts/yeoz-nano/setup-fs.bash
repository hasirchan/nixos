#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <device>"
  exit 1
fi

DEVICE="$1"

echo "[WARNING] This will erase all data on ${DEVICE}."
read -p "Type 'yes' to continue: " CONFIRM
[[ "$CONFIRM" == "yes" ]] || { echo "Aborted."; exit 1; }

echo "[INFO] Wiping existing partition table..."
sgdisk --zap-all "$DEVICE"

# Create partitions
echo "[INFO] Creating partitions..."
sgdisk -n 1:0:+2G   -t 1:ef00 -c 1:"EFI System" "$DEVICE"
sgdisk -n 2:0:+233G -t 2:8300 -c 2:"home"       "$DEVICE"
sgdisk -n 3:0:+233G -t 3:8300 -c 3:"btrfs-root" "$DEVICE"
sgdisk -n 4:0:0     -t 4:8200 -c 4:"swap"       "$DEVICE"

partprobe "$DEVICE"
sleep 2

echo "[INFO] Formatting partitions..."
mkfs.vfat -F32 "${DEVICE}p1"
mkfs.btrfs -f "${DEVICE}p2"
mkfs.btrfs -f "${DEVICE}p3"
mkswap "${DEVICE}p4" || echo "[WARN] Swap creation failed or skipped."

# Create root subvolumes
echo "[INFO] Creating Btrfs subvolumes on partition 3..."
mount "${DEVICE}p3" /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/log
btrfs subvolume create /mnt/persist
umount /mnt

# Create home subvolume
echo "[INFO] Creating Btrfs subvolume on home partition..."
mount "${DEVICE}p2" /mnt
btrfs subvolume create /mnt/home
umount /mnt

# Mount subvolumes from root partition
echo "[INFO] Mounting subvolumes..."
mount -o subvol=root,compress=zstd,noatime "${DEVICE}p3" /mnt
mkdir -p /mnt/boot /mnt/home /mnt/nix /mnt/var/log /mnt/persist

mount -o subvol=nix,compress=zstd,noatime "${DEVICE}p3" /mnt/nix
mount -o subvol=log,compress=zstd,noatime "${DEVICE}p3" /mnt/var/log
mount -o subvol=persist,compress=zstd,noatime "${DEVICE}p3" /mnt/persist

# Mount home partition
echo "[INFO] Mounting /boot and /home..."
mount "${DEVICE}p1" /mnt/boot
mount -o subvol=home,compress=zstd,noatime "${DEVICE}p2" /mnt/home

# Enable swap
if [ -e "${DEVICE}p4" ]; then
  swapon "${DEVICE}p4"
  echo "[INFO] Swap partition enabled."
else
  echo "[INFO] No swap partition found or created."
fi

echo "[DONE] Filesystem setup complete."
