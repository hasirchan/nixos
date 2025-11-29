{ config, lib, pkgs, ... }:

{
  imports = [
    ../../_headful/user
    #../../_headful/user/graphical-env/sway
    ../../_headful/user/graphical-env/hyprland
    #../../_headful/user/pkgs/texlive.nix
    #../../_headful/user/pkgs/anki.nix
    #../../_headful/user/pkgs/vscode.nix
    #../../_headful/user/pkgs/aseprite.nix
  ];

  wayland.windowManager.hyprland.settings = lib.mkIf config.wayland.windowManager.hyprland.enable {
    monitor = [
      "eDP-1,1920x1080,0x0,1.2"
    ];

  };

  services.mySyncthing.enable = true;

  services.syncthing.settings = {
    devices."yeoz-zen" = {
      id = "UDQDXQW-QAAOY3H-GBZ4EQ2-ZCT6KZA-V4DDW7P-OXK2TB4-JPPLDO6-25C32AR";
    };
    folders."share".devices = [
      "yeoz-zen"
    ];
    folders."screenshots".devices = [
      "yeoz-zen"
    ];
    folders."pixiv".devices = [
      "yeoz-zen"
    ];
  };
}
