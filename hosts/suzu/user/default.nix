{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../../shimenawa/user
    ../../shimenawa/user/graphical-env/hyprland
  ];

  wayland.windowManager.hyprland.settings = lib.mkIf config.wayland.windowManager.hyprland.enable {
    monitor = [
      "eDP-1,1920x1080,0x0,1.2"
    ];

  };

  services.mySyncthing.enable = true;

  services.syncthing.settings = {
    devices."gohei" = {
      id = "UDQDXQW-QAAOY3H-GBZ4EQ2-ZCT6KZA-V4DDW7P-OXK2TB4-JPPLDO6-25C32AR";
    };
    folders."share".devices = [
      "gohei"
    ];
    folders."screenshots".devices = [
      "gohei"
    ];
    folders."pixiv".devices = [
      "gohei"
    ];
  };
}
