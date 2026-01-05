{
  config,
  lib,
  pkgs,
  bootMode,
  bootDevice,
  ...
}:

let
  bootCases = {
    "systemd-boot" = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    "grub-efi" = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
      };
      efi.canTouchEfiVariables = true;
    };
    "grub-bios" = {
      grub = {
        enable = true;
        device = bootDevice;
        efiSupport = false;
      };
    };
    "uboot" = {
      generic-extlinux-compatible.enable = true;
    };
  };

  selectedConfig = bootCases."${bootMode}" or { };

in
{
  assertions = [
    {
      assertion = bootCases ? "${bootMode}";
      message = "Error! Invalid bootMode: '${bootMode}'. Must be one of: ${lib.concatStringsSep ", " (builtins.attrNames bootCases)}";
    }
  ];

  boot.loader = selectedConfig;
  boot.kernel.sysctl."kernel.sysrq" = 1;
}
