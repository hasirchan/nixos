
{ config, lib, pkgs, ... }:

{
  boot.initrd.postResumeCommands = lib.mkAfter ''
    
    files_to_save="/etc/shadow /etc/machine-id"
    dirs_to_save=""

    log() {
      echo "[initrd] $1"
    }

    copy_item() {
      src="$1"
      dst="$2"
      type="$3" # file or dir

      if [ "$type" = "file" ]; then
        if [ -f "$src" ]; then
          log "Copying file $src to $dst"
          mkdir -p "$(dirname "$dst")"
          cp --reflink=auto "$src" "$dst"
        else
          log "Warning: file $src not exists, skip"
        fi
      elif [ "$type" = "dir" ]; then
        if [ -d "$src" ]; then
          log "Copying directory $src to $dst"
          mkdir -p "$(dirname "$dst")"
          cp -a --reflink=auto "$src" "$dst"
        else
          log "Warning: directory $src not exists, skip"
        fi
      fi
    }

    delete_subvolume_recursively() {
      log "Recursively deleting subvolumes inside $1"
      IFS=$'\n'
      for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
        delete_subvolume_recursively "/btrfs_tmp/$i"
      done
      log "Deleting subvolume $1"
      btrfs subvolume delete "$1"
    }

    log "Creating mount point /btrfs_tmp if it does not exist"
    mkdir -p /btrfs_tmp

    log "Mounting /dev/nvme0n1p3 to /btrfs_tmp"
    mount /dev/nvme0n1p3 /btrfs_tmp

    if [[ -e /btrfs_tmp/root ]]; then
      log "Existing /btrfs_tmp/root detected"
      
      for path in $files_to_save; do
        copy_item "/btrfs_tmp/root$path" "/btrfs_tmp/persist$path" "file"
      done

      for path in $dirs_to_save; do
        copy_item "/btrfs_tmp/root$path" "/btrfs_tmp/persist$path" "dir"
      done

      log "Preparing to move old root subvolume"
      mkdir -p /btrfs_tmp/old_roots
      timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H-%M-%S")
      log "Moving /btrfs_tmp/root to /btrfs_tmp/old_roots/$timestamp"
      mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi
    
    log "Deleting old subvolumes older than 30 days under /btrfs_tmp/old_roots/"
    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
      delete_subvolume_recursively "$i"
    done

    log "Creating new subvolume /btrfs_tmp/root"
    btrfs subvolume create /btrfs_tmp/root
    
    for path in $files_to_save; do
      copy_item "/btrfs_tmp/persist$path" "/btrfs_tmp/root$path" "file"
    done

    for path in $dirs_to_save; do
      copy_item "/btrfs_tmp/persist$path" "/btrfs_tmp/root$path" "dir"
    done
    log "Unmounting /btrfs_tmp"
    umount /btrfs_tmp
    rmdir /btrfs_tmp
  '';
}
