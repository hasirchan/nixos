{ config, lib, pkgs, isLabtop, ... }:
{

  imports = [
    ./reminder.nix
    ./style.nix
  ];

  wayland.windowManager.sway.config.bars = [{ command = "waybar"; }];
  programs.waybar = {
    enable = true;
    settings = lib.mkDefault [
      (import ./settings.nix { inherit lib pkgs isLabtop; })
    ];

  };
}
