{ config, lib, ... }:
{
  imports = [
    ../../shimenawa/user
    ../../shimenawa/user/graphical-env/hyprland
    ../../shimenawa/user/pkgs/default.nix
    ../../shimenawa/user/pkgs/tex.nix
    ../../shimenawa/user/pkgs/retroarch.nix
  ];

  wayland.windowManager.hyprland.settings.env =
    lib.mkIf config.wayland.windowManager.hyprland.enable
      (
        lib.mkAfter [
          "AQ_DRM_DEVICES,/dev/dri/intel-igpu:/dev/dri/nvidia-dgpu"
        ]
      );
}
