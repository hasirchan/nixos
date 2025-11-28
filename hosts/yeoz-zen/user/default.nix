{ config, lib, pkgs, ... }:

{
  imports = [
    ../../_headful/user
    # ../../_headful/user/graphical-env/sway
    ../../_headful/user/graphical-env/hyprland
    ../../_headful/user/pkgs/default.nix
    #../../_headful/user/pkgs/texlive.nix
    #../../_headful/user/pkgs/vscode.nix
    #../../_headful/user/pkgs/aseprite.nix

    # ./sway.nix
    # ./waybar.nix
  ];

  services.mySyncthing.enable = true;
  services.syncthing.settings = {
    devices."yeoz-nano" = {
      id = "WRNUBG4-PX5UTMR-KUM527M-F75KALI-GAP5TW7-EHC62M7-BLD7FU2-WU2TMQO";
    };
    folders."share".devices = [
      "yeoz-nano"
    ];
    folders."screenshots".devices = [
      "yeoz-nano"
    ];
    folders."pixiv".devices = [
      "yeoz-nano"
    ];
  };
}
