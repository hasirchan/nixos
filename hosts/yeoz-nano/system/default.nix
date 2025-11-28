{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../_headful/system
    #../../_headful/system/graphical-env/sway
    ../../_headful/system/graphical-env/hyprland
    ./overlays
  ];

  networking.hostName = "yeoz-nano";

  users.users.saya.extraGroups = [ "dialout" ];

}

