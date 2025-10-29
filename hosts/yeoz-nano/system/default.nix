{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../_headful/system
    ../../_headful/system/graphical-env/sway
    ./overlays
  ];
  
  services.daed.enable = true;

  networking.hostName = "yeoz-nano";

  users.users.saya.extraGroups = [ "dialout" ];

}

