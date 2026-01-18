{
  lib,
  bootMode,
  bootDevice,
  ...
}:
let
  bootCases = {
    "systemd-boot" = {
      grub.enable = false;
      generic-extlinux-compatible.enable = false;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = lib.mkDefault true;
    };
    "grub-efi" = {
      systemd-boot.enable = false;
      generic-extlinux-compatible.enable = false;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
      };
      efi.canTouchEfiVariables = true;
    };
    "grub-bios" = {
      systemd-boot.enable = false;
      generic-extlinux-compatible.enable = false;
      grub = {
        enable = true;
        device = bootDevice;
        efiSupport = false;
      };
    };
    "extlinux" = {
      grub.enable = false;
      systemd-boot.enable = false;
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
