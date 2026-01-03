{ config, lib, pkgs, bootMode, ... }:

{
  boot.loader = {
    systemd-boot.enable = lib.mkIf (bootMode == "systemd-boot") true;
    efi.canTouchEfiVariables = lib.mkIf (bootMode == "systemd-boot" || bootMode == "grub-efi") true;

    generic-extlinux-compatible = {
      enable = lib.mkIf (bootMode == "uboot") true;
    };

    grub = lib.mkMerge [
      { enable = lib.mkDefault false; }
      (lib.mkIf (bootMode == "grub-efi") {
        enable = true;
        device = "nodev";
        efiSupport = true;
      })
      (lib.mkIf (bootMode == "grub-bios") {
        enable = true;
        device = lib.mkDefault "/dev/vda"; 
        efiSupport = false;
      })
      (lib.mkIf (bootMode == "") {
        enable = true;
        device = lib.mkDefault "/dev/vda"; 
        efiSupport = false;
      })
    ];
  };
  boot.kernel.sysctl."kernel.sysrq" = 1;
}
