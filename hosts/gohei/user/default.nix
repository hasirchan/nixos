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
    ../../shimenawa/user/pkgs/default.nix
    ../../shimenawa/user/pkgs/tex.nix
    ../../shimenawa/user/pkgs/retroarch.nix
    ../../torii/user/pkgs/email
  ];

  wayland.windowManager.hyprland.settings.env =
    lib.mkIf config.wayland.windowManager.hyprland.enable
      (
        lib.mkAfter [
          "AQ_DRM_DEVICES,/dev/dri/intel-igpu:/dev/dri/nvidia-dgpu"
        ]
      );
  services.mySyncthing.enable = true;
  services.syncthing.settings = {
    devices."suzu" = {
      id = "WRNUBG4-PX5UTMR-KUM527M-F75KALI-GAP5TW7-EHC62M7-BLD7FU2-WU2TMQO";
    };
    folders."share".devices = [
      "suzu"
    ];
    folders."screenshots".devices = [
      "suzu"
    ];
    folders."pixiv".devices = [
      "suzu"
    ];
  };
}
