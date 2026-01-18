{ config, lib, ... }:
{
  imports = [
    ../../shimenawa/user
    ../../shimenawa/user/graphical-env/hyprland
    ../../shimenawa/user/pkgs/retroarch.nix
  ];

  wayland.windowManager.hyprland.settings = lib.mkIf config.wayland.windowManager.hyprland.enable {
    monitor = [
      "eDP-1,1920x1080,0x0,1.2"
    ];

  };
}
