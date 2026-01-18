{ ... }:
{
  imports = [
    ./users.nix
    ./services.nix
    ./pkgs.nix
    ./firewall.nix
    ./bbr.nix
    ./zram.nix
    ./boot.nix
  ];

  time.timeZone = "Asia/Singapore";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  programs.mtr.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  system.stateVersion = "25.05";
}
