{ config, lib, pkgs, system, ... } :
{
  imports = [
    ./user-defined.nix
    ./services.nix
    ./pkgs.nix
    ./firewall.nix
    ./i2pd.nix
  ];

  time.timeZone = "Asia/Singapore";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
 
  boot.loader = if builtins.match ".*aarch64-linux.*" system != null then {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  } else {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.kernel.sysctl."kernel.sysrq" = 1;
  networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  programs.mtr.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  system.stateVersion = "25.05";
}
